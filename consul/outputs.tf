output "asg_name_consul_cluster" {
  value = "${module.consul_cluster.asg_name}"
}

output "launch_config_name_consul_cluster" {
  value = "${module.consul_cluster.launch_config_name}"
}

output "iam_role_arn_consul_cluster" {
  value = "${module.consul_cluster.iam_role_arn}"
}

output "iam_role_id_consul_cluster" {
  value = "${module.consul_cluster.iam_role_id}"
}

output "security_group_id_consul_cluster" {
  value = "${module.consul_cluster.security_group_id}"
}

output "launch_config_name_servers" {
  value = "${module.consul_cluster.launch_config_name}"
}

output "iam_role_arn_servers" {
  value = "${module.consul_cluster.iam_role_arn}"
}

output "iam_role_id_servers" {
  value = "${module.consul_cluster.iam_role_id}"
}

output "security_group_id_servers" {
  value = "${module.consul_cluster.security_group_id}"
}

output "consul_cluster_cluster_tag_key" {
  value = "${module.consul_cluster.cluster_tag_key}"
}

output "consul_cluster_cluster_tag_value" {
  value = "${module.consul_cluster.cluster_tag_value}"
}
