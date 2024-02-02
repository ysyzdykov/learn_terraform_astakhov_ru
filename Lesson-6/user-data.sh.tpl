#!/bin/bash

sudo su

yum -y update
yum -y install httpd

cat <<EOF > /var/www/html/index.html
<html>
<h1> Made by Terraform <font color="red"> v.1.5.6</font></h1></br>

<h2>Owner <font color="green">${f_name} ${l_name}.</font></h2></br>

%{ for x in names ~}
Hello ${x}!</br>
%{ endfor ~}
</html>

EOF

systemctl enable httpd
systemctl restart httpd
