#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat << EOF > /var/www/html/index.html
<html>
    <body>
        <h2>Hello World</h2>
    </body>
</html>
EOF
sudo service httpd start
chkconfig httpd on