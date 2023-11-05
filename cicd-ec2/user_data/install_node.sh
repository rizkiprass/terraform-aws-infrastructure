#!/bin/bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y
sudo apt install npm -y

mkdir /home/ubuntu/test

cd /home/ubuntu
sudo touch test1.txt
touch test2.txt
git clone -b dev https://github.com/rizkiprass/rp-medium-node.git
cd ./rp-medium-node
sudo npm i

sudo npm install -g pm2
pm2 start server.js
pm2 list
