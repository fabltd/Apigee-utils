#!/bin/bash
cd ~/Apigee-utils/mTLS

echo -e "Testing mTLS Certs"

export COMPUTE_ZONE=$(gcloud config get-value compute/zone)
gcloud config set compute/zone $COMPUTE_ZONE

# Add HTTPS firewall rule
echo -e "Enabling HTTPS firewall rule"
gcloud compute firewall-rules create script-https --allow=tcp:443 --description="Allow HTTPS - 443" --direction=INGRESS

IP=$(gcloud compute instances describe gateway --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

curl -k https://$IP \
 --cacert ./ca/ca.crt \
 --key ./apigee/apigee.key \
 --cert ./apigee/apigee.crt \
| grep 'Shipping'

