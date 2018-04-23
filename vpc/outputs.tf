output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.libvpc.vpc_id}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${var.private_subnets}"]
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = ["${module.libvpc.private_subnets}"]
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = ["${module.libvpc.public_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${var.public_subnets}"]
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.libvpc.nat_public_ips}"]
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "ssh_key_name" {
  value = "${var.default_ssh_key_name}"
}

output "amazon_linux_ami" {
  value = "${data.aws_ami.amazon_linux_ami.id}"
}

output "default_ami" {
  value = "${data.aws_ami.amazon_linux_ami.id}"
}

output "default_sg" {
  value = "${aws_security_group.default_sg.id}"
}
