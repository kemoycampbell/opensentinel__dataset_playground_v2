#!/bin/bash

# Update the system packages
yum update -y

# Install Apache web server, PHP, and MySQL connector for PHP
yum install -y httpd php php-mysqlnd

# Start and enable Apache web server
systemctl start httpd
systemctl enable httpd

# Change to the web root directory
cd /var/www/html

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .

# Clean up downloaded and extracted files
rm -rf wordpress latest.tar.gz

# Set proper ownership and permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Create WordPress config file
cp wp-config-sample.php wp-config.php

# TODO: Add database configuration using the 4 variables passed in from the main.tf file
sed -i 's/database_name_here/${db_name}/g' wp-config.php
sed -i 's/username_here/${username}/g' wp-config.php
sed -i 's/password_here/${password}/g' wp-config.php 
sed -i 's/localhost/${host}/g' wp-config.php


#install wordpress cli so we can complete the full installation process without having to do anything manually
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

#configure the permission
chmod +x wp-cli.phar

#move it to global executable path
sudo mv wp-cli.phar /usr/local/bin/wp


#AUTOMATICALLY FETCH THE INSTANCE IP
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
URL=`curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4`


wp core install --url="http://$URL" --title="${title}" --admin_user="${wp_username}" --admin_password="${wp_password}" --admin_email="${email}" --allow-root >> /var/log/wp-cli.log 2>&1
