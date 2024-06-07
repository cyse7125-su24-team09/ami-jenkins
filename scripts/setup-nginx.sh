#!/bin/bash

# Install nginx and certbot
sudo apt-get install -y nginx
sudo apt-get install -y certbot
sudo apt-get install -y python3-certbot-nginx

sudo ufw allow 'Nginx Full'

# Configure nginx for jenkins
sudo mv /tmp/nginx-jenkins.conf /etc/nginx/conf.d/jenkins.conf
sudo sed -i "s/\$JENKINS_DOMAIN/$JENKINS_DOMAIN/g" /etc/nginx/conf.d/jenkins.conf
sudo nginx -t

sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx

# Configure a startup service to request certificate for nginx
sudo mv /tmp/request-cert.sh /usr/local/bin/request-cert.sh
sudo chmod +x /usr/local/bin/request-cert.sh
sudo mv /tmp/request-cert.service /etc/systemd/system/request-cert.service

# Set environment variables for nginx
sudo sh -c "echo 'JENKINS_DOMAIN=${JENKINS_DOMAIN}' >> /etc/environment"
sudo sh -c "echo 'JENKINS_NGINX_CERT_EMAIL=${JENKINS_NGINX_CERT_EMAIL}' >> /etc/environment"

sudo systemctl daemon-reload
sudo systemctl enable request-cert.service
