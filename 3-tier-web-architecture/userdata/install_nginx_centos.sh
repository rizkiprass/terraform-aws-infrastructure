#!/bin/bash
sudo yum update -y

# Install the EPEL repository
sudo yum install epel-release -y

# Install Nginx
sudo yum install nginx -y

systemctl enable nginx
systemctl start nginx

domain=rp-server.site
root="/usr/share/nginx/html/$domain"
block="/etc/nginx/conf.d/$domain.conf"

# Create the Document Root directory
sudo mkdir -p $root

# Create the index.html:
echo "<h1>welcome</h1>" | sudo tee $root/index.html

# Remove default Nginx configuration
sudo rm /etc/nginx/conf.d/default.conf

# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF
server {
        listen 80;

        root $root;
        index index.html;

        server_name $domain;

        location / {
                try_files \$uri \$uri/ =404;
        }
}
EOF

# Test configuration and reload if successful
sudo nginx -t && sudo systemctl reload nginx