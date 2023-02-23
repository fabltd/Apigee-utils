#!/bin/bash

# Test set zone
gcloud config set compute/zone us-east1-b

#Set zone
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

# Provison VM with TerraForm
cd ~/Apigee-utils/setup/install/lab1/terraform
terraform init 
terraform apply -auto-approve -var="project_id=$GOOGLE_CLOUD_PROJECT"

# Loop to wait for VM to enter the RUNNING status
while :
do
    export STATUS=$(gcloud compute instances describe legacy-api | grep status)

    if [ "$STATUS" == "status: RUNNING" ]
        then
        echo "VM Running"
        break

    else
        echo "VM Not Ready - state: $STATUS"
    fi
done


# Install Dataset
cd ~/Apigee-utils/setup/data/
npm install

echo "Setup test data"
npm start