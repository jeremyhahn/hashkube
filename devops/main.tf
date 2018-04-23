data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "devops_bucket" {
  bucket = "${var.appname}-devops"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
            "AWS": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.devops_role.name}",
                "${data.aws_caller_identity.current.arn}"
            ]
        },
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${var.appname}-devops"
    },
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.devops_role.name}",
                "${data.aws_caller_identity.current.arn}"
            ]
        },
        "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::${var.appname}-devops/*"
    }, {
        "Effect": "Allow",
        "Principal": {
            "AWS": ["*"]
        },
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${var.appname}-devops",
        "Condition": {
            "StringEquals": {
                "aws:sourceVpc": "${var.vpc_id}"
            }
        }
    },
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": ["*"]
        },
        "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::${var.appname}-devops/*",
        "Condition": {
            "StringEquals": {
                "aws:sourceVpc": "${var.vpc_id}"
            }
        }
    }]
}
EOF
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_iam_role" "devops_role" {
  name = "${var.appname}-devops-bucket-access"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
            "AWS": [
                "arn:aws:sts::${data.aws_caller_identity.current.account_id}:root"
              ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "devops_bucket_policy" {
  name   = "rw_devops_bucket"
  path   = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ],
      "Resource": "*"
    }, {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.devops_bucket.id}"
    }, {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${aws_s3_bucket.devops_bucket.id}/*"
    }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "devops_bucket_attachment" {
    role       = "${aws_iam_role.devops_role.name}"
    policy_arn = "${aws_iam_policy.devops_bucket_policy.arn}"
}
