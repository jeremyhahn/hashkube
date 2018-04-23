variable "appname" {
  default = "myapp"
}

variable "vpc_id" {
  default = "vpc-12345678"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "os_platform" {
  default = "amazon-linux"
}

variable "subnet_ids" {
  default = ["subnet-12345678"]
}

variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "devops_bucket" {
  default = "hashkube-devops"
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

variable "consul_cluster_name" {
  description = "What to name the Consul server cluster and all of its associated resources"
  default     = "consul-cluster"
}

variable "consul_cluster_tag_key" {
  description = "The tag the Consul EC2 Instances will look for to automatically discover each other and form a cluster."
  default     = "consul-servers"
}

variable "consul_encryption_key" {
  description = "The name of the file in the devops s3 bucket where the gossip encryption key is stored"
  default = "consul_encryption_key"
}

variable "vault_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  default     = "vault-cluster"
}

variable "vault_cluster_size" {
  description = "The number of Vault server nodes to deploy. We strongly recommend using 3 or 5."
  default     = 3
}

variable "vault_instance_type" {
  description = "The type of EC2 Instance to run in the Vault ASG"
  default     = "t2.micro"
}

variable "vault_key_shares" {
  description = "The number of vault key shares"
  default     = 3
}

variable "vault_key_threshold" {
  description = "The number of vault key shares"
  default     = 2
}

variable "vault_pgp_key1" {
  description = "The 1st PGP key used to initialize/seal/unseal the vault"
  default     = "key1.asc"
}

variable "vault_pgp_key2" {
  description = "The 2nd PGP key used to initialize/seal/unseal the vault"
  default     = "key2.asc"
}

variable "vault_pgp_key3" {
  description = "The 3rd PGP key used to initialize/seal/unseal the vault"
  default     = "key3.asc"
}

variable "vault_pgp_key1_secret" {
  description = "The 1st PGP secret key used to initialize/seal/unseal the vault"
  default     = "key1.secret.asc"
}

variable "vault_pgp_key2_secret" {
  description = "The 2nd PGP secret key used to initialize/seal/unseal the vault"
  default     = "key2.secret.asc"
}

variable "vault_pgp_key3_secret" {
  description = "The 3rd PGP secret key used to initialize/seal/unseal the vault"
  default     = "key3.secret.asc"
}

variable "vault_auto_unseal" {
  description = "Automatically unseal vault after install"
  default = "false"
}
