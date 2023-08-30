#!/bin/bash
sudo apt-get update
sudo apt install nginx -y

domain=rprass.my.id
root="/var/www/$domain"
block="/etc/nginx/conf.d/react.conf"

# Create the Document
sudo mkdir -p $root
sudo touch $block

# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF
server {
  listen 80;
  listen [::]:80;
  root $root;

  #react app
  location / {
    try_files $uri /index.html;
  }

  #node api reverse proxy
  location /api/user {
    proxy_pass http://10.0.2.42:8080/api/user;
  }
}
EOF

# Test configuration and reload if successful
sudo nginx -t && sudo systemctl reload nginx


#Install React
sudo apt install npm -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
mkdir /home/ubuntu/react-app