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
export ENV=eval

#API Name
export APINAME=SMN-Labs

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

echo "Installing proxy: $APINAME"

curl "https://apigee.googleapis.com/v1/organizations/$ORG/apis?action=import&name=$APINAME" \
-X POST \
-H "Authorization: Bearer $TOKEN" \
-H "application/octet-stream" \
-F 'data=@./SMN-base.zip'

echo "Deploying proxy: $APINAME to Enviroment $ENV"

curl "https://apigee.googleapis.com/v1/organizations/$ORG/environments/$ENV/apis/$APINAME/revisions/1/deployments?override=true" \
  -X POST \
  -H "Authorization: Bearer $TOKEN"
