#!/bin/bash
# https://s1na.github.io/light-sync-endpoints/ check here for endpoints
exec blsync --mainnet \
     --beacon.api https://www.lightclientdata.org \
     --blsync.engine.api http://192.168.1.220:8551 \
     --blsync.jwtsecret /var/lib/secrets/jwt.hex

