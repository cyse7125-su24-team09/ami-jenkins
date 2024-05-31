packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "environment" {
  type        = string
  description = "Environment for jenkins server"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "source_ami" {
  type        = string
  description = "ID of the Source AMI to use for building the AMI"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to use while building the AMI"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet for instance"
}

variable "security_group_id" {
  type        = string
  description = "ID of the security group to attach to the instance"
}

variable "ssh_username" {
  type        = string
  description = "Username for packer to ssh into the instance"
}

variable "jenkins_domain" {
  type        = string
  description = "Jenkins server domain"
}

variable "jenkins_nginx_cert_email" {
  type        = string
  description = "Maintainer's email address for jenkins nginx certificates"
}

variable "jenkins_admin_username" {
  type        = string
  description = "Username for the jenkins server admin"
}

variable "jenkins_admin_password" {
  type        = string
  description = "Password for the jenkins server admin"
}

source "amazon-ebs" "jenkins" {
  profile           = var.aws_profile
  region            = var.aws_region
  source_ami        = var.source_ami
  ami_name          = "jenkins-ami-{{timestamp}}"
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  ssh_username      = var.ssh_username
  security_group_id = var.security_group_id

  tags = {
    "Environment"   = var.environment
    "Base_AMI_ID"   = "{{ .SourceAMI }}"
    "Base_AMI_Name" = "{{ .SourceAMIName }}"
  }
}

build {
  name    = "jenkins-builder"
  sources = ["source.amazon-ebs.jenkins"]

  provisioner "file" {
    source      = "../scripts/nginx-jenkins.conf"
    destination = "/tmp/nginx-jenkins.conf"
  }

  provisioner "file" {
    source      = "../scripts/jenkins-security.groovy"
    destination = "/tmp/jenkins-security.groovy"
  }

  provisioner "file" {
    source      = "../scripts/jenkins-plugins.groovy"
    destination = "/tmp/jenkins-plugins.groovy"
  }

  provisioner "file" {
    source      = "../scripts/request-cert.sh"
    destination = "/tmp/request-cert.sh"
  }

  provisioner "file" {
    source      = "../scripts/request-cert.service"
    destination = "/tmp/request-cert.service"
  }

  provisioner "shell" {
    environment_vars = [
      "JENKINS_DOMAIN=${var.jenkins_domain}",
      "JENKINS_NGINX_CERT_EMAIL=${var.jenkins_nginx_cert_email}",
      "JENKINS_ADMIN_USERNAME=${var.jenkins_admin_username}",
      "JENKINS_ADMIN_PASSWORD=${var.jenkins_admin_password}"
    ]
    scripts = [
      "../scripts/setup-init.sh",
      "../scripts/setup-jenkins.sh",
      "../scripts/setup-nginx.sh"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
