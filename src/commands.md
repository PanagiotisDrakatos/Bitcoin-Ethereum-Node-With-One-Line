sudo docker-compose build
sudo docker-compose build
sudo docker logs 7fbca13f0f85 | head -n 10
docker exec -it 85bdb03dc502 /bin/bash
bitcoin-cli -rpcconnect=192.168.1.119 -rpcport=8332 -rpcuser=your_rpc_panos -rpcpassword=your_rpc_panos getblockchaininfo
sudo docker system prune -a --volumes





curl --user your_rpc_panos:your_rpc_panos --data-binary '{"jsonrpc":"1.0","id":"curl","method":"getblockchaininfo","params":[]}' -H 'content-type:text/plain;' http://192.168.1.219:8332/ | jq

curl --user your_rpc_panos:your_rpc_panos \
--data-binary '{
"jsonrpc": "1.0",
"id": "curltest",
"method": "scantxoutset",
"params": [
"start",
[
{ "desc": "addr(bc1qte0s6pz7gsdlqq2cf6hv5mxcfksykyyyjkdfd5)" }
]
]
}' \
-H 'Content-Type: application/json' \
http://192.168.1.219:8332/


curl --user your_rpc_panos:your_rpc_panos \
--data-binary '{"jsonrpc": "1.0", "id": "getaddressinfo", "method": "getaddressinfo", "params": ["bc1qte0s6pz7gsdlqq2cf6hv5mxcfksykyyyjkdfd5"]}' \
-H 'Content-Type: application/json' \
http://192.168.1.219:8332/



curl -s -H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' \
http://192.168.1.220:8554 | jq



export INTERFACE=$(ip route | grep default | awk '{print $5}')
export BTC_VERSION=$(curl -s https://bitcoincore.org/en/download/ | grep -oE '[0-9]+\.[0-9]+'| tail -n 1)
sudo docker compose build && sudo docker compose up


docker compose down --rmi all -v

