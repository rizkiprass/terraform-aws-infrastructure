#!/bin/bash
sudo apt-get update
sudo apt install nginx -y

domain=rprass.my.id
root="/var/www/$domain"
block="/etc/nginx/sites-available/react"

# Create the Document
sudo mkdir -p $root
sudo touch $block

# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF
server {
  listen 80 default_server;
  server_name _;

  # react app & front-end files
  location / {
    root /var/www/rprass.my.id;
    try_files $uri /index.html;
  }

  # node api reverse proxy
  location /api/data {
    proxy_pass http://172.31.6.109:8080/;
  }
}
EOF
sudo ln -s /etc/nginx/sites-available/react /etc/nginx/sites-enabled/
# Test configuration and reload if successful
sudo nginx -t && sudo systemctl reload nginx


#Install React
sudo apt install npm -y #fix it
sudo chown -R root ~/.npm
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y

cd /home/ubuntu
git clone https://github.com/rizkiprass/rp-medium-react.git
sudo npm i
sudo npm run build
sudo cp -R /home/ubuntu/rp-medium-react/build/ /var/www/html/rprass.my.id


#to run use sudo npm run start

#sudo cp -R /home/ubuntu/rp-medium-react/build/ /var/www/html/rprass.my.id