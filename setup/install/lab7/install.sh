#!/bin/bash

# Test set zone
#gcloud config set compute/zone us-east1-b

#Set zone
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

#Set Region from zone
export COMPUTE_REGION=${COMPUTE_ZONE::-2}
gcloud config set compute/region $COMPUTE_REGION

# Provison VM with TerraForm
cd ~/Apigee-utils/setup/install/lab7/terraform
terraform init 
terraform apply -auto-approve -var="project_id=$GOOGLE_CLOUD_PROJECT" -var="region"=$(gcloud config get-value compute/region) -var="zone"=$(gcloud config get-value compute/zone)

# Loop to wait for VM to enter the RUNNING status
while :
do
    export STATUS=$(gcloud compute instances describe vs-code-server | grep status)

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
        echo "Installing VS-Code"
            #Change DIR
            cd ~/Apigee-utils/setup/scripts/

            #Copy the install script
            echo -e "Add setup tools"
            gcloud compute scp ./vs-code-startup.sh vs-code-server:~/

            #Copy the default config
            echo -e "Copy default config"
            gcloud compute scp ./config/code-server-config.yaml vs-code-server:~/config.yaml
            
            # Run Install
            echo -e "Install packages"
            gcloud compute ssh vs-code-server --command './vs-code-startup.sh'

        break

    else
        echo "Waiting..."
    fi
done

 echo "Done !!!!"

