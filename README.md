# Run Bitcoin and Ethereum Node With One Single Line easily
    ./run.sh
This project provides a Docker-based setup for running both Bitcoin and Ethereum full nodes. It automates the deployment process, making it easy to run and maintain cryptocurrency nodes on your local network.

## Features

### Bitcoin Node
- Full Bitcoin Core node with transaction indexing enabled
- RPC interface for interacting with the node
- Automatic detection and installation of the latest Bitcoin Core version
- Persistent blockchain data storage using Docker volumes

### Ethereum Node
- Geth node running in snap sync mode
- HTTP and Auth RPC interfaces for interacting with the node
- Blockchain sync tool (blsync) for faster synchronization
- Persistent blockchain data storage using Docker volumes

## Prerequisites

- Docker and Docker Compose installed
- Linux-based system (for the network interface detection)
- Sufficient disk space for blockchain data (500+ GB recommended)
- Good internet connection for initial blockchain download

## Installation and Usage

1. Clone this repository:
   ```
   git clone https://github.com/PanagiotisDrakatos/Bitcoin-Ethereum-Node-With-One-Line
   cd Bitcoin-Ethereum-Node-With-One-Line/src
   ```

2. Make the run script executable:
   ```
   chmod +x run.sh
   ```

3. Run the setup script:
   ```
   ./run.sh
   ```

The script will:
- Detect your network interface
- Fetch the latest Bitcoin Core version
- Build the Docker containers
- Start both Bitcoin and Ethereum nodes

## Network Configuration

The nodes are configured with the following network settings:

- Bitcoin node: 192.168.1.219
  - P2P port: 8333
  - RPC port: 8332

- Ethereum node: 192.168.1.220
  - HTTP RPC port: 8554
  - Auth RPC port: 8551

- Ethereum blsync: 192.168.1.221

## Testing Node Status

### Bitcoin Node Status

To check if your Bitcoin node is running properly, use the following command:

```bash
curl --user your_rpc_Username:your_rpc_Password --data-binary '{"jsonrpc":"1.0","id":"curl","method":"getblockchaininfo","params":[]}' -H 'content-type:text/plain;' http://192.168.1.219:8332/ | jq
```

This will return information about the blockchain, including the current block height and sync status.

### Ethereum Node Status

To check if your Ethereum node is running properly, use the following command:

```bash
curl -s -H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' \
http://192.168.1.220:8554 | jq
```

This will return information about the Ethereum node's sync status. If the node is fully synced, it will return `false`. If it's still syncing, it will return details about the sync progress.

## Customization

### Bitcoin Configuration

You can modify the Bitcoin node configuration by editing the `bitcoin.conf` file. The default configuration includes:

- Transaction indexing enabled
- Wallet functionality disabled
- RPC access from the local network

### Ethereum Configuration

You can modify the Ethereum node configuration by editing the `start-geth.sh` and `start-blsync.sh` scripts. The default configuration includes:

- Snap sync mode
- HTTP API with eth, net, engine, and admin modules enabled
- JWT authentication for RPC

## Data Persistence

Blockchain data is stored in Docker volumes:

- `bitcoin_volume`: Bitcoin blockchain data
- `ethereum_volume`: Ethereum blockchain data

These volumes persist even if the containers are stopped or removed.

## Security Considerations

- The default RPC credentials for the Bitcoin node are insecure. Change the `rpcuser` and `rpcpassword` in `bitcoin.conf` before deploying in a production environment.
- The nodes are configured to be accessible from the local network. Consider adding firewall rules to restrict access if needed.

## License

- [MIT License](https://github.com/PanagiotisDrakatos/Bitcoin-Ethereum-Node-With-One-Line/blob/main/LICENSE)

## Author

- Panagiotis Drakatos