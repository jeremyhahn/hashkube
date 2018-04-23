data "aws_ami" "consul_ami" {
  most_recent = true
  filter {
    name = "tag:Name"
    values = ["consul-${var.os_platform}-current"]
  }
}

data "template_file" "user_data_consul" {
  template = "${file("${path.module}/user-data.sh")}"
  vars {
    consul_cluster_tag_key   = "${var.consul_cluster_tag_key}"
    consul_cluster_tag_value = "${var.consul_cluster_name}"
    consul_encryption_key = "${var.consul_encryption_key}"
    devops_bucket = "${var.devops_bucket}"
  }
}

module "consul_cluster" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-cluster?ref=v0.3.3"

  vpc_id = "${var.vpc_id}"
  ami_id = "${data.aws_ami.consul_ami.id}"
  availability_zones = "${var.availability_zones}"
  subnet_ids = "${var.subnet_ids}"
  instance_type = "${var.instance_type}"
  ssh_key_name = "${var.key_pair}"
  user_data = "${data.template_file.user_data_consul.rendered}"

  cluster_name  = "${var.consul_cluster_name}"
  cluster_size  = "${var.consul_cluster_size}"
  cluster_tag_key   = "${var.consul_cluster_tag_key}"
  cluster_tag_value = "${var.consul_cluster_name}"

  allowed_inbound_cidr_blocks = "${var.private_subnets}"
  allowed_ssh_security_group_ids = ["${var.default_sg}", "${var.bastionvpn_sg}"]
}
