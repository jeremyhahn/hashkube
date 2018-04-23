ORG := jeremyhahn
PACKAGE := hashkube
TARGET_OS := linux

SHRED := $(shell command -v shred 2> /dev/null)
TLSDIR := tls
DEVOPS_BUCKET=hashkube-devops
KEYPAIR=hashkube
VAULT_AUTO_UNSEAL=true
VAULT_KEY_SHARES=3
CLUSTER_NAME=hashkube
CLUSTER_DOMAIN=jeremyhahn.com

default: quick

gpg-clean:
	rm -rf .gnupg/ vault/keys

certs-clean:
ifndef SHRED
		rm -rf vault/tls consul/tls
else
		shred -z -u vault/tls consul/tls
endif

privatetls-clean:
ifndef SHRED
		rm -rf privatetls/.terraform privatetls/terraform.tfstate*
else
		shred -z -u privatetls/.terraform privatetls/terraform.tfstate*
endif

terraform-clean:
	rm -rf .terraform/ terraform-aws* terraform.tfstate* tfplan

clean: gpg-clean terraform-clean certs-clean privatetls-clean

gpg-init:
	@./gpg-init.sh $(VAULT_KEY_SHARES)

gpg-secrets:
	@./gpg-secrets.sh $(VAULT_AUTO_UNSEAL) $(VAULT_KEY_SHARES) $(DEVOPS_BUCKET)

clone:
	git clone git@github.com:hashicorp/terraform-aws-consul.git
	git clone git@github.com:hashicorp/terraform-aws-vault.git

consul-certs:
	mkdir consul/tls
	cd privatetls; \
	 terraform init && terraform apply \
	 	-var owner=$(USER) \
		-var build_user=$(USER) \
		-var 'ca_public_key_file_path=../consul/tls/consul-ca.crt.pem' \
		-var 'public_key_file_path=../consul/tls/consul.crt.pem' \
		-var 'private_key_file_path=../consul/tls/consul.key.pem' \
		-var 'dns_names=["localhost", "service.consul"]' \
		-auto-approve
	cp -R consul/tls/ vault/
	$(MAKE) privatetls-clean

vault-certs:
	cd privatetls; \
	 terraform init && terraform apply \
		-var owner=$(USER) \
		-var build_user=$(USER) \
		-var 'ca_public_key_file_path=../vault/tls/vault-ca.crt.pem' \
		-var 'public_key_file_path=../vault/tls/vault.crt.pem' \
		-var 'private_key_file_path=../vault/tls/vault.key.pem' \
		-var 'dns_names=["localhost", "vault.service.consul"]' \
		-auto-approve
	$(MAKE) privatetls-clean

certs: clone consul-certs vault-certs

packer:
	packer build consul/consul.json
	packer build vault/vault.json

terraform-base:
	terraform plan \
	  -var build_user=$(USER) \
	  -var devops_bucket_name=$(DEVOPS_BUCKET) \
		-var default_ssh_key_name=$(KEYPAIR) \
	 	-target=module.vpc \
		-target=module.bastionvpn \
		-target=module.devops \
		-out=tfplan && terraform apply tfplan

terraform-stacks:
	terraform plan \
	  -var build_user=$(USER) \
	  -var devops_bucket_name=$(DEVOPS_BUCKET) \
		-var default_ssh_key_name=$(KEYPAIR) \
		-var vault_key_shares=$(VAULT_KEY_SHARES) \
		-var vault_auto_unseal=$(VAULT_AUTO_UNSEAL) \
	  -out=tfplan && terraform apply tfplan

terraform-kube:
	cd kubernetes && terraform init && terraform plan \
	  -var 'cluster_name=$(CLUSTER_NAME)' \
		-var 'cluster_admin_email=$(CLUSTER_ADMIN_EMAIL)' \
		-var 'cluster_admin_password=$(CLUSTER_ADMIN_PASSWORD)' \
		-var 'default_ssh_key_name=$(KEYPAIR)' \
		-var 'base_domain=$(CLUSTER_DOMAIN)' \
		-var 'cluster_name=$(CLUSTER_NAME)' && terraform apply

terraform-init:
	terraform init

terraform: terraform-base terraform-stacks

terraform-all: terraform-init terraform-base secrets terraform-stacks

secrets:
	consul keygen |	aws s3 cp - s3://$(DEVOPS_BUCKET)/consul_encryption_key
	DEVOPS_BUCKET=$(DEVOPS_BUCKET) VAULT_AUTO_UNSEAL=$(VAULT_AUTO_UNSEAL) VAULT_KEY_SHARES=$(VAULT_KEY_SHARES) $(MAKE) gpg-secrets

init:	gpg-init certs terraform-init

install: clean init packer terraform-all

without-gpg: clean certs packer terraform-all

without-tls: clean gpg-init packer terraform-all

without-gpg-tls: clean packer terraform-all

quick: terraform-init terraform-base terraform-stacks

deploy: terraform-clean terraform-init terraform-base secrets terraform-stacks

destroy:
	terraform destroy -force \
	  -var build_user=$(USER) \
	  -var devops_bucket_name=$(DEVOPS_BUCKET) \
	  -var default_ssh_key_name=$(KEYPAIR) && \
		$(MAKE) terraform-clean
