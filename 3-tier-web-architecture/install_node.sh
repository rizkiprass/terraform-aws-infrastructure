#!/bin/bash
sudo apt-get update
sudo apt-get install -y nodejs
apt install npm -y

cd /home/ubuntu
sudo touch test1.txt
touch test2.txt
git clone https://github.com/rizkiprass/rp-medium-node.git
cd ./rp-medium-node
sudo npm i

sudo npm install -g pm2
pm2 start server.js
pm2 list
