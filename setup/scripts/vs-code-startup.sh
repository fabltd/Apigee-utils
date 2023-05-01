#!/bin/bash

# Update Package Repo
sudo apt-get update

# Install Packages required for Docker install
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

#Add Docker’s official GPG key
sudo rm  /etc/apt/keyrings/docker.gpg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 

#Set Docker Repoistory
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 

#Update Package changes
sudo apt-get update

#Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

#Enable docker for current user
sudo usermod -a -G docker ${USER}

#Install VS Code Server
wget https://code-server.dev/install.sh
chmod +x install.sh
./install.sh  --version 4.1.0 

#Add config dir
rm -rf ~/.config/
mkdir ~/.config/
mkdir ~/.config/code-server

#Add default config - password: letmein
cp ./config.yaml ~/.config/code-server/config.yaml

# Enable VS Code Service
sudo systemctl enable --now code-server@$USER
