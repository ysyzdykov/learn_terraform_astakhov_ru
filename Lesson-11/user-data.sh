#!/bin/bash

sudo yum -y update
sudo yum -y install httpd

sudo cat <<EOF > /var/www/html/index.html
<html>
<h1> Made by Terraform <font color="red"> v.1.9.3</font></h1></br>
<h2> Owner <font color="green">${f_name} ${l_name}.</font></h2></br>
EOF

sudo systemctl enable httpd
sudo systemctl restart httpd
