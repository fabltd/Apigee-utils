#!/bin/bash

#Generate GCP Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
export ORG=$GOOGLE_CLOUD_PROJECT
#Apigee Enviroment
export ENV=eval

# Get Apigee Host from Apigee
HOST=$(curl -s "https://apigee.googleapis.com/v1/organizations/$ORG/envgroups/eval-group" \
    -X GET \
    -H "Authorization: Bearer $TOKEN" \
    | jq ".hostnames[1]" -r
    )
  
echo "Trying Apigee Host: $HOST" 


# Fetching valid recapture Key
KEY=$(curl -s  "https://recaptchaenterprise.googleapis.com/v1/projects/$ORG/keys/" \
    -X GET \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json; charset=utf-8" \
     | jq -c '.keys[] | select(.displayName | contains("Show-me-now-good-actor")) | .name | split("/")[3] ' -r
     )

echo "Using site Key: $KEY"  

#Request Recapture Token from user
echo "Paste recapture token from tester:"
read RECAPTURE

# curl command to test Apigee proxy with recapture enabled         
curl -k https://"$HOST/show-me-now/v0/customers" \
-H "x-recaptcha-key: $KEY" \
-H "x-recaptcha-token: $RECAPTURE"

#New Line
echo ;