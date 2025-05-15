FROM ubuntu:latest AS ethereum_builder

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    libatomic1 \
    wget \
    tar \
    net-tools \
    git \
    curl \
    software-properties-common \
    openssl \
    golang \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create users and groups
RUN adduser --disabled-password --gecos "" geth && \
    adduser --disabled-password --gecos "" prysm-beacon && \
    groupadd eth && \
    usermod -a -G eth geth && \
    usermod -a -G eth prysm-beacon

# Generate JWT secret
RUN mkdir -p /var/lib/secrets && \
    openssl rand -hex 32 | tr -d '\n' > /var/lib/secrets/jwt.hex && \
    chgrp -R eth /var/lib/secrets && \
    chmod 750 /var/lib/secrets && \
    chown root:eth /var/lib/secrets/jwt.hex && \
    chmod 640 /var/lib/secrets/jwt.hex

# Create data dirs
RUN mkdir -p /home/geth/geth && \
    mkdir -p /home/prysm-beacon/beacon && \
    chown -R geth:eth /home/geth && \
    chown -R prysm-beacon:eth /home/prysm-beacon

# Install Geth
RUN add-apt-repository -y ppa:ethereum/ethereum && \
    apt-get update && \
    apt-get install -y ethereum && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Build blsync
RUN git clone https://github.com/ethereum/go-ethereum.git /opt/go-ethereum && \
    cd /opt/go-ethereum/cmd/blsync && \
    go build -o /usr/local/bin/blsync

# Copy scripts
COPY start-geth.sh /usr/local/bin/
COPY start-blsync.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-geth.sh /usr/local/bin/start-blsync.sh

