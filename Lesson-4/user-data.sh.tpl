#!/bin/bash
sudo yum -y update
sudo yum -y install httpd

sudo cat <<EOF > /var/www/html/index.html

<html>
<h1> Made by Terraform <font color="red"> v.1.5.6</font></h1></br>
Owner ${f_name} ${l_name}.</br>

%{ for x in names ~}
Hello ${x}!</br>
%{ endfor ~}

</html>
EOF

sudo service httpd start
