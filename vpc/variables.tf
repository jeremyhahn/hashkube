variable "appname" {
  default = "myvpc"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_credentials_file" {
  default = "~/.aws/credentials"
}

variable "os_platform" {
  default = "amazon-linux"
}

variable "dhcp_options_domain_name" {
  default = "service.consul"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1c", "us-east-1e"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "default_ssh_key_name" {
  default = "default"
}
