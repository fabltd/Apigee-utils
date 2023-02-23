#!/bin/bash

#Generate Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
ORG=$GOOGLE_CLOUD_PROJECT

# Create DataCollectors on Apigee for custom analytics data reports (risk score and token validity)
echo "Creating validity DC" 
curl -s "https://apigee.googleapis.com/v1/organizations/"$ORG"/datacollectors" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"name":"dc_tokenValidity","description":"data collection of Enterprise reCAPTCHA token validity","type":"STRING"}'


echo "Creating validity Dash Board" 
curl -s "https://apigee.googleapis.com/v1/organizations/"$ORG"/reports" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
     -d @./config/token-report.json

echo "Creating risk score DC"
curl -s  "https://apigee.googleapis.com/v1/organizations/"$ORG"/datacollectors" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"name":"dc_riskScore","description":"data collection of Enterprise reCAPTCHA risk score","type":"FLOAT"}'
  

echo "Creating validity risk score Dashboard" 
curl -s "https://apigee.googleapis.com/v1/organizations/"$ORG"/reports" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d @./config/risk-report.json

echo "Provisiong update shared-flow" 
  curl "https://apigee.googleapis.com/v1/organizations/$ORG/sharedflows?action=import&name=reCaptureV1" \
    -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "application/octet-stream" \
    -F 'data=@../setup/install/lab8/sf-reCapture/sf-reCapture-data-collector.zi'
         