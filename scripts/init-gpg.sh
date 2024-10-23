#/bin/bash

VALUT_ID=$(op vault list | grep Personal | awk '{print $1}')
GPG_ITEM_ID=$(op items list | grep "GPG Key" | awk '{print $1}')

op read "op://${VALUT_ID}/${GPG_ITEM_ID}/private.key" | gpg --import
op read "op://${VALUT_ID}/${GPG_ITEM_ID}/public.key" | gpg --import
op read "op://${VALUT_ID}/${GPG_ITEM_ID}/trust.key" | gpg --import-ownertrust