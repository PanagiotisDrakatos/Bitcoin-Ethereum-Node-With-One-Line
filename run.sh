#!/bin/bash
set -e

# Function to check if a command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Check Python 3
if check_command python3; then
    echo "✅ Python 3 is already installed."
else
    echo "🚀 Python 3 is NOT installed. Installing now..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install python
    else
        sudo apt update && sudo apt install -y python3  # For Debian/Ubuntu
    fi
fi

# Check Docker
if check_command docker; then
    echo "✅ Docker is installed: $(docker --version)"
else
    echo "❌ Error: Docker is NOT installed. Please install it first."
    exit 1
fi

# Check Docker Compose (support both legacy and new)
if check_command docker-compose; then
    DOCKER_COMPOSE="docker-compose"
    echo "✅ Docker Compose is installed: $(docker-compose --version)"
elif docker compose version &>/dev/null; then
    DOCKER_COMPOSE="docker compose"
    echo "✅ Docker Compose is installed: $(docker compose version)"
else
    echo "❌ Error: Docker Compose is NOT installed. Please install it first."
    exit 1
fi


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
echo "Interface : $INTERFACE"

if [ -f .env ]; then
    echo "✅ .env file exists!"
 else
   echo "❌ .env file is missing!"
       # Set username
       RPC_USER="bitcoinrpc"
       RPC_PASS=$(openssl rand -base64 32)

       # Path to rpcauth.py (change this to actual path)
       RPCAUTH_SCRIPT="rpcauth.py"

       if [ ! -f "$RPCAUTH_SCRIPT" ]; then
           echo "❌ Error: rpcauth.py not found at $RPCAUTH_SCRIPT"
           exit 1
       fi

       RPCAUTH_OUTPUT=$(python3 "$RPCAUTH_SCRIPT" "$RPC_USER" "$RPC_PASS")
       AUTH=$(echo "$RPCAUTH_OUTPUT" | grep '^rpcauth=')
       RPC_CREATED_PASS=$(echo "$RPCAUTH_OUTPUT" | awk '/Your password:/{getline; print}')

       # Remove the last line if it starts with 'rpcauth', then append the new value
       if [ -f bitcoin.conf ]; then
           # Check if the last line starts with 'rpcauth'
           if tail -n 1 bitcoin.conf | grep -q '^rpcauth'; then
               # Remove the last line
               head -n -1 bitcoin.conf > bitcoin.conf.tmp
               mv bitcoin.conf.tmp bitcoin.conf
           fi
       fi
       # Save credentials to bitcoin.conf
       echo "$AUTH" >> bitcoin.conf
       echo "✅ RPC authentication has been updated in bitcoin.conf!"
       echo "🔐 RPCAUTH_OUTPUT=: $RPCAUTH_OUTPUT"
       echo "🔐 Saved password: $RPC_CREATED_PASS"

       # Write to .env file
       # shellcheck disable=SC2129
       echo "BTC_VERSION=$BTC_VERSION" >> .env
       echo "INTERFACE=$INTERFACE" >> .env
       echo "BTCEXP_HOST=192.168.1.222" >>.env
       echo "BTCEXP_PORT=3002" >> .env
       echo "BTCEXP_ADDRESS_API=electrum" >> .env
       echo "BTCEXP_ELECTRUM_SERVERS=tcp://192.168.1.223:50001" >> .env
       echo "BTCEXP_ELECTRUM_TXINDEX=true" >> .env
       echo "BTCEXP_BITCOIND_URI=bitcoin://${RPC_USER}:${RPC_CREATED_PASS}@192.168.1.219:8332?timeout=40000">> .env
       echo "BTCEXP_BITCOIND_USER=${RPC_USER}" >> .env
       echo "BTCEXP_BITCOIND_PASS=${RPC_CREATED_PASS}" >> .env
       echo "BTCEXP_BITCOIND_RPC_TIMEOUT=70000" >> .env
       echo "BTCEXP_SECURE_SITE=false" >> .env
       echo "BTCEXP_COIN=BTC" >> .env
       echo "BTCEXP_RPC_CONCURRENCY=550" >> .env
       echo "BTCEXP_SLOW_DEVICE_MODE=false" >> .env
       echo "BTCEXP_NO_RATES=true" >> .env
       echo "BTCEXP_RPC_ALLOWALL=true" >> .env
       echo "BTCEXP_UI_TIMEZONE=local" >> .env
       echo "BTCEXP_UI_THEME=dark" >> .env
 fi

# Get the default network interface
if [[ "$OSTYPE" == "darwin"* ]]; then
    INTERFACE=$(route get default 2>/dev/null | grep interface | awk '{print $2}' | head -n 1)
else
    INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)
fi

if [ -z "$INTERFACE" ]; then
    echo "Error: Could not determine the network interface."
    exit 1
fi

echo "Using network interface: $INTERFACE"

# Get latest Bitcoin Core version (match x.y.z)
BTC_VERSION=$(curl -s https://bitcoincore.org/en/download/ | grep -oE '[0-9]+\.[0-9]+'| tail -n 1)

if [ -z "$BTC_VERSION" ]; then
    echo "Error: Could not fetch Bitcoin Core version."
    exit 1
fi

echo "Latest Bitcoin Core version: $BTC_VERSION"

# Run Docker Compose
echo "Building Docker containers..."
sudo docker compose build

echo "Starting Docker containers..."
sudo docker compose up