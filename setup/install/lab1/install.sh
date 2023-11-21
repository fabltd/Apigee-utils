#!/bin/bash

# Set zone
#gcloud config set compute/zone us-central1-a

#Set zone
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

#Set Region from zone
export COMPUTE_REGION=${COMPUTE_ZONE::-2}
gcloud config set compute/region $COMPUTE_REGION

# Provison VM with TerraForm
cd ~/Apigee-utils/setup/install/lab1/apigee-terraform
terraform init
terraform apply -auto-approve -var="gcp_project_id=$GOOGLE_CLOUD_PROJECT" -var="gcp_region"=$(gcloud config get-value compute/region) -var="gcp_zone"=$(gcloud config get-value compute/zone)

