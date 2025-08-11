# Static Site Server

This is a project from [roadmap.sh](https://roadmap.sh/projects/static-site-server).  
The goal is to learn how to configure and host a static website using **NGINX**.
In this project we will deploy our code using rsync.

---

## 1. Project Overview

The server is configured to:  
- Host a static website using **NGINX**.  
- Allow secure remote administration via **SSH** (restricted to a trusted IP range).  
- Enable **ICMP** (ping) and **rsync** only from the trusted IP range.  
- Serve the site over HTTP (80) and HTTPS (443).  
- Restrict outbound traffic to only required services (e.g., DNS).  
- A later project will explain how to configure a domain.

---

## 2. Requirements

- Ubuntu/Debian-based Linux server.  
- Sudo privileges.  
- NGINX installed.  
- Rsync (already installed if you are on MacOS like me)
- A static or known IP block for admin access on port 22 (or one of your choice)
- A static HTML site; for my project, it was a really simple html page with css and JavaScript files.
- Public/private SSH key pair for SSH authentication.

---

## 3. Steps

### Install and Configure NGINX  

Connect to your server  and type the following commands to install start NGINX.
```bash
sudo apt update && sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

### Pushing your code to your server
[Rsyinc](https://rsync.samba.org/) is great tool to copy folders and files to a remote host. Like the project specified, I wrote a small bash script to do it. You just have to answer the different prompts or make your own script from this example.

By default, NGINX looks for html files in the `/var/www` folder. This is where I transfer my local directory.

```bash
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
```

### Modifying the NGINX config file
Before modifying our file, make sure NGINX is online with the following command :

```
curl -k https://127.0.0.1
```

You should see the NGINX welcome page in your terminal,

The config file is locate at `/etc/nginx/nginx.conf`

At this point, it is not necessary to modify it. We have to create a new file in the `/etc/nginx/sites-available` directory.

Navigate to the folder and copy the default file. We will modify the copy to adapt it to our website.

You should see a section like this. Change the root location to where you copied your folder with rsync. Save and quit.
```
#server {
#	listen 80;
#	listen [::]:80;
#
#	server_name example.com;
#
#	root /var/www/example.com;
#	index index.html;
#
#	location / {
#		try_files $uri $uri/ =404;
#	}
#}
```
Restart Nginx to apply your changes. 

```
sudo systemctl restart nginx

```

If you curl the loopback adress, you should see your html code in your terminal.

You can also access the site from your local browser by typing the naked IP in the URL bar. Later on, we'll see how to use a domain name instead of an IP.

### Configuring the firewall
My hosting is provided by Digital Ocean so I am responsible for the incurring costs. Be really careful if you intend to use cloud services for testing like. My Droplet is turned off when I am not using it and traffic is restricted through a firewall provided by Digital Ocean. For inbound and outbound rules, everything is minimal. Make sure you understand what you are doing.


