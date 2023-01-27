#!/bin/bash

# Test set zone
gcloud config set compute/zone us-east1-b

#Set zone
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

# Provison VM with TerraForm
cd ~/Apigee-utils/setup/terraform/complete/terraform
terraform init 
terraform apply -auto-approve -var="project_id=$GOOGLE_CLOUD_PROJECT"

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
    export ID=$(gcloud compute ssh vs-code-server --command "cat /etc/os-release" | grep -w 'ID')

    if [ "$ID" == "ID=ubuntu" ]
        then
        echo "Installing Gateway Config"
            #Change DIR
            cd ~/Apigee-utils/setup/scripts/

            #Run the init script
            ./gateway-init.sh

            # Setup FireBase
            cd ~/Apigee-utils/setup/data/
            npm install

            echo "Setup test data"
            npm start

        break

    else
        echo "Waiting..."
    fi
done
