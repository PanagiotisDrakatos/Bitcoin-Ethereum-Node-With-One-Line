FROM ubuntu:22.04 AS bitcoin_builder

ARG BITCOIN_VERSION

RUN apt-get update -y && \
    apt-get install -y net-tools && \
    apt-get install -y git && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    libatomic1 \
    wget \
    tar \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -ms /bin/bash btc-user

# Download Bitcoin Core and verify
WORKDIR /tmp
RUN wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS && \
    wget https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc && \
    sha256sum --ignore-missing --check SHA256SUMS && \
    git clone https://github.com/bitcoin-core/guix.sigs && \
    gpg --import guix.sigs/builder-keys/* && \
    gpg --verify SHA256SUMS.asc && \
    tar -xvf bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz && \
    install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${BITCOIN_VERSION}/bin/* && \
    rm -rf /tmp/*

# Set up Bitcoin config
USER btc-user
RUN mkdir -p /home/btc-user/.bitcoin
COPY --chown=btc-user:btc-user bitcoin.conf /home/btc-user/.bitcoin/bitcoin.conf

# Entry point
USER root
RUN  set -e
RUN mkdir -p /run/bitcoind
ENTRYPOINT exec bitcoind \
  -pid=/run/bitcoind/bitcoind.pid \
  -conf=/home/btc-user/.bitcoin/bitcoin.conf \
  -datadir=/home/btc-user/.bitcoin