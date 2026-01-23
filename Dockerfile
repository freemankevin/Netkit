# ============================================================
# Network Testing Tools Image
# Base: Alpine Linux (minimal, ~150MB)
# Build: Local build
# Run: Offline K8s environments
# Project: https://github.com/freemankevin/network-tools
# ============================================================

FROM alpine:3.18

# Metadata
LABEL maintainer="freemankevin" \
      description="Network testing tools for K8s (nmap, iperf3, tcpdump, etc.)" \
      version="1.0.0" \
      repository="https://github.com/freemankevin/network-tools"

# Install all tools in one layer for smaller image size
RUN apk add --no-cache \
    # Core networking tools
    curl \
    wget \
    netcat-openbsd \
    telnet \
    bind-tools \
    iputils \
    iproute2 \
    # Advanced networking & security tools
    nmap \
    tcpdump \
    ethtool \
    # Performance testing
    iperf3 \
    # DNS utilities
    drill \
    # CLI utilities
    bash \
    vim \
    jq \
    yq \
    openssh-client \
    openssl \
    ca-certificates \
    # For K8s networking diagnostics
    conntrack-tools \
    && rm -rf /var/cache/apk/*

# Set setuid for network tools that need elevated privileges
RUN chmod +s /bin/ping \
    && chmod +s /usr/bin/traceroute \
    && chmod +s /usr/sbin/mtr

# Create non-root user for security
RUN adduser -D -s /bin/bash networker \
    && echo "networker:networker" | chpasswd

# Create entrypoint script
COPY <<'EOF' /entrypoint.sh
#!/bin/bash
set -e

echo "=============================================="
echo "  Network Testing Tools Container Ready"
echo "=============================================="
echo ""
echo "Available tools:"
echo "  • curl, wget      - HTTP clients"
echo "  • nc (netcat)     - TCP/HTTP utils"
echo "  • telnet          - Telnet client"
echo "  • dig, drill      - DNS queries"
echo "  • nmap            - Port scanner"
echo "  • iperf3          - Bandwidth test"
echo "  • tcpdump         - Packet capture"
echo "  • ping, traceroute, mtr  - Latency"
echo "  • jq, vim         - Utilities"
echo ""
echo "Run as user: networker"
echo "=============================================="

# Execute command
if [ $# -gt 0 ]; then
    exec "$@"
else
    exec /bin/bash
fi
EOF

RUN chmod +x /entrypoint.sh

WORKDIR /home/networker
USER networker

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
