#!/bin/bash

set -e

#git clone git://github.com/ansible/ansible.git
#cd ansible/ && source hacking/env-setup
#git checkout v2.5.0

#sudo pip install ansible

KEY1="${vault_pgp_key1}/key1.asc"
KEY2="${vault_pgp_key2}/key2.asc"
KEY3="${vault_pgp_key3}/key3.asc"

TMPKEY1="/tmp/$KEY1"
TMPKEY2="/tmp/$KEY2"
TMPKEY3="/tmp/$KEY3"

KEYCOUNT=${vault_key_shares}

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

readonly VAULT_TLS_CERT_FILE="/opt/vault/tls/vault.crt.pem"
readonly VAULT_TLS_KEY_FILE="/opt/vault/tls/vault.key.pem"

aws s3 cp s3://${devops_bucket}/${consul_encryption_key} /tmp/${consul_encryption_key}

/opt/consul/bin/run-consul \
  --client \
  --cluster-tag-key "${consul_cluster_tag_key}" \
  --cluster-tag-value "${consul_cluster_tag_value}" \
  --enable-gossip-encryption \
  --gossip-encryption-key `cat /tmp/${consul_encryption_key}`
sleep 60 # Give the consul cluster time to build quorum

/opt/vault/bin/run-vault --tls-cert-file "$VAULT_TLS_CERT_FILE" --tls-key-file "$VAULT_TLS_KEY_FILE"
sleep 60 # Give the vault cluster time to bootstrap


## Initialize Vault

aws s3 cp s3://${vault_admin1_bucket}/${vault_pgp_key1} /tmp/${vault_pgp_key1}
aws s3 cp s3://${vault_admin2_bucket}/${vault_pgp_key2} /tmp/${vault_pgp_key2}
aws s3 cp s3://${vault_admin3_bucket}/${vault_pgp_key3} /tmp/${vault_pgp_key3}

cat /tmp/${vault_pgp_key1} | tr '\n' ' ' | sed 's/ //g' > /tmp/key1.base64
cat /tmp/${vault_pgp_key2} | tr '\n' ' ' | sed 's/ //g' > /tmp/key2.base64
cat /tmp/${vault_pgp_key3} | tr '\n' ' ' | sed 's/ //g' > /tmp/key3.base64

curl -s \
  --insecure \
  --request PUT \
  --data "{\"secret_shares\":${vault_key_shares},\"secret_threshold\":${vault_key_threshold},\"pgp_keys\":[\"`cat /tmp/key1.base64`\",\"`cat /tmp/key2.base64`\",\"`cat /tmp/key3.base64`\"]}" \
  https://localhost:8200/v1/sys/init > /tmp/unseal.txt

UNSEAL_KEY1=`cat /tmp/unseal.txt  | jq '.keys_base64[0]' | sed 's/"//g'`
UNSEAL_KEY2=`cat /tmp/unseal.txt  | jq '.keys_base64[1]' | sed 's/"//g'`
UNSEAL_KEY3=`cat /tmp/unseal.txt  | jq '.keys_base64[2]' | sed 's/"//g'`
ROOT_TOKEN=`cat /tmp/unseal.txt  | jq '.root_token' | sed 's/"//g'`

echo $UNSEAL_KEY1 | aws s3 cp - s3://hashkube-vault-admin1/vault_encrypted_unseal_key
echo $UNSEAL_KEY2 | aws s3 cp - s3://hashkube-vault-admin2/vault_encrypted_unseal_key
echo $UNSEAL_KEY3 | aws s3 cp - s3://hashkube-vault-admin3/vault_encrypted_unseal_key

echo $ROOT_TOKEN | aws s3 cp - s3://hashkube-vault-admin1/vault_root_token
echo $ROOT_TOKEN | aws s3 cp - s3://hashkube-vault-admin2/vault_root_token
echo $ROOT_TOKEN | aws s3 cp - s3://hashkube-vault-admin3/vault_root_token


## Auto-Unseal Vault

if [ "${vault_auto_unseal}" == "true" ]; then
  i=1
  while [ $i -lt $KEYCOUNT ] || [ $i -eq $KEYCOUNT ]; do
      aws s3 cp s3://${devops_bucket}/vault-key$i.secret.asc /tmp/key$i.secret.asc
      aws s3 cp s3://hashkube-vault-admin$i/vault_encrypted_unseal_key /tmp/vault_encrypted_unseal_key$i
      gpg --allow-secret-key-import --import /tmp/key$i.secret.asc || true
      cat /tmp/vault_encrypted_unseal_key$i | base64 -d | gpg -dq > /tmp/vault_DECRYPTED_unseal_key$i
      curl -s \
        --insecure \
        --request PUT \
        --data "{\"key\":\"`cat /tmp/vault_DECRYPTED_unseal_key$i`\"}" \
        https://localhost:8200/v1/sys/unseal
      let i=i+1
  done
fi

SEALED=`curl -s --insecure https://localhost:8200/v1/sys/seal-status  | jq '.sealed'`
if [ "$SEALED" == "true" ]; then
  echo "Vault unseal failed!"
  exit 255
fi

#shred -z -u /tmp/consul* /tmp/key* /tmp/vault* /tmp/unseal.txt

exit 0
