#!/usr/bin/env bash

set -e

GPGHOME=./.gnupg
VAULTHOME=./vault/keys
mkdir -p $VAULTHOME

AUTO_UNSEAL=$1
COUNT=$2
DEVOPS_BUCKET=$3

if [ "$AUTO_UNSEAL" == "true" ]; then
  for (( i=1; i<=$COUNT; i++ ))
  do
    gpg --homedir $GPGHOME --export-secret-keys key$i@localhost | aws s3 cp - s3://$DEVOPS_BUCKET/vault-key$i.secret.asc
  done
fi
