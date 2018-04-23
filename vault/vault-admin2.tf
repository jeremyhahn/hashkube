resource "aws_kms_key" "vault_admin2_key" {
  description             = "This key is used to encrypt admin2's vault bucket"
  deletion_window_in_days = 10
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "vault-admin2-key",
  "Statement": [
    {
      "Sid": "Allow root use",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": "kms:*",
      "Resource": "*"
    }, {
      "Sid": "Allow vault instances to decrypt",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${module.vault_cluster.iam_role_id}",
          "${module.vault_cluster.iam_role_arn}"
        ]
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "vault_bucket_admin2" {
  bucket = "${var.appname}-vault-admin2"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
            "AWS": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.vault_admin2.name}",
                "${module.vault_cluster.iam_role_arn}"
            ]
        },
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${var.appname}-vault-admin2"
    },
    {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.vault_admin2.name}",
              "${module.vault_cluster.iam_role_arn}"
          ]
        },
        "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
        ],
        "Resource": [
            "arn:aws:s3:::${var.appname}-vault-admin2/${var.vault_pgp_key2}",
            "arn:aws:s3:::${var.appname}-vault-admin2/vault_encrypted_unseal_key",
            "arn:aws:s3:::${var.appname}-vault-admin2/vault_root_token"
        ]

    }]
}
EOF
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.vault_admin2_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_iam_role" "vault_admin2" {
  name = "vault_admin2"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "vault_admin2_policy" {
  name   = "rw_vault_key2"
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
      "Resource": "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin2.id}"
    }, {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin2.id}/*"
    }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vault_admin2_attachment" {
    role       = "${aws_iam_role.vault_admin2.name}"
    policy_arn = "${aws_iam_policy.vault_admin2_policy.arn}"
}

resource "aws_s3_bucket_object" "vault_admin2_asc" {
  bucket = "${aws_s3_bucket.vault_bucket_admin2.id}"
  key    = "${var.vault_pgp_key2}"
  source = "${path.module}/keys/${var.vault_pgp_key2}"
  etag   = "${md5(file("${path.module}/keys/${var.vault_pgp_key2}"))}"
}
