output "appname" {
  value = "${var.cluster_name}"
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnet_ids}"]
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnet_ids}"]
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}

output "aws_region" {
  value = "${module.vpc.aws_region}"
}

output "ssh_key_name" {
  value = "${module.vpc.ssh_key_name}"
}

output "devops_bucket" {
  value = "${module.devops.devops_bucket}"
}

output "devops_role_arn" {
  value = "${module.devops.devops_role_arn}"
}

output "devops_role_name" {
  value = "${module.devops.devops_role_name}"
}

output "amazon_linux_ami" {
  value = "${module.vpc.amazon_linux_ami}"
}

output "base_ami" {
  value = "${module.vpc.amazon_linux_ami}"
}

output "default_sg" {
  value = "${module.vpc.default_sg}"
}

output "bastionvpn_sg" {
  value = "${module.bastionvpn.bastionvpn_sg}"
}

output "consul_cluster_size" {
  value = "${var.consul_cluster_size}"
}

output "vault_cluster_size" {
  value = "${var.vault_cluster_size}"
}
