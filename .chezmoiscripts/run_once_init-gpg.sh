#!/bin/bash

set -e

if ! command -v op &> /dev/null; then
    echo "1Password CLI not found, skipping GPG import"
    exit 0
fi

VAULT_ID=$(op vault list --format=json | jq -r '.[] | select(.name=="Personal") | .id')
GPG_ITEM_ID=$(op item list --format=json | jq -r '.[] | select(.title | contains("GPG Key")) | .id')

if [ -z "$GPG_ITEM_ID" ]; then
    echo "GPG Key item not found in 1Password"
    exit 0
fi

op read "op://${VAULT_ID}/${GPG_ITEM_ID}/private.key" | gpg --import
op read "op://${VAULT_ID}/${GPG_ITEM_ID}/public.key" | gpg --import
op read "op://${VAULT_ID}/${GPG_ITEM_ID}/trust.key" | gpg --import-ownertrust