#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# package updates
sudo apt update -y
sudo apt upgrade -y
# apache installation, enabling and status check
sudo apt -y install apache2
sudo systemctl enable apache2.service
sudo systemctl start apache2.service
sudo systemctl status apache2.service
## apache configuration multiple domain
#domain=test.com
#root="/var/www/html/$domain"
#block="/etc/httpd/conf.d/test.conf"
#
#sudo mkdir -p $root
#
#cat << EOF > $block
#<VirtualHost *:80>
#    ServerName 54.187.217.233
#    DocumentRoot $root
#
#    ErrorLog /var/log/httpd/example.com-error_log
#    CustomLog /var/log/httpd/example.com-access_log combined
#</VirtualHost>
#EOF
# apache configuration
domain=test.com
root="/var/www/html/test.com"
block="/etc/apache2/sites-available/test.conf"

sudo mkdir -p $root

cat << EOF > $block
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $root

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Create the index.html:
echo "<h1>welcome</h1>" | sudo tee $root/index.html

#enable a new site
sudo a2ensite test.conf

## Disabling Apache welocme page
sudo a2dissite 000-default.conf

# Reload apache
systemctl reload apache2

# install php
echo "Installing php"
sudo apt -y install php7.4
sudo apt install php7.4-{mysql,zip,bcmath} -y
sudo systemctl restart apache2
php --version