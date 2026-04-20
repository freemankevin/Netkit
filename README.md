# Netkit

[![Build and Push](https://github.com/freemankevin/Netkit/actions/workflows/build.yml/badge.svg)](https://github.com/freemankevin/Netkit/actions/workflows/build.yml)
[![GitHub release](https://img.shields.io/github/v/release/freemankevin/Netkit?include_prereleases)](https://github.com/freemankevin/Netkit/releases)
[![Docker Pulls](https://img.shields.io/badge/ghcr.io-freemankevin%2FNetkit-blue)](https://github.com/freemankevin/Netkit/pkgs/container/Netkit)
[![License](https://img.shields.io/github/license/freemankevin/Netkit)](LICENSE)

基于 Alpine Linux 的轻量级网络测试工具镜像，专为容器化场景设计。

## ✨ 特性

- **轻量级**: 基于 Alpine Linux，镜像约 150MB
- **多架构**: 支持 linux/amd64, linux/arm64
- **工具丰富**: 包含 30+ 常用网络测试工具
- **离线友好**: 专为私有化离线环境设计，无需互联网访问
- **容器化优化**: 预置容器网络排查工具

## 🛠 内置工具

| 类别 | 工具 | 说明 |
|------|------|------|
| **HTTP 客户端** | curl, wget | HTTP/HTTPS 请求 |
| **TCP 工具** | nc (netcat), telnet, socat | TCP 连接测试、端口转发 |
| **DNS 查询** | dig, drill, whois | DNS 解析、域名信息 |
| **端口扫描** | nmap | 端口扫描、主机发现 |
| **带宽测试** | iperf3 | 网络性能测试 |
| **数据包捕获** | tcpdump | 网络抓包分析 |
| **网络诊断** | ping, traceroute, mtr | 延迟测试、路由跟踪 |
| **ARP 工具** | arping | ARP 诊断 |
| **网络配置** | ip, ethtool, bridge, ipvsadm | 网络接口配置 |
| **连接追踪** | conntrack, netstat, lsof | 连接状态查看 |
| **进程监控** | htop, strace | 进程、系统调用跟踪 |
| **实用工具** | jq, yq, vim, bash, openssh | 数据处理、编辑器 |

## 🚀 快速使用

### Docker 运行

```bash
# 拉取镜像
docker pull ghcr.io/freemankevin/netkit:latest

# 运行容器（基础模式）
docker run -d --name netkit ghcr.io/freemankevin/netkit:latest

# 运行容器（网络诊断模式）
docker run -d --name netkit \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  ghcr.io/freemankevin/netkit:latest

# 运行容器（完整网络权限）
docker run -d --name netkit \
  --net=host \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  ghcr.io/freemankevin/netkit:latest

# 进入容器
docker exec -it netkit /bin/bash

# 执行单条命令
docker run --rm ghcr.io/freemankevin/netkit:latest curl -I https://google.com
docker run --rm ghcr.io/freemankevin/netkit:latest nmap -sn 192.168.1.0/24
```

### Docker Compose 部署

```bash
# 启动服务
docker compose up -d

# 查看状态
docker compose ps

# 进入容器
docker compose exec netkit /bin/bash

# 停止服务
docker compose down
```

### K8s 部署

```bash
# 部署应用
kubectl apply -f k8s/deployment.yaml

# 查看部署状态
kubectl get pods -l app=netkit
kubectl get svc netkit

# 进入容器调试
kubectl exec -it deploy/netkit -- /bin/bash

# 执行单条命令
kubectl exec deploy/netkit -- curl -I https://google.com
kubectl exec deploy/netkit -- ping -c 4 8.8.8.8
kubectl exec deploy/netkit -- nslookup kubernetes.default

# 删除部署
kubectl delete -f k8s/deployment.yaml
```

### 快速调试 Pod（临时）

```bash
# 创建临时调试 Pod
kubectl run netkit --rm -it --image=ghcr.io/freemankevin/netkit:latest -- /bin/bash

# 指定命名空间
kubectl run netkit --rm -it -n default --image=ghcr.io/freemankevin/netkit:latest -- /bin/bash

# 使用 host 网络
kubectl run netkit --rm -it --overrides='{"spec":{"hostNetwork":true}}' --image=ghcr.io/freemankevin/netkit:latest -- /bin/bash
```

## 🎯 常见使用场景

### 1. 网络连通性测试

```bash
# DNS 解析
dig kubernetes.default.svc.cluster.local
drill @8.8.8.8 example.com

# HTTP 连通性
curl -I https://example.com
curl -v telnet://example.com:80

# TCP 端口检测
nc -zv example.com 80 443
nc -zv mysql.default.svc.cluster.local 3306

# ICMP ping
ping -c 4 8.8.8.8

# 路由跟踪
traceroute 8.8.8.8
mtr 8.8.8.8
```

### 2. K8s 网络排查

```bash
# 查看 Service DNS 解析
dig kubernetes.default.svc.cluster.local

# 测试 Service 连通性
nc -zv kubernetes.default 443

# 查看 iptables 规则
iptables -L -n -v

# 查看连接追踪表
conntrack -L
conntrack -L -p tcp --dport 80

# 查看 IPVS 规则（如果使用 IPVS）
ipvsadm -Ln

# 查看网桥信息
brctl show
bridge link
```

### 3. 性能测试

```bash
# 启动 iperf3 服务端
iperf3 -s

# 客户端带宽测试
iperf3 -c iperf-server.example.com -t 30

# 反向测试（下载）
iperf3 -c iperf-server.example.com -t 30 -R

# 多线程测试
iperf3 -c iperf-server.example.com -P 4
```

### 4. 安全扫描

```bash
# 主机发现
nmap -sn 192.168.1.0/24

# 端口扫描
nmap -sS -sV 192.168.1.1

# 操作系统检测
nmap -O 192.168.1.1

# 全端口扫描
nmap -p- 192.168.1.1
```

### 5. 数据包捕获

```bash
# 捕获所有流量（需要 NET_ADMIN 权限）
tcpdump -i any -w capture.pcap

# 捕获特定主机流量
tcpdump -i any host 192.168.1.1

# 捕获特定端口
tcpdump -i any port 80 or port 443

# 捕获并实时显示
tcpdump -i any -nn -vv port 80
```

### 6. 进程与连接诊断

```bash
# 查看进程监听端口
netstat -tlnp
ss -tlnp

# 查看所有网络连接
netstat -anp

# 查看打开的文件
lsof -p <PID>
lsof -i :80

# 查看进程详情
htop

# 系统调用跟踪
strace -p <PID>
```

### 7. ARP 与二层诊断

```bash
# ARP 扫描
arping -c 3 192.168.1.1

# 查看 ARP 表
ip neigh show
arp -a

# 网卡信息
ethtool eth0
```

### 8. 数据处理

```bash
# JSON 处理
curl -s https://api.github.com | jq '.[] | .name'

# YAML 处理
kubectl get pod -o yaml | yq '.metadata.name'

# 文本编辑
vim config.yaml
```

## 🔐 权限要求

某些工具需要特定权限：

| 工具 | 所需权限 | 说明 |
|------|---------|------|
| tcpdump | NET_ADMIN, NET_RAW | 抓包需要 |
| nmap | NET_ADMIN, NET_RAW | 某些扫描模式 |
| ping | NET_RAW | ICMP 需要 |
| arping | NET_RAW | ARP 需要 |
| iptables | NET_ADMIN | 修改 iptables |

K8s deployment 已配置必要权限。

## 📄 许可证

[MIT License](LICENSE)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！