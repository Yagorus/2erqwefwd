#!/bin/bash
sudo apt-get update
sudo apt-get install apache2

cat << EOF > /var/www/html/index.html
<html>
    <body>
        <h2>Hello World</h2>
    </body>
</html>
EOF

sudo systemctl start apache2
