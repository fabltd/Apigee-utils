#!/bin/bash
cd ~/Apigee-utils
mkdir mTLS
cd mTLS

echo -e "Creating a certificate authority (CA) \n "

mkdir ./ca
openssl req \
  -newkey rsa:4096 \
  -x509 \
  -keyout ./ca/ca.key \
  -out ./ca/ca.crt \
  -days 365 \
  -nodes \
  -subj "/CN=CA"

echo -e "\n"
echo -e "Creating a signed:- Server key and certificate \n "

mkdir server
openssl req \
  -newkey rsa:4096 \
  -keyout ./server/server.key \
  -out ./server/server.csr \
  -nodes \
  -subj "/CN=Server"
   #-days 365 \

openssl x509 \
  -req \
  -in ./server/server.csr \
  -out ./server/server.crt \
  -CA ./ca/ca.crt \
  -CAkey ./ca/ca.key \
  -CAcreateserial \

echo -e "\n"
echo -e "Creating a signed:- Client key and certificate \n"

mkdir apigee
openssl req \
  -newkey rsa:4096 \
  -keyout ./apigee/apigee.key \
  -out ./apigee/apigee.csr \
  -nodes \
  -subj "/CN=Apigee"
   #-days 365 \

openssl x509 \
  -req \
  -in ./apigee/apigee.csr \
  -out ./apigee/apigee.crt \
  -CA ./ca/ca.crt \
  -CAkey ./ca/ca.key \
  -days 365 \
  -CAcreateserial \

cd ~