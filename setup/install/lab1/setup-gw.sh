#!/bin/bash

# Test set zone
#gcloud config set compute/zone us-central1-a

#echo "Zone = us-central1-a"

#Set zone
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

#export COMPUTE_REGION=${COMPUTE_ZONE::-2}
echo Please enter you compute region - Note this is NOT the Zone!?
read COMPUTE_REGION
gcloud config set compute/zone $COMPUTE_REGION

# Provison VM with TerraForm
cd ~/Apigee-utils/setup/install/init/lab1-part3
terraform init 
terraform apply -auto-approve -var="project_id=$GOOGLE_CLOUD_PROJECT" -var="region"=$(gcloud config get-value compute/region) -var="zone"=$(gcloud config get-value compute/zone)

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

            # Remove Public IP from Legacy 
             gcloud compute instances delete-access-config legacy-api

        break

    else
        echo "Waiting..."
    fi
done
