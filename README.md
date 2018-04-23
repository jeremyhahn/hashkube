# HashKube

Full unattended install of HashiCorp Consul, Vault, and Google Kubernetes in a massively scalable, highly available, highly secure, auto-healing architecture in AWS.

# Build requirements

1. [Make](https://www.gnu.org/software/make/)
2. [GPG](https://gnupg.org/download/)
3. [OpenSSL](https://www.openssl.org/source/)
4. [Packer](https://www.packer.io/downloads.html)
5. [Terraform](https://www.terraform.io/downloads.html)
6. [Consul](https://www.consul.io/downloads.html)
7. [Ansible](https://www.ansible.com/resources/get-started)
8. [Shred](https://github.com/wertarbyte/coreutils/blob/master/src/shred.c) (optional)

# Prerequisites

1. AWS keypair (uses `hashkube` by default)
2. AWS CLI installed & configured

# Usage

The included Makefile provides an easy-to-use interface around the included Terraform scripts, their dependencies, and initial bootstrapping of the cluster.

### Variables

  `DEVOPS_BUCKET`:  Optional S3 bucket name used for DevOps automation / artifacts. Default: hashkube-devops
  `KEYPAIR`:  Optional AWS keypair name. Default: hashkube
  `VAULT_AUTO_UNSEAL`: True to auto-unseal vault during deployment
  `VAULT_KEY_SHARES`:  Number of key shares used to initialize vault
  `CLUSTER_NAME`: The name of the k8s cluster
  `CLUSTER_DOMAIN`: The domain name assigned to the k8s cluster

### Targets

The default target includes automation which generates GPG keys used to initialize Vault and TLS certificates to secure Consul and Vault network communications.

GPG keys are generated for Vault initialization and output to `vault/keys`. To bypass this and use an existing key, manually create the directory and keys and then run the `make without-gpg` target.

TLS certificates are generated for both Consul and Vault and output to `consul/tls` and `vault/tls`. To bypass this and use existing certs, manually create the directory and certificates and then run the `make without-tls` target.

To omit both GPG and TLS, run the `make without-gpg-tls` target.

  # Default target (Generate GPG keys, TLS certificates, AMIs and infrastructure)
  make

  # Clean up generated and downlaoded files
  make clean

Once the keys and certificates are in place, the packer and terraform targets can be run independently.

  # Build packer AMIs only
  make packer

  # Run terraform scripts only
  make quick

  # Delete local terraform state, re-initialize and plan / apply with new secrets
  make deploy

See the Makefile for additional targets.

# Vault

### Initialization / unseal keys

Vault administrator's public GPG key is copied to an encrypted S3 bucket accessible only by the admin and Vault cluster itself.  Each Vault admin has their own role to access their key(s). The following example IAM policy would allow another user or group to assume this role:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "arn:aws:iam::123456789012:role/vault_admin1"
            ]
        }
    ]
}
```

### Auto-Unseal

It's possible to sacrifice some security for UX during install by specifying `VAULT_AUTO_UNSEAL=true` (default). Please note this is insecure and therefore not recommended for production environments!

> Auto-unseal is NOT recommended for production environments!

The auto-unseal process exports GPG secret keys to the encrypted `devops` S3 bucket and protects them with IAM policies. It's important the generated keys are NOT password protected as it would require the password be stored in clear-text for the installer script to use later or prompt for it, circumventing the automation.

For the most secure deployment, each Vault administrator should generate their own password protected GPG key on a secure system and provide the **PUBLIC key ONLY** for use in the automation. The Vault will need to be unsealed manually following this type of deployment.
