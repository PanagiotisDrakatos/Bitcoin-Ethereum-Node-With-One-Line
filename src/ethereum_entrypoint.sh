#!/bin/bash
set -e


# Start Geth in background
geth --syncmode snap \
     --http.api eth,net,engine,admin \
     --authrpc.jwtsecret /var/lib/secrets/jwt.hex \
     --mainnet \
     --authrpc.addr 192.168.1.220 \
     --authrpc.port 8551 \
     --http \
     --http.addr 192.168.1.220 \
     --http.port 8554 \
     --datadir /home/geth/geth

# Wait a bit to ensure Geth is up (or use retry loop)
sleep 5

# Start blsync
blsync --mainnet \
         --beacon.api https://www.lightclientdata.org \
         --blsync.engine.api http://192.168.1.220:8554 \
         --blsync.jwtsecret /var/lib/secrets/jwt.hex