#!/bin/bash
yum -y update
yum -y install httpd
echo "Lalafa" > /var/www/html/index.html
sudo systemctl start httpd
