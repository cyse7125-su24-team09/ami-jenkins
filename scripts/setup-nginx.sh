#!/bin/bash

# Install nginx and certbot
sudo apt-get install -y nginx
sudo apt-get install -y certbot
sudo apt-get install -y python3-certbot-nginx

sudo ufw allow 'Nginx Full'

# Configure nginx for jenkins
sudo mv /tmp/jenkins.conf /etc/nginx/conf.d/jenkins.conf
sudo sed -i "s/\$JENKINS_DOMAIN/$JENKINS_DOMAIN/g" /etc/nginx/conf.d/jenkins.conf
sudo nginx -t

sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx

NGINX_SETUP=$?
if [ $NGINX_SETUP -eq 0 ]; then
  echo "Nginx setup successfully"
else
  echo "Nginx setup failed"
fi

# Configure a startup script to request certificate for nginx
sudo mv /tmp/request-cert.sh /usr/local/bin/request-cert.sh
sudo chmod +x /usr/local/bin/request-cert.sh
sudo sh -c 'echo @reboot root /usr/local/bin/request-cert.sh > /etc/cron.d/request-cert'