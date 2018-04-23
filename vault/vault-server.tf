resource "aws_iam_instance_profile" "vault_profile" {
  name  = "vault"
  role = "${aws_iam_role.vault_root.name}"
}

resource "aws_iam_role" "vault_root" {
  name = "vault"
  path = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "AWS": [
                  "${data.aws_caller_identity.current.arn}"
              ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "vault_root_policy" {
  name   = "rw_vault_root_keys"
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
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin1.id}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin2.id}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin3.id}"
      ]
    }, {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin1.id}/${var.vault_pgp_key1}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin2.id}/${var.vault_pgp_key2}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin3.id}/${var.vault_pgp_key3}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin1.id}/${var.vault_pgp_key1_secret}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin2.id}/${var.vault_pgp_key2_secret}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin3.id}/${var.vault_pgp_key3_secret}",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin1.id}/vault_encrypted_unseal_key",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin2.id}/vault_encrypted_unseal_key",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin3.id}/vault_encrypted_unseal_key",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin1.id}/vault_root_token",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin2.id}/vault_root_token",
        "arn:aws:s3:::${aws_s3_bucket.vault_bucket_admin3.id}/vault_root_token"
      ]
    }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "vault_cluster_policy_attachment" {
    role       = "${module.vault_cluster.iam_role_id}"
    policy_arn = "${aws_iam_policy.vault_root_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "vault_policy_attachment" {
    role       = "${aws_iam_role.vault_root.name}"
    policy_arn = "${aws_iam_policy.vault_root_policy.arn}"
}
