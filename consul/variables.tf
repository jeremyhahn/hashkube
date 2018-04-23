variable "vpc_id" {
  default = "vpc-12345678"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "os_platform" {
  default = "amazon-linux"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1c", "us-east-1e"]
}

variable "subnet_ids" {
  default = ["subnet-12345678"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "key_pair" {
  default = "default"
}

variable "default_sg" {
  default = "sg-12345678"
}

variable "bastionvpn_sg" {
  default = "sg-12345678"
}

variable "devops_bucket" {
  default = "hashkube-devops"
}

variable "consul_cluster_name" {
  description = "What to name the Consul server cluster and all of its associated resources"
  default     = "consul-cluster"
}

variable "consul_cluster_size" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "consul_instance_type" {
  description = "The type of EC2 Instance to run in the Consul ASG"
  default     = "t2.micro"
}

variable "consul_cluster_tag_key" {
  description = "The tag the Consul EC2 Instances will look for to automatically discover each other and form a cluster."
  default     = "consul-servers"
}

variable "consul_encryption_key" {
  description = "The name of the file in the devops s3 bucket where the gossip encryption key is stored"
  default = "consul_encryption_key"
}

variable "enable_gossip_encryption" {
  description = "Encrypt gossip traffic between nodes. Must also specify encryption key."
  default = "true"
}

variable "enable_rpc_encryption" {
  description = "Encrypt RPC traffic between nodes. Must also specify TLS certificates and keys."
  default = "true"
}

variable "ca_path" {
  description = "Path to the directory of CA files used to verify outgoing connections."
  default = "/opt/consul/tls/ca"
}

variable "cert_file_path" {
  description = "Path to the certificate file used to verify incoming connections."
  default = "/opt/consul/tls/consul.crt.pem"
}

variable "key_file_path" {
  description = "Path to the certificate key used to verify incoming connections."
  default = "/opt/consul/tls/consul.key.pem"
}
