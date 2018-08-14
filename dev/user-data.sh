#!/usr/bin/env bash

#Install Necessary Components
sudo yum install -y epel-release yum-utils
sudo yum update -y
sudo yum install -y  wget vim git firewalld curl

# Disable SELINUX
sudo echo 0 > /sys/fs/selinux/enforce

#Install & Configure Mysql
sudo yum install mariadb-server mariadb -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql -e "UPDATE mysql.user SET Password = PASSWORD('0987Threat') WHERE User = 'root'"
sudo echo "CREATE DATABASE appdb;" |  mysql -u root --password="0987Threat"


# Install & Configure PHP
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php56
sudo yum install -y php php-fpm php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo

sudo systemctl start php-fpm
sudo systemctl enable php-fpm


# Nginx Configuration
sudo yum install -y nginx

sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled

sudo ce /tmp
sudo git clone https://github.com/timam/mavs-iaac.git


#sudo vim /etc/nginx/nginx.conf.default
##Add these lines to the end of the http {} block:
#+ include /etc/nginx/sites-enabled/*.conf;
#+ server_names_hash_bucket_size 64;


sudo chmod -R 755 /var/www


sudo mkdir -p /var/www/master.dev.timam.io/
sudo chown -R nginx:nginx /var/www/master.dev.timam.io/
sudo cd /var/www/master.dev.timam.io/
sudo git clone -b master https://github.com/timam/mavapp.git
sudo cp /tmp/mavs-iaac/nginx-conf/master.dev.timam.io.conf /etc/nginx/sites-available/master.dev.timam.io.conf
sudo ln -s /etc/nginx/sites-available/master.dev.timam.io.conf /etc/nginx/sites-enabled/master.dev.timam.io.conf



sudo mkdir -p /var/www/branch.dev.timam.io/
sudo chown -R  nginx:nginx /var/www/branch.dev.timam.io/
sudo cd /var/www/branch.dev.timam.io/
sudo git clone -b branch-one https://github.com/timam/mavapp.git
sudo cp /tmp/mavs-iaac/nginx-conf/branch.dev.timam.io.conf  /etc/nginx/sites-available/branch.dev.timam.io.conf
sudo ln -s /etc/nginx/sites-available/branch.dev.timam.io.conf /etc/nginx/sites-enabled/branch.dev.timam.io.conf


sudo systemctl restart nginx