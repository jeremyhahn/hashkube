module "private_tls_cert" {
  source = "github.com/hashicorp/terraform-aws-vault.git//modules/private-tls-cert?ref=v0.6.0"

  ca_public_key_file_path = "${var.ca_public_key_file_path}"
  public_key_file_path    = "${var.public_key_file_path}"
  private_key_file_path   = "${var.private_key_file_path}"
  owner                   = "${var.owner}"
  organization_name       = "${var.organization_name}"
  ca_common_name          = "${var.ca_common_name}"
  common_name             = "${var.common_name}"
  dns_names               = "${var.dns_names}"
  ip_addresses            = "${var.ip_addresses}"
  validity_period_hours   = "${var.validity_period_hours}"
}
