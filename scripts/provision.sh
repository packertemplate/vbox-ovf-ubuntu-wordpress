#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
unset PACKAGES
PACKAGES="nginx mysql-server php5-fpm php5-mysql php5-curl php5-mcrypt php5-gd"
sudo -E apt-get clean
sudo -E apt-get update
sudo -E apt-get install -y -q --no-install-recommends ${PACKAGES}

sudo mkdir -p /usr/share/nginx/wordpress /etc/nginx/sites-available
[ -h /etc/nginx/sites-enabled/default ] && sudo unlink /etc/nginx/sites-enabled/default

#create wp-ms file
sudo tee /etc/nginx/sites-available/wp-ms <<EOF
server {
    listen [::]:80 ipv6only=off;
    server_name localhost;
    root /usr/share/nginx/wordpress;
    index index.php index.html index.htm;
    location / {
        try_files \$uri \$uri/ /index.php?$args ;
    }
    location ~ /favicon.ico {
        access_log off;
        log_not_found off;
    }
    location ~ \.php$ {
        try_files \$uri /index.php;
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
    }
    access_log  /var/log/nginx/$host-access.log;
    error_log   /var/log/nginx/wpms-error.log;
}
EOF

[ -h /etc/nginx/sites-enabled/wp-ms ] || sudo ln -s /etc/nginx/sites-available/wp-ms /etc/nginx/sites-enabled/wp-ms

sudo service nginx configtest
sudo service nginx restart
  
[ -f /usr/local/mysql.done ] || {
sudo mysql -u root << EOF
CREATE DATABASE wordpress;
CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'localhost';
FLUSH PRIVILEGES;
exit
EOF
sudo touch /usr/local/mysql.done 
}

[ -f /usr/local/wp.done ] || {
sudo mkdir -p /usr/share/nginx/wordpress
sudo mkdir -p /usr/local/wp
pushd /usr/local/wp
sudo wget -N http://wordpress.org/latest.tar.gz
pushd /usr/share/nginx
sudo tar -xf /usr/local/wp/latest.tar.gz
sudo chown -R www-data:www-data /usr/share/nginx/wordpress
sudo touch /usr/local/wp.done 
}

sed -i '/tty/!s/mesg n/tty -s \&\& mesg n/' /home/vagrant/.profile
sudo sed -i '/tty/!s/mesg n/tty -s \&\& mesg n/' /root/.profile

sudo sudo -E -H apt-get clean
[ -f /etc/udev/rules.d/70-persistent-net.rule ] && sudo rm -f /etc/udev/rules.d/70-persistent-net.rule || true
