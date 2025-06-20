FROM ubuntu:22.04 AS ethereum_builder

ARG GO_LANG_VERSION=1.24.3
ENV GOROOT="/usr/local/go"
ENV GOPATH="/go"
ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"

# Install system dependencies (excluding golang to avoid old version)
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
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install specified Go version
RUN curl -LO https://go.dev/dl/go${GO_LANG_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_LANG_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_LANG_VERSION}.linux-amd64.tar.gz

# Create users and groups
RUN adduser --disabled-password --gecos "" geth && \
    adduser --disabled-password --gecos "" prysm-beacon && \
    groupadd eth && \
    usermod -a -G eth geth && \
    usermod -a -G eth prysm-beacon

COPY jwt.hex /var/lib/secrets/jwt.hex
RUN chown root:eth /var/lib/secrets/jwt.hex && chmod 640 /var/lib/secrets/jwt.hex
# Generate JWT secret
RUN chgrp -R eth /var/lib/secrets && \
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
    sed -i 's/^go 1\.23\.0/go 1.24/' /opt/go-ethereum/go.mod || true && \
    cd /opt/go-ethereum/cmd/blsync && \
    go build -o /usr/local/bin/blsync

# Copy scripts
COPY start-geth.sh /usr/local/bin/
COPY start-blsync.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-geth.sh /usr/local/bin/start-blsync.sh