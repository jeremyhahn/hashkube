provider "aws" {
  version = "~> 1.14.1"
  region  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_credentials_file}"
}

module "vpc" {
  source = "./vpc"

  appname = "${var.cluster_name}"
  default_ssh_key_name = "${var.default_ssh_key_name}"
}

module "devops" {
  source = "./devops"

  appname = "${var.cluster_name}"
  vpc_id = "${module.vpc.vpc_id}"
  devops_bucket_name = "${var.devops_bucket_name}"
}

module "bastionvpn" {
  source = "./bastionvpn"

  vpc_id = "${module.vpc.vpc_id}"
  ami_id = "${module.vpc.default_ami}"
  subnet_ids = ["${module.vpc.public_subnet_ids}"]
  key_pair = "${var.default_ssh_key_name}"
}

module "consul" {
  source = "./consul"

  devops_bucket = "${var.devops_bucket_name}"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_ids = ["${module.vpc.private_subnet_ids}"]
  key_pair = "${var.default_ssh_key_name}"
  default_sg = "${module.vpc.default_sg}"
  bastionvpn_sg = "${module.bastionvpn.bastionvpn_sg}"

  consul_cluster_name = "${var.cluster_name}-consul"
  consul_instance_type = "${var.consul_instance_type}"
}

module "vault" {
  source = "./vault"

  appname = "${var.cluster_name}"
  devops_bucket = "${var.devops_bucket_name}"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_ids = ["${module.vpc.private_subnet_ids}"]
  key_pair = "${var.default_ssh_key_name}"
  default_sg = "${module.vpc.default_sg}"
  bastionvpn_sg = "${module.bastionvpn.bastionvpn_sg}"

  consul_cluster_name = "${var.cluster_name}-consul"

  vault_cluster_name  = "${var.cluster_name}-vault"
  vault_key_shares    = "${var.vault_key_shares}"
  vault_instance_type = "${var.vault_instance_type}"
  vault_key_shares    = "${var.vault_key_shares}"
  vault_auto_unseal   = "${var.vault_auto_unseal}"
}
