#!/usr/bin/env bash
# set -x

KEY_PEM=$(terraform output -no-color key_pem)
INSTANCE_HOSTNAME=$(terraform output -no-color public_ip)

rm -f $HOME/.ssh/ipadd.pem
echo "$KEY_PEM" > $HOME/.ssh/ipadd.pem
chmod 400 $HOME/.ssh/ipadd.pem

ssh -i $HOME/.ssh/ipadd.pem coder@$INSTANCE_HOSTNAME