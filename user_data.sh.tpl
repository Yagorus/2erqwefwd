#!/bin/bash



sudo apt-get -y update
sudo apt-get -y install apache2

cat << EOF > /var/www/html/index.html
<html>
    <body>
        <h2>Hello World</h2>
        <h2>Availability zones: ${az}</h2>
    </body>
</html>
EOF
sudo systemctl enable apache2.service
sudo systemctl start apache2.service
sudo ufw allow 80/tcp comment 'accept Apache'