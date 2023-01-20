echo -e "Installing NGIX Gateway"
# Set zone of legacy VM
export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

# Get legacy IP Address
apiIP=$(gcloud compute instances describe legacy-api --format='get(networkInterfaces[0].networkIP)')
echo -e "Legacy API IP:" $apiIP

# Get gateway IP Address
gwIP=$(gcloud compute instances describe gateway --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
echo -e "Gateway IP:" $gwIP

#Add IP to Config files
sed -i 's#http://*.*.*.*;#http://'$apiIP';#g' ./config/proxy-basic.conf
sed -i 's#http://*.*.*.*;#http://'$apiIP';#g' ~/Apigee-utils/student-scripts/config/reverse-proxy.conf

echo -e "\n"

echo -e "Install packages"
# Install NGINX
gcloud compute ssh gateway --command "yes Y | sudo apt-get update"
gcloud compute ssh gateway --command "yes Y | sudo apt-get install nginx"
gcloud compute ssh gateway --command "sudo unlink /etc/nginx/sites-enabled/default"
echo -e "\n"

echo -e "Add NGIX config"
# Add basic config
gcloud compute scp ./config/proxy-basic.conf gateway:/tmp/reverse-proxy.conf
gcloud compute ssh gateway --command "sudo cp -rlf /tmp/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf"
echo -e "\n"

#Check the reverse proxy config has changed
echo -e "Display NGINX configuration"
gcloud compute ssh gateway --command "cat /etc/nginx/sites-enabled/reverse-proxy.conf"
echo -e "\n"

#Check the reverse proxy config has changed
echo -e "Restarting NGINX"
gcloud compute ssh gateway --command "sudo service nginx restart"
echo -e "\n"

# Call proxy and check HTTP response
curl -k http://$gwIP | grep 'Shipping'