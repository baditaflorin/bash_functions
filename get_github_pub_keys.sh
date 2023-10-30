#!/bin/bash

USERNAME=baditaflorin

mkdir -p ~/.ssh

if ! [[ -f ~/.ssh/authorized_keys ]]; then
  echo "Creating new ~/.ssh/authorized_keys"
  touch ~/.ssh/authorized_keys
fi

keys=$(curl -s https://api.github.com/users/$USERNAME/keys | jq -r '.[].key')

for key in $keys; do
  echo $key
  grep -q "$key" ~/.ssh/authorized_keys || echo "$key" >> ~/.ssh/authorized_keys
done

#ORIGINAL Https://www.codementor.io/@slavko/batch-add-github-keys-as-authorized-keys-du107usio
