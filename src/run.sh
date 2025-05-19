#!/bin/bash

# Exit script on any error
set -e

# Get the default network interface
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)

if [ -z "$INTERFACE" ]; then
  echo "Error: Could not determine the network interface."
  exit 1
fi

echo "Using network interface: $INTERFACE"

# Get the latest Bitcoin Core version from the website
BTC_VERSION=$(curl -s https://bitcoincore.org/en/download/ | grep -oE '[0-9]+\.[0-9]+'| tail -n 1)

if [ -z "$BTC_VERSION" ]; then
  echo "Error: Could not fetch Bitcoin Core version."
  exit 1
fi

echo "Latest Bitcoin Core version: $BTC_VERSION"

# Write to .env file
# shellcheck disable=SC2129
echo "BTC_VERSION=$BTC_VERSION" >> .env
echo "INTERFACE=$INTERFACE" >> .env
echo "BTCEXP_HOST=192.168.1.222" >>.env
echo "BTCEXP_PORT=3002" >> .env
echo "BTCEXP_ADDRESS_API=electrum" >> .env
echo "BTCEXP_ELECTRUM_SERVERS=tcp://192.168.1.223:50001" >> .env
echo "BTCEXP_ELECTRUM_TXINDEX=true" >> .env
echo "BTCEXP_BITCOIND_URI=bitcoin://your_rpc_panos:DrUCN_zExQMDGkRn2e87z4rBxGsboz6p3tXzzE7_vNo@192.168.1.219:8332?timeout=40000">> .env
echo "BTCEXP_BITCOIND_USER=your_rpc_panos" >> .env
echo "BTCEXP_BITCOIND_PASS=DrUCN_zExQMDGkRn2e87z4rBxGsboz6p3tXzzE7_vNo" >> .env
echo "BTCEXP_BITCOIND_RPC_TIMEOUT=70000" >> .env
echo "BTCEXP_SECURE_SITE=false" >> .env
echo "BTCEXP_COIN=BTC" >> .env
echo "BTCEXP_RPC_CONCURRENCY=550" >> .env
echo "BTCEXP_SLOW_DEVICE_MODE=false" >> .env
echo "BTCEXP_NO_RATES=true" >> .env
echo "BTCEXP_RPC_ALLOWALL=true" >> .env
echo "BTCEXP_UI_TIMEZONE=local" >> .env
echo "BTCEXP_UI_THEME=dark" >> .env

# Run Docker Compose
echo "Building Docker containers..."
sudo docker compose build

echo "Starting Docker containers..."
sudo docker compose up
