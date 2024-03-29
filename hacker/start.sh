#!/bin/bash
#Start Hacker Page

#Generate GCP Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
export ORG=$GOOGLE_CLOUD_PROJECT
#Apigee Enviroment
export ENV=test-env

# Get Apigee Host from Apigee
HOST=$(curl -s "https://apigee.googleapis.com/v1/organizations/$ORG/envgroups/test-env-group" \
    -X GET \
    -H "Authorization: Bearer $TOKEN" \
    | jq ".hostnames[0]" -r
    )
  
echo "Updating Apigee Host: $HOST" 
sed -i 's~https://null/show-me-now/v0/~https://'$HOST'/show-me-now/v0/~g' index.html

#Start server
npm install --silent
npm start