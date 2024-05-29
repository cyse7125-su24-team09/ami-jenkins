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