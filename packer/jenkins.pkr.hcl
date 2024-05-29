packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
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
    source      = "../scripts/jenkins.conf"
    destination = "/tmp/jenkins.conf"
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
