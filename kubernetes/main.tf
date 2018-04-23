provider "aws" {
  version = "~> 1.7.0"
  region  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_credentials_file}"
}

module "kubernetes" {
  source  = "coreos/kubernetes/aws"
  version = "1.8.9-tectonic.1"

  tectonic_admin_email    = "${var.cluster_admin_email}"
  tectonic_admin_password = "${var.cluster_admin_password}"
  tectonic_aws_ssh_key    = "${var.default_ssh_key_name}"
  tectonic_base_domain    = "${var.base_domain}"
  tectonic_cluster_name   = "${var.cluster_name}"
  tectonic_license_path   = "tectonic_vanilla_k8s"
  tectonic_vanilla_k8s    = true
  tectonic_aws_external_private_zone = "Z1TTNFF0JMDARG"
}
