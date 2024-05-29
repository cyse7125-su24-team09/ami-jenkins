#!/bin/bash

CERT_PATH="/etc/letsencrypt/live/$JENKINS_DOMAIN/fullchain.pem"

request_certificate() {
    sudo certbot --nginx --staging --non-interactive --agree-tos --email $JENKINS_NGINX_CERT_EMAIL -d $JENKINS_DOMAIN
    sudo systemctl restart nginx
}

if [ -f $CERT_PATH ]; then
    echo "Certificate is already configured."
else
    echo "No existing certificate found. Requesting a new certificate."
    request_certificate
fi
