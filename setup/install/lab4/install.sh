#!/bin/bash

# Set zone
gcloud config set compute/zone us-central1-a

#Set zone
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

# Provison VM with TerraForm
#cd ~/Apigee-utils/setup/install/init/lab2+
#terraform apply -auto-approve -var="project_id=$GOOGLE_CLOUD_PROJECT"

# Loop to wait for VM to enter the RUNNING status
while :
do
    export STATUS=$(gcloud compute instances describe gateway | grep status)

    if [ "$STATUS" == "status: RUNNING" ]
        then
        echo "VM Running"
        break

    else
        echo "VM Not Ready - state: $STATUS"
    fi
done


# Loop to makes SSH Call to VM and checks OS is unbuntu
while :
do
    export ID=$(gcloud compute ssh gateway --command "cat /etc/os-release" | grep -w 'ID')

    if [ "$ID" == "ID=ubuntu" ]
        then
        echo "Installing Gateway Config"
            #Change DIR
            cd ~/Apigee-utils/setup/scripts/

            #Run the init script
            ./gateway-startup.sh

            # Setup FireBase
            cd ~/Apigee-utils/setup/data/
            npm install

            echo "Setup test data"
            npm start

            # Remove Public IP from Legacy
            gcloud compute instances delete-access-config legacy-api

            # Create TLS Certs
            cd ~/Apigee-utils/student-scripts
            ./certs.sh

            # ADD mTLS - Adds Firewall 
            ./server-config.sh

            # Test mLTS 
            ./mTLS-test.sh



        break

    else
        echo "Waiting..."
    fi
done

#Generate Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
export ORG=$GOOGLE_CLOUD_PROJECT

#Apigee Enviroment
export ENV=test-env

#API Name
export APINAME=SMN-Labs

#Service Account 
export SA=sa-apigee-google-services@$ORG.iam.gserviceaccount.com

echo "Installing TLS certificates to Apigee enviroment: $ENV"

# Add KeyStore
 curl "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/keystores" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "content-type:application/json" \
    -d '{"name":"'"gateway"'" }' 

# Add mTLS Client Key & Cert
curl "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/keystores/gateway/aliases?alias=mtls-alias&format=keycertfile" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "content-type:multipart/form-data" \
    -F keyFile="@../mTLS/apigee/apigee.key" \
    -F certFile="@../mTLS/apigee/apigee.crt" 
   
curl "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/keystores/gateway/aliases?alias=mtls-ca&format=keycertfile" \
-X POST \
-H "Authorization: Bearer $TOKEN" \
-H "content-type:multipart/form-data" \
-F certFile="@../mTLS/ca/ca.crt" 


echo "Updating proxy with gateway IP"

# Install XML Editor
sudo apt-get install xmlstarlet

# Extract API Proxy
cd ~/Apigee-utils/setup/install/lab4
unzip -o SMN-base-4.zip

# Get gateway IP Address
GWIP=$(gcloud compute instances describe gateway --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
echo -e "Gateway IP:" $GWIP

# Edit proxy - updating target IP
xmlstarlet ed --inplace -u 'TargetEndpoint/HTTPTargetConnection/URL' --value 'https://'$GWIP'/v1/{dynamic_path}' ./apiproxy/targets/default.xml 

# Rezip Proxy
zip -r -o SMN-base-4.zip apiproxy

echo "Installing proxy: $APINAME"

curl "https://apigee.googleapis.com/v1/organizations/$ORG/apis?action=import&name=$APINAME" \
-X POST \
-H "Authorization: Bearer $TOKEN" \
-H "application/octet-stream" \
-F 'data=@./SMN-base-4.zip'

echo "Deploying proxy: $APINAME to Enviroment $ENV"

curl "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/apis/$APINAME/revisions/1/deployments?override=true?serviceAccount=$SA" \
  -X POST \
  -H "Authorization: Bearer $TOKEN"

echo "Creating API product"

curl "https://apigee.googleapis.com/v1/organizations/$ORG/apiproducts" \
  -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "content-type:application/json" \
  -d @./config/api-product.json

echo "Creating Developer"

curl "https://apigee.googleapis.com/v1/organizations/$ORG/developers/" \
  -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "content-type:application/json" \
  -d '{
  "email": "abischof1d@google.com",
  "firstName": "Anastasia",
  "lastName": "Bischof",
  "userName": "ab1d"
 }'

echo "Creating API APP"
curl "https://apigee.googleapis.com/v1/organizations/$ORG/developers/abischof1d@google.com/apps" \
  -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "content-type:application/json" \
  -d @./config/api-app.json


echo "Done - Return to Apigee"