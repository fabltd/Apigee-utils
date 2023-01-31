#!/bin/bash

#Generate GCP Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
export ORG=$GOOGLE_CLOUD_PROJECT
#Apigee Enviroment
export ENV_GROUP=eval-group

# Get Source Code
cd ~
rm -rf apigee-show-me-now
git clone https://github.com/fabltd/apigee-show-me-now.git

# Clear Config and set defaults
cd ~/apigee-show-me-now/src/
rm -rf environments
mkdir environments
cd environments
cp ~/Apigee-utils/student-scripts/config/base-config.conf .

# Get Apigee Host from Apigee
HOST=$(curl -s "https://apigee.googleapis.com/v1/organizations/$ORG/envgroups/$ENV_GROUP" \
    -X GET \
    -H "Authorization: Bearer $TOKEN" \
    | jq  -r ".hostnames[1]"
     )
  
echo -e "Updating Apigee Host: $HOST \n" 

#Set Base URL
sed -i "/url:/c\url: ," ./base-config.conf
sed -i 's~url:~url:\x27https://'$HOST'/show-me-now/v0/\x27~g' ./base-config.conf

#Request Recapture Token from user
#echo "Paste you recapture site key for show-me-now-real:"
#read SITETOKEN

# Fetching valid recapture Key
SITETOKEN=$(curl -s "https://recaptchaenterprise.googleapis.com/v1/projects/$ORG/keys/" \
    -X GET \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json; charset=utf-8" \
     | jq -c '.keys[] | select(.displayName | ascii_downcase | contains("show-me-now-real")) | .name | split("/")[3] ' -r
     )

echo -e "Using site Key: $SITETOKEN \n" 


#Set Recapture
sed -i "/recaptcha:/c\recaptcha:," ./base-config.conf
sed -i 's~recaptcha:~recaptcha:\x27'$SITETOKEN'\x27~g' ./base-config.conf


#Fetch Firebase App ID
APPID=$(curl -s  "https://firebase.googleapis.com/v1beta1/projects/$ORG/webApps" \
    -X GET \
    -H "Authorization: Bearer $TOKEN" \
    -H "content-type:application/json" \
    |  jq -c '.apps[0].appId' -r
    )


curl -s "https://firebase.googleapis.com/v1beta1/projects/-/webApps/$APPID/config" \
    -X GET \
    -H "Authorization: Bearer $TOKEN" \
    -H "content-type:application/json" \
    | jq '.' | sed -E 's/(^ *)"([^".:-]*)":/\1\2:/' > config.fire 
    
#Add Comma
sed -i 's~}~'},'~g' config.fire

sed -i "/firebaseConfig:/c\firebaseConfig:" ./base-config.conf

#Add Config to base 
awk 'FNR==NR {a[i++]=$0;next} /firebaseConfig/ {print; for(i=0;i in a;i++) print a[i];next}1' config.fire base-config.conf >> environment.ts

# Build locally 
echo -e "Building container" 

cd ~
cd apigee-show-me-now
docker build -t show-me-now .

# Run as deamon
docker run -d -p 8080:80 show-me-now
echo -e "Container running\n" 