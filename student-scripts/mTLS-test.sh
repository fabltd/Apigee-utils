#!/bin/bash
cd ~/Apigee-utils/mTLS

echo -e "Testing mTLS Certs"

gcloud config set compute/zone us-east1-b
IP=$(gcloud compute instances describe gateway --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

curl -k https://$IP \
 --cacert ./ca/ca.crt \
 --key ./apigee/apigee.key \
 --cert ./apigee/apigee.crt \
| grep 'Shipping'

