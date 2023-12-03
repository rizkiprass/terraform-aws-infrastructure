#!/bin/bash
sudo apt update -y
sudo apt install ruby-full -y
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile

sudo service codedeploy-agent status
sudo service codedeploy-agent start
sudo service codedeploy-agent status