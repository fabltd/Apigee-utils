#!/bin/bash

#Set compute engine Zone
gcloud config set compute/zone us-east1-b

#Setup PortForward
echo -e "Setup SSH Tunnel"
gcloud compute ssh vs-code-server  -- -NL 8080:localhost:8080
