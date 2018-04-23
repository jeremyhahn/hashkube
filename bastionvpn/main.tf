resource "aws_security_group" "bastionvpn_sg" {
  name        = "bastionvpn"
  description = "Allow ingress traffic to Bastion VPN host"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "bastionvpn" {
  name = "bastionvpn"
  health_check_type = "EC2"
  launch_configuration = "${aws_launch_configuration.bastionvpn.name}"
  max_size = 1
  min_size = 1
  vpc_zone_identifier = ["${var.subnet_ids}"]
  tags = [{
    key = "Name"
    value = "bastionvpn"
    propagate_at_launch = true
  }]
}

resource "aws_launch_configuration" "bastionvpn" {
  name = "bastionvpn"
  image_id = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.bastionvpn_profile.name}"
  key_name = "${var.key_pair}"
  security_groups = ["${aws_security_group.bastionvpn_sg.id }"]
  user_data = <<EOF
  #cloud-config
  runcmd:
    - aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${aws_eip.bastionvpn_eip.id} --allow-reassociation --region ${var.aws_region}
  EOF
}

resource "aws_eip" "bastionvpn_eip" {
  vpc      = true
}

resource "aws_iam_instance_profile" "bastionvpn_profile" {
  name  = "bastionvpn"
  role = "${aws_iam_role.bastionvpn_role.name}"
}

resource "aws_iam_role" "bastionvpn_role" {
  name = "bastionvpn"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "bastionvpn_policy" {
  name   = "attach_eip"
  path   = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAddresses",
                "ec2:AllocateAddress",
                "ec2:DescribeInstances",
                "ec2:AssociateAddress"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bastionvpn_policy_attachment" {
    role       = "${aws_iam_role.bastionvpn_role.name}"
    policy_arn = "${aws_iam_policy.bastionvpn_policy.arn}"
}
