variable "aws_region" {
  description = "The AWS region targeted for deployment"
  default = "us-east-1"
}

variable "aws_credentials_file" {
  description = "The location of your AWS credentials file"
  default = "~/.aws/credentials"
}

variable "os_platform" {
  description = "The default operating system platform used by instances in the VPC"
  default = "amazon-linux"
}

variable "dhcp_options_domain_name" {
  description = "The DHCP option set assigned to the VPC"
  default = "service.consul"
}

variable "vpc_cidr" {
  description = "The VPC network CIDR"
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones assigned to VPC subnets"
  default = ["us-east-1a", "us-east-1c", "us-east-1e"]
}

variable "private_subnets" {
  description = "The VPC private networks"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "The VPC public networks"
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "default_ssh_key_name" {
  description = "The default SSH key pair assigned to EC2 instances"
  default = "hashkube"
}

variable "devops_bucket_name" {
  description = "The bucket where devops artifacts are stored"
  default = "hashkube-devops"
}

variable "build_user" {
  description = "The current logged in user executing the build"
}

variable "consul_cluster_size" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "vault_cluster_size" {
  description = "The number of Vault server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "consul_instance_type" {
  description = "The type of EC2 Instance to run in the Consul ASG"
  default     = "t2.micro"
}

variable "vault_instance_type" {
  description = "The type of EC2 Instance to run in the Vault ASG"
  default     = "t2.micro"
}

variable "vault_key_shares" {
  description = "The number of vault key shares"
  default     = 3
}

variable "vault_auto_unseal" {
  description = "Automatically unseal vault after install (Note: Insecure, proceed with caution!)"
  default = "false"
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
