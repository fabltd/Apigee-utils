#!/bin/bash

#Generate Access Token
export TOKEN=$(gcloud auth print-access-token)

#Set Enviroment Vars
ORG=$GOOGLE_CLOUD_PROJECT

#Apigee Enviroment
ENV=eval

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
