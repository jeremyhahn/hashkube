output "devops_bucket" {
  value = "${aws_s3_bucket.devops_bucket.id}"
}

output "devops_role_arn" {
  value = "${aws_iam_role.devops_role.arn}"
}

output "devops_role_name" {
  value = "${aws_iam_role.devops_role.name}"
}
