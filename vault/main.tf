data "aws_caller_identity" "current" {}

data "aws_ami" "vault_consul_ami" {
  most_recent = true
  filter {
    name = "tag:Name"
    values = ["vault-consul-${var.os_platform}-current"]
  }
}

data "template_file" "user_data_vault_cluster" {
  template = "${file("${path.module}/user-data.sh")}"
  vars {
    aws_region               = "${var.aws_region}"
    devops_bucket            = "${var.devops_bucket}"
    consul_cluster_tag_key   = "${var.consul_cluster_tag_key}"
    consul_cluster_tag_value = "${var.consul_cluster_name}"
    consul_encryption_key    = "${var.consul_encryption_key}"
    vault_key_shares         = "${var.vault_key_shares}"
    vault_key_threshold      = "${var.vault_key_threshold}"
    vault_pgp_key1           = "${var.vault_pgp_key1}"
    vault_pgp_key2           = "${var.vault_pgp_key2}"
    vault_pgp_key3           = "${var.vault_pgp_key3}"
    vault_admin1_bucket      = "${aws_s3_bucket.vault_bucket_admin1.id}"
    vault_admin2_bucket      = "${aws_s3_bucket.vault_bucket_admin2.id}"
    vault_admin3_bucket      = "${aws_s3_bucket.vault_bucket_admin3.id}"
    vault_auto_unseal        = "${var.vault_auto_unseal}"
  }
}

module "vault_cluster" {
  source = "github.com/hashicorp/terraform-aws-vault.git//modules/vault-cluster?ref=v0.6.0"

  ami_id = "${data.aws_ami.vault_consul_ami.id}"
  vpc_id = "${var.vpc_id}"
  subnet_ids = "${var.subnet_ids}"
  ssh_key_name = "${var.key_pair}"
  user_data = "${data.template_file.user_data_vault_cluster.rendered}"

  cluster_name  = "${var.vault_cluster_name}"
  cluster_size  = "${var.vault_cluster_size}"
  instance_type = "${var.vault_instance_type}"

  allowed_inbound_cidr_blocks = "${var.private_subnets}"
  allowed_inbound_security_group_ids = []

  allowed_ssh_cidr_blocks =  "${var.private_subnets}"
  allowed_ssh_security_group_ids = ["${var.default_sg}", "${var.bastionvpn_sg}"]
}

module "consul_iam_policies_servers" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-iam-policies?ref=v0.3.3"
  iam_role_id = "${module.vault_cluster.iam_role_id}"
}

module "security_group_rules" {
  source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-client-security-group-rules?ref=v0.3.3"

  security_group_id           = "${module.vault_cluster.security_group_id}"
  allowed_inbound_cidr_blocks = "${var.private_subnets}"
}
