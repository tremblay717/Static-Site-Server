#!/bin/bash

echo "Keys available"
ls -l ~/.ssh

# Private key to authenticate
read -p "Enter the name of your private key:" privateKey

# Remote host IP
read -p "Enter the remote host IP: " ipAddress

# Remote Destination Path
read -p "Enter Remote Destination Path: " remotePath

echo "Private Key Name: ${privateKey}"
echo "Remote IP: ${ipAddress}"
echo "Remote Destination: ${remotePath}"

# rsync command
rsync -avz -e "ssh -i ~/.ssh/${privateKey}"  ~/Desktop/repos/Static-Site-Server/html root@${ipAddress}:${remotePath}