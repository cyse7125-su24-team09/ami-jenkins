#!/bin/bash

# Download and install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update && sudo apt-get install -y jenkins

# Extract the configuration files
sudo mkdir -p /tmp/configs && sudo tar -xzvf /tmp/configs.tgz -C /tmp/configs

# Configure environment variables file
sudo mv /tmp/configs/jenkins.env /var/lib/jenkins/jenkins.env
sudo chmod 600 /var/lib/jenkins/jenkins.env

# Configure init scripts
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo mv /tmp/configs/init/*.groovy /var/lib/jenkins/init.groovy.d/

# Configure job scripts
sudo mkdir -p /var/lib/jenkins/seedjobs
sudo mv /tmp/configs/jobs/*.groovy /var/lib/jenkins/seedjobs/

# Configure JCasC template
sudo mv /tmp/configs/jcasc.yaml /var/lib/jenkins/jcasc.yaml

# Modify permissions
sudo chown -R jenkins:jenkins /var/lib/jenkins

# Configure EnvironmentFile and JAVA_OPTS to disable setup wizard and load JCasC template
sudo mkdir -p /etc/systemd/system/jenkins.service.d/
{
  echo "[Service]"
  echo "EnvironmentFile=/var/lib/jenkins/jenkins.env"
  echo "Environment=\"JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Dcasc.jenkins.config=/var/lib/jenkins/jcasc.yaml\""
} | sudo tee /etc/systemd/system/jenkins.service.d/override.conf

sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins