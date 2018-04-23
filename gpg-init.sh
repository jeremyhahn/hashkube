#!/usr/bin/env bash

set -e

GPGHOME=./.gnupg
VAULTHOME=./vault/keys
mkdir -p $VAULTHOME

COUNT=$1

echo ""
echo "*** WARNING: These keys are extremely sensitive and important! ***"
echo ""
echo "Have a look at 'haveged' if key generation takes a while..."
echo ""

for (( i=1; i<=$COUNT; i++ ))
do
  #read -s -p "Vault key $i passphrase: " PASSPHRASE1;
  #read -s -p "Vault key $i passphrase (confirm): " PASSPHRASE2;
  #if [ "$PASSPHRASE1" != "$PASSPHRASE2" ]; then
  #  echo "Error: Passwords don't match!"
  #  exit 1
  #fi
  #PASSPHRASE=""
  #if [ "$PASSPHRASE1" != "" ]; then
  #  PASSPHRASE="Passphrase: ${PASSPHRASE1}"
  #fi

  gpg --homedir $GPGHOME --verbose --batch --gen-key <<EOF
    %echo Generating 2048 bit OpenPGP key for HashiCorp Vault
    Key-Type: RSA
    Key-Length: 2048
    Subkey-Type: RSA
    Subkey-Length: 2048
    Name-Real: Vault Master Key 1
    Name-Comment: Key used to seal/unseal vault
    Name-Email: key$i@localhost
    Expire-Date: 0
    ${PASSPHRASE}
    %commit
EOF
  gpg --homedir $GPGHOME --export key$i@localhost | base64 > $VAULTHOME/key$i.asc

done
