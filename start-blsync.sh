#!/bin/bash
# https://s1na.github.io/light-sync-endpoints/ check here for endpoints
until nc -z 192.168.1.220 8551; do
  echo "Waiting for Geth to be ready..."
  sleep 2
done

exec blsync --mainnet \
     --beacon.api https://lodestar-mainnet.chainsafe.io/ \
     --blsync.engine.api http://192.168.1.220:8551 \
     --blsync.jwtsecret /var/lib/secrets/jwt.hex

