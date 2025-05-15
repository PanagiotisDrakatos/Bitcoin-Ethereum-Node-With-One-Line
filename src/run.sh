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
echo "BTC_VERSION=$BTC_VERSION" > .env
echo "INTERFACE=$INTERFACE" >> .env

# Run Docker Compose
echo "Building Docker containers..."
sudo docker compose build

echo "Starting Docker containers..."
sudo docker compose up
