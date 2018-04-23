variable "aws_region" {
  description = "The AWS region targeted for deployment"
  default = "us-east-1"
}

variable "aws_credentials_file" {
  description = "The location of your AWS credentials file"
  default = "~/.aws/credentials"
}

variable "default_ssh_key_name" {
  description = "The default SSH key pair assigned to EC2 instances"
  default = "hashkube"
}

variable "base_domain" {
  description = "The base domain for the cluster / platform"
  default = "k8s.service.consul"
}

variable "cluster_name" {
  description = "The name of your HashiCorp / Kubernetes cluster"
  default = "hashkube"
}

variable "cluster_admin_email" {
  description = "An administrative email address for the cluster"
  default = "root@localhost"
}

variable "cluster_admin_password" {
  description = "The kubernetes cluster administrative password"
  default = "k8$$ecret"
}

variable "tectonic_version" {
  description = "The terraform kubernetes module version to install from"
  default = "1.8.9-tectonic.1"
}
