#!/bin/bash
#ONLY WORK FOR MYSQL 8
sudo apt update
sudo apt upgrade -y
sudo apt install mysql-server -y

# Run the MySQL secure installation script
mysql_secure_installation <<EOF

y
n
y
y
y
EOF

# Configure MySQL for Ubuntu 20.04
echo "Configuring MySQL for Ubuntu 20.04..."
systemctl enable mysql
systemctl start mysql

# Secure root user and remove anonymous users
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'auth_socket';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "FLUSH PRIVILEGES"

# create app user
mysql -e "CREATE USER 'app'@'%' IDENTIFIED BY 'Admin123';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'app'@'%';"

sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

#Create DB, Table
mysql -e "CREATE DATABASE ecommerce_db;"

# Create a sample table in the new database
TABLE_NAME="users"

mysql -u root ecommerce_db <<MYSQL_SCRIPT
CREATE TABLE $TABLE_NAME (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL
);
MYSQL_SCRIPT

mysql -u root ecommerce_db <<MYSQL_SCRIPT
CREATE TABLE products (
    id INT AUTO_INCREMENT, -- You may need to adjust data types and constraints based on your database
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL, -- Assuming prices with 2 decimal places
    image VARCHAR(255), -- You may want to store image paths or use BLOB data type for actual image data
    PRIMARY KEY (id)
);
MYSQL_SCRIPT

sudo systemctl restart mysql