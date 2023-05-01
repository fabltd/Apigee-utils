#!/bin/bash

#Generate Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
export ORG=$GOOGLE_CLOUD_PROJECT

#Apigee Enviroment
export ENV=eval

# Add shared flow
  curl "https://apigee.googleapis.com/v1/organizations/$ORG/sharedflows?action=import&name=reCaptureV1" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "application/octet-stream" \
    -F 'data=@../setup/install/lab6/sf-reCapture/sf-reCapture-lab6.zip'
         