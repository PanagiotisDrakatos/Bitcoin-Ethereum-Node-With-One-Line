# Run Bitcoin and Ethereum Node With One Single Line easily
    chmod +x run.sh start-blsync.sh start-geth.sh | ./run.sh
This project provides a Docker-based setup for running both Bitcoin and Ethereum full nodes. It automates the deployment process, making it easy to run and maintain cryptocurrency nodes on your local network.

## Features

### Bitcoin Node
- Full Bitcoin Core node with transaction indexing enabled
- RPC interface for interacting with the node
- Automatic detection and installation of the latest Bitcoin Core version
- Persistent blockchain data storage using Docker volumes

### BTC RPC Explorer
#### Self-Hosted Bitcoin explorer for everyone running Bitcoin Core

![img.png](img.png)

BitcoinExplorer.org is a blockchain explorer that allows users to search and analyze 
Bitcoin transactions, blocks, and addresses. It provides a user-friendly interface for
accessing detailed information about the Bitcoin blockchain, making it useful for tracking
transactions, verifying balances, and exploring network activity. 

This is a self-hosted explorer for the Bitcoin blockchain, driven by RPC calls to your own 
Bitcoin node. It will run and can already connect to other tools (such as Electrum servers) 
to accomplish this to achieve a full-featured explorer.  Whatever reasons you may have for 
running a full node (trustlessness, technical curiosity, supporting the network, etc) 
it's valuable to appreciate the fullness of your node. With this explorer, you can explore 
not just the  blockchain database, but also explore all of the functional capabilities of your 
own node.

### Ethereum Node
- Geth node running in snap sync mode
- HTTP and Auth RPC interfaces for interacting with the node
- Blockchain sync tool (blsync) for faster synchronization
- Persistent blockchain data storage using Docker volumes

## Prerequisites

- Docker and Docker Compose installed
- Linux-based system (for the network interface detection)
- Good internet connection for initial blockchain download

## Hardware Requirements

### Disk Space
- **Bitcoin Full Node**: Approximately 400-500 GB for the full blockchain
- **Ethereum Snap Node**: Approximately 150-200 GB (significantly less than a full Ethereum node which requires 1+ TB)
- **Total Disk Space**: At least 600-700 GB recommended for both nodes

### CPU Requirements
- **Minimum**: 4-core CPU (Intel Core i5/i7 or AMD equivalent)
- **Recommended**: 8-core CPU for better performance, especially during initial sync

### RAM Requirements
- **Minimum**: 8 GB RAM
- **Recommended**: 16 GB RAM for optimal performance
- **Note**: During initial sync, memory usage may spike temporarily

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
- Btc-rpc-explorer: 192.168.1.222
- Electrs: 192.168.1.223(Using the same port as btc-rpc-explorer and gives details infos such as txid, blockhash, balances etc)

## Testing Node Status

### Bitcoin Node Status

To check if your Bitcoin node is running properly, use the following command:

```bash
curl --user your_rpc_panos:DrUCN_zExQMDGkRn2e87z4rBxGsboz6p3tXzzE7_vNo --data-binary '{"jsonrpc":"1.0","id":"curl","method":"getblockchaininfo","params":[]}' -H 'content-type:text/plain;' http://192.168.1.219:8332/ | jq
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
