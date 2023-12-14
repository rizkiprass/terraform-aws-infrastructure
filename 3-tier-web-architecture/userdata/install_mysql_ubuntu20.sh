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
mysql -e "CREATE DATABASE tp_db;"

mysql -u root tp_db <<MYSQL_SCRIPT
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(100),
    Address VARCHAR(255)
);
MYSQL_SCRIPT

mysql -u root tp_db <<MYSQL_SCRIPT
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) UNIQUE
);
MYSQL_SCRIPT

mysql -u root tp_db <<MYSQL_SCRIPT
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    CategoryID INT,
    Image VARCHAR(255),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
MYSQL_SCRIPT

mysql -u root tp_db <<MYSQL_SCRIPT
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
MYSQL_SCRIPT

mysql -u root tp_db <<MYSQL_SCRIPT
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Subtotal DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
MYSQL_SCRIPT

mysql -u root tp_db <<MYSQL_SCRIPT
CREATE TABLE Cart (
    CartID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
MYSQL_SCRIPT

sudo systemctl restart mysql