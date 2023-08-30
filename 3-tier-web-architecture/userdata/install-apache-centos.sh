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
root="/var/www/html/test.com"
block="/etc/httpd/conf.d/test.conf"

sudo mkdir -p $root

cat << EOF > $block
<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $root
    ErrorLog /var/log/httpd/example.com-error_log
    CustomLog /var/log/httpd/example.com-access_log combined
</VirtualHost>
EOF

# Create the index.html:
echo "<h1>welcome</h1>" | sudo tee $root/index.html

# Disabling Apache welocme page
mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf_backup
systemctl reload httpd