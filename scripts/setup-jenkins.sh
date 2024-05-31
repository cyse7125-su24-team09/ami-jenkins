#!/bin/bash

# Download and install jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install -y openjdk-17-jre
sudo apt-get install -y jenkins

# Setup for jenkins security and plugins
sudo mkdir -p /var/lib/jenkins/init.groovy.d
sudo mv /tmp/jenkins-plugins.groovy /var/lib/jenkins/init.groovy.d/jenkins-plugins.groovy
sudo mv /tmp/jenkins-security.groovy /var/lib/jenkins/init.groovy.d/jenkins-security.groovy
sudo sed -i "s/JENKINS_ADMIN_USERNAME/$JENKINS_ADMIN_USERNAME/g" /var/lib/jenkins/init.groovy.d/jenkins-security.groovy
sudo sed -i "s/JENKINS_ADMIN_PASSWORD/$JENKINS_ADMIN_PASSWORD/g" /var/lib/jenkins/init.groovy.d/jenkins-security.groovy
sudo chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
sudo sed -i '/^JAVA_ARGS=/ s/"$/ -Djenkins.install.runSetupWizard=false"/' /etc/default/jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins

JENKINS_SETUP=$?
if [ $JENKINS_SETUP -eq 0 ]; then
  echo "Jenkins installed successfully"
else
  echo "Jenkins installation failed"
fi