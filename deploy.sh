#!/bin/bash

echo "Keys available"
ls -l ~/.ssh

# Private key to authenticate
read -p "Enter the name of your private key:" privateKey

# Local host folder/file to copy
read -p Enter the local folder/file path to copy: " localPath

# Remote host IP
read -p "Enter the remote host IP: " ipAddress

# Remote Destination Path
read -p "Enter Remote Destination Path: " remotePath

# Remote user account
read -p "Enter your remote username: " userName

echo "Private Key Name: ${privateKey}"
echo "Remote IP: ${ipAddress}"
echo "Remote Destination: ${remotePath}"

# rsync command
rsync -avz -e "ssh -i ~/.ssh/${privateKey}"  ${localPath} ${userName}@${ipAddress}:${remotePath}