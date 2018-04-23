data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

module "libvpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.appname}"
  cidr = "${var.vpc_cidr}"

  azs             = "${var.availability_zones}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway = true
  enable_s3_endpoint = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "${var.dhcp_options_domain_name}"
  #dhcp_options_domain_name_servers = ["127.0.0.1"]

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "default_sg" {
  name        = "${var.appname}-default"
  description = "Default security rules applied to all hosts in the VPC"
  vpc_id      = "${module.libvpc.vpc_id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
