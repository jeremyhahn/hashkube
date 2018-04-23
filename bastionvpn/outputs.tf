output "bastionvpn_sg" {
  value = "${aws_security_group.bastionvpn_sg.id}"
}
