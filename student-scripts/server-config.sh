#!/bin/bash

echo -e "Setting compute engine zone"
# Set zone of gateway VM
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE
echo -e "\n"

cd ~/Apigee-utils/student-scripts

#---------------------------------------#
#Check if mTLS Scripts exist
if [ -d "../mTLS" ] 
then
    echo "Well done mTLS scripts present" 
else
    echo -e "mTLS Scripts missing - creating"
    ./certs.sh
fi
#---------------------------------------#
echo -e "Copying Certs to gateway"
# Set Path for Certs
cd ~/Apigee-utils/mTLS
# Copy Certs to temp on server
gcloud compute scp ./server/server.crt ./server/server.key ./ca/ca.crt gateway:/tmp/
echo -e "\n"

#---------------------------------------#
echo -e "Copying NGINX config to gateway"
# Set Path for Configs
cd ~/Apigee-utils/student-scripts
# Copy Config to temp on server
gcloud compute scp ./config/reverse-proxy.conf gateway:/tmp/
echo -e "\n"

#---------------------------------------#
echo -e "Installing Files"
# Move certs to 
gcloud compute ssh gateway --command "sudo mkdir /etc/nginx/certs"
gcloud compute ssh gateway --command "sudo cp -rlf /tmp/server.crt /tmp/server.key /tmp/ca.crt /etc/nginx/certs"
gcloud compute ssh gateway --command "sudo cp -rlf /tmp/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf"
echo -e "\n"

echo -e "Checking certs are installed "
# Check Certs are installed
gcloud compute ssh gateway --command "ls /etc/nginx/certs"
echo -e "\n"

#Check the reverse proxy config has changed
echo -e "Display NGINX configuration"
gcloud compute ssh gateway --command "cat /etc/nginx/sites-enabled/reverse-proxy.conf"
echo -e "\n"

#Check the reverse proxy config has changed
echo -e "Restarting NGINX"
gcloud compute ssh gateway --command "sudo service nginx restart"
echo -e "\n"
