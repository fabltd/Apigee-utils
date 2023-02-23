#!/bin/bash

#Generate Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
ORG=$GOOGLE_CLOUD_PROJECT

# Create DataCollectors on Apigee for custom analytics data reports (risk score and token validity)
echo "Deleting Organisation" 
curl -s "https://apigee.googleapis.com/v1/organizations/"$ORG"" \
     -X DELETE \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
 
