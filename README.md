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
 
## Scripts
 
The `scripts` directory contains several shell scripts used during the AMI creation:

* `nginx-jenkins.conf`: Nginx configuration for Jenkins.
* `request-cert.sh`: Shell script to request SSL certificates.
* `request-cert.service`: Systemd service to manage SSL certificate requests.
* `setup-init.sh`: Shell script for initial system setup
* `setup-jenkins.sh`: Shell script to install and configure Jenkins
* `setup-docker.sh`: Shell script to install and configure Docker
* `setup-nginx.sh`: Shell script to install and configure Nginx
 

 Sure, here's the complete section including the `configs.tgz` requirement and the updated Jenkins integration instructions:


Sure, here's the updated section including the instructions for creating the `jenkins.env` file:

```markdown
## Jenkins Integration with GitHub using GitHub App

To enable GitHub to trigger Jenkins pipeline jobs, a webhook needs to be configured to trigger on code push to the master branch. Follow these steps to install and configure a GitHub app in your organization and set up webhooks in the repositories that will be scanned to run the build pipeline jobs.

1. **Create and Install GitHub App**:
   * Go to GitHub and create a new GitHub App at the organization level.
   * Configure the webhook URL in the format: `https://<your-jenkins-server-domain>.tld/github-webhook`.

2. **Generate and Convert Private Key**:
   * Download the PKCS1 private key from the GitHub app.
   * Convert this private key to PKCS8 format for Jenkins to communicate with the GitHub app:
     ```bash
     openssl pkcs8 -topk8 -nocrypt -in <github-app-private-key.pem> -out <jenkins-private-key>.pem
     ```

3. **Add Credentials in Jenkins**:
   * Add the converted private key to Jenkins in the credentials section with a unique ID.
   * Fill out the App ID in the credentials section with the GitHub app ID.

Set the following environment variables with the appropriate values:

   ```bash
   JENKINS_URL=https://<your-jenkins-server-domain>
   JENKINS_ADMIN_USERNAME=<your-jenkins-admin-username>
   JENKINS_ADMIN_PASSWORD=<your-jenkins-admin-password>
   
   DOCKER_USERNAME=<your-docker-username>
   DOCKER_PASSWORD=<your-docker-password>
   
   GITHUB_APP_ID=<your-github-app-id>
   GITHUB_APP_PRIVATE_KEY='<your-github-app-private-key>'
   ```

For detailed instructions, refer to the [CloudBees documentation on GitHub App authentication](https://docs.cloudbees.com/docs/cloudbees-ci/latest/traditional-admin-guide/github-app-auth). This guide provides comprehensive steps on setting up and configuring the GitHub App for Jenkins integration.

## Required Files

The Packer configuration requires a `configs.tgz` tar file in the repository folder. This tar file should contain any necessary configuration files and scripts needed during the AMI creation process.

1. **Create `configs.tgz`**:
   * Gather all the necessary configuration files and scripts into a directory.
   * Create a tar file from the directory:
     ```bash
     tar -czvf configs.tgz /path/to/configs/
     ```

2. **Place `configs.tgz` in the Repository Folder**:
   * Ensure the `configs.tgz` file is located in the root directory of your cloned repository.

3. **Create `jenkins.env` File**:
   * In the `configs` directory, create a file named `jenkins.env` with the following content:
     ```env
     JENKINS_URL=https://<your-jenkins-server-domain>.tld
     JENKINS_ADMIN_USERNAME=<your-jenkins-admin-username>
     JENKINS_ADMIN_PASSWORD=<your-jenkins-admin-password>

     DOCKER_USERNAME=<your-docker-username>
     DOCKER_PASSWORD=<your-docker-password>

     GITHUB_APP_ID=<your-github-app-id>
     GITHUB_APP_PRIVATE_KEY='-----BEGIN PRIVATE KEY-----
     <your-private-key-content>
     -----END PRIVATE KEY-----'
     ```

With the `configs.tgz` file in place, you can proceed with the Packer build process as outlined in the [Usage](#usage) section.

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
	```
 
4. **Run Packer**:
   ```bash
   packer init .
   packer build -var-file=variables.pkrvars.hcl .
   ```
 
5. **Validate the output**:
   After the build process completes, verify the created AMI in your AWS account.


## Jenkins Integration with GitHub using GitHub App

To enable GitHub to trigger Jenkins pipeline jobs, a webhook needs to be configured to trigger on code push. Follow these steps to install and configure a GitHub app in your organization and set up webhooks in the repositories that will be scanned to run the build pipeline jobs.

1. **Create and Install GitHub App**:
   * Go to GitHub and create a new GitHub App at the organization level.
   * Configure the webhook URL in the format: `https://<your-jenkins-server-domain>.tld/github-webhook/`.

2. **Generate and Convert Private Key**:
   * Download the PKCS1 private key from the GitHub app.
   * Convert this private key to PKCS8 format for Jenkins to communicate with the GitHub app:
     ```bash
	 openssl pkcs8 -topk8 -inform PEM -outform PEM -in <your-github-app-private-key>.pem -out <your-jenkins-private-key>.pem -nocrypt
     ```

3. **Add Credentials in jenkins.env file**:
   * GITHUB_APP_ID=`<your-github-app-id>`
   * GITHUB_APP_PRIVATE_KEY='`<your-jenkins-private-key>.pem`'
  

For detailed instructions, refer to the [CloudBees documentation on GitHub App authentication](https://docs.cloudbees.com/docs/cloudbees-ci/latest/traditional-admin-guide/github-app-auth). This guide provides comprehensive steps on setting up and configuring the GitHub App for Jenkins integration.

 
 
