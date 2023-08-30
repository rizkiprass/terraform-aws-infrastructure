#!/bin/bash
# package updates
sudo yum update -y
# apache installation, enabling and status check
echo "Installing httpd"
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl status httpd | grep Active

# apache configuration
domain=test.com
root="/var/www/html/public"
block="/etc/httpd/conf.d/test.conf"

sudo mkdir -p $root

cat << EOF > $block
<VirtualHost *:80>
    ServerName test.com
    DocumentRoot $root
    ErrorLog /var/log/httpd/example.com-error_log
    CustomLog /var/log/httpd/example.com-access_log combined
</VirtualHost>
EOF


# Disabling Apache welocme page
mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf_backup
systemctl reload httpd

# install php
echo "Installing php"
yum install amazon-linux-extras -y
amazon-linux-extras enable php7.4
yum install php-cli php-xml php-json php-mbstring php-process php-common php-fpm php-zip php-mysqlnd git -y
php --version

# Install Codedeploy Agent
echo "Installing codedeployagent"
sudo yum install ruby -y
sudo yum install wget -y
CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
$CODEDEPLOY_BIN stop
yum erase codedeploy-agent -y
cd /home/ec2-user
wget https://aws-codedeploy-us-west-2.s3.us-west-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo service codedeploy-agent status