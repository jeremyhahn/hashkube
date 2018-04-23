output "asg_name_vault_cluster" {
  value = "${module.vault_cluster.asg_name}"
}

output "launch_config_name_vault_cluster" {
  value = "${module.vault_cluster.launch_config_name}"
}

output "iam_role_arn_vault_cluster" {
  value = "${module.vault_cluster.iam_role_arn}"
}

output "iam_role_id_vault_cluster" {
  value = "${module.vault_cluster.iam_role_id}"
}

output "security_group_id_vault_cluster" {
  value = "${module.vault_cluster.security_group_id}"
}

output "vault_servers_cluster_tag_key" {
  value = "${module.vault_cluster.cluster_tag_key}"
}

output "vault_servers_cluster_tag_value" {
  value = "${module.vault_cluster.cluster_tag_value}"
}

output "vault_cluster_size" {
  value = "${var.vault_cluster_size}"
}
