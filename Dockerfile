# ============================================================
# Network Testing Tools Image
# Base: Alpine Linux (minimal, ~150MB)
# Build: Local build
# Run: Offline K8s environments
# Project: https://github.com/freemankevin/network-tools
# ============================================================

FROM alpine:3.18

LABEL maintainer="freemankevin" \
      description="Network testing tools for K8s (nmap, iperf3, tcpdump, etc.)" \
      version="1.0.0" \
      repository="https://github.com/freemankevin/network-tools"

RUN apk add --no-cache \
    curl \
    wget \
    netcat-openbsd \
    busybox-extras \
    bind-tools \
    iputils \
    iproute2 \
    nmap \
    tcpdump \
    ethtool \
    iperf3 \
    drill \
    bash \
    vim \
    jq \
    yq \
    openssh \
    openssl \
    ca-certificates \
    conntrack-tools \
    mtr \
    traceroute \
    htop \
    strace \
    socat \
    whois \
    arping \
    lsof \
    net-tools \
    bridge-utils \
    ipvsadm \
    && rm -rf /var/cache/apk/*

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
echo "  • socat           - Advanced relay"
echo "  • telnet          - Telnet client"
echo "  • dig, drill      - DNS queries"
echo "  • nmap            - Port scanner"
echo "  • iperf3          - Bandwidth test"
echo "  • tcpdump         - Packet capture"
echo "  • ping, traceroute, mtr  - Latency"
echo "  • arping          - ARP diagnostics"
echo "  • whois           - Domain info"
echo "  • lsof, htop      - Process monitor"
echo "  • strace          - Syscall trace"
echo "  • ip, bridge      - Network config"
echo "  • ipvsadm         - IPVS admin"
echo "  • jq, vim         - Utilities"
echo ""
echo "Run as root user"
echo "=============================================="

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec /bin/bash
fi
EOF

RUN chmod +x /entrypoint.sh

WORKDIR /root

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
