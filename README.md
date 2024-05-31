# Jenkins AMI Creation with Packer
 
This repository contains the Packer template and necessary scripts to create a Jenkins Amazon Machine Image (AMI) on AWS. The Packer configuration is designed to automate the setup of a Jenkins server with necessary configurations and plugins.
 
 
## Requirements
 
* [Packer](https://www.packer.io/downloads) (v1.7.0 or higher)
* AWS CLI configured with appropriate credentials
* Domain
* Source AMI : Ubuntu 24.04 LTS
 
## Packer Template
 
The Packer template `jenkins.pkr.hcl` includes variables and configurations to create a Jenkins AMI. Here are the main components:
 
### Variables
 
* `environment`: Environment for Jenkins server.
* `aws_profile`: AWS profile name.
* `aws_region`: AWS region.
* `source_ami`: ID of the Source AMI to use for building the new AMI.
* `instance_type`: EC2 instance type for building the AMI.
* `subnet_id`: ID of the subnet for the instance.
* `security_group_id`: ID of the security group to attach to the instance.
* `ssh_username`: Username for Packer to SSH into the instance.
* `jenkins_domain`: Jenkins server domain.
* `jenkins_nginx_cert_email`: Maintainer's email address for Jenkins Nginx certificates.
* `jenkins_admin_username`: Username for the Jenkins server admin.
* `jenkins_admin_password`: Password for the Jenkins server admin.
 
### Source
 
The `amazon-ebs` source block defines the base configuration for the AMI build.
 
### Build
 
The build block includes file provisioners to copy configuration scripts and shell provisioners to run setup scripts on the instance.
 
## Scripts
 
The `scripts` directory contains several Groovy and Shell scripts used during the AMI creation:
 
* `jenkins-plugins.groovy`: Groovy script to install required Jenkins plugins.
* `jenkins-security.groovy`: Groovy script to configure admin user for Jenkins.
* `nginx-jenkins.conf`: Nginx configuration for Jenkins.
* `request-cert.sh`: Shell script to request SSL certificates.
* `request-cert.service`: Systemd service to manage SSL certificate requests.
* `setup-init.sh`: Shell script for initial setup.
* `setup-jenkins.sh`: Shell script to set up Jenkins.
* `setup-nginx.sh`: Shell script to set up Nginx.
 
## Usage
 
1. **Clone the repository**:
   ```bash
   git clone https://github.com/cyse7125-su24-team09/ami-jenkins.git
   cd ami-jenkins
   ```
 
2. **Customize variables**:
   Edit `jenkins.pkr.hcl` and adjust the variables as needed, or use a `variables.pkr.hcl` file to override defaults.
3. **Create `variables.pkrvars.hcl`**:
	```hcl
	environment              = "infra"
	aws_profile              = "infra"
	aws_region               = "region-name"
	source_ami               = "source-ami"
	instance_type            = "machine-type"
	subnet_id                = "default-subnet"
	security_group_id        = "default-sg"
	ssh_username             = "ubuntu"
	jenkins_domain           = "your-domain-name"
	jenkins_nginx_cert_email = "your-email"
	jenkins_admin_username   = "desired-username"
	jenkins_admin_password   = "desired-password""
	```
 
4. **Run Packer**:
   ```bash
   packer init .
   packer build -var-file=variables.pkrvars.hcl .
   ```
 
5. **Validate the output**:
   After the build process completes, verify the created AMI in your AWS account.
 
 