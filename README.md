# Network Testing Tools Container

基于 Alpine Linux 的轻量级网络测试工具镜像，专为私有化离线 K8s 容器云环境设计。

## ✨ 特性

- **体积小**: 基于 Alpine (~150MB)
- **工具丰富**: 包含常用网络测试工具
- **离线友好**: 专为私有化离线环境设计，无需互联网访问

## 🛠 内置工具

| 类别 | 工具 |
|------|------|
| HTTP 客户端 | curl, wget |
| TCP 工具 | netcat (nc), telnet |
| DNS 查询 | dig, drill |
| 端口扫描 | nmap |
| 带宽测试 | iperf3 |
| 数据包捕获 | tcpdump |
| 网络诊断 | ping, traceroute, mtr |
| 网络工具 | ethtool, ip, conntrack |
| 实用工具 | jq, yq, vim, bash, openssh |

## 🚀 快速使用

### Docker 运行

```bash
# 运行容器
docker run -d --name network-tools ghcr.io/freemankevin/network-tools:latest

# 进入运行中的容器
docker exec -it network-tools /bin/bash

# 执行单条命令
docker run --rm ghcr.io/freemankevin/network-tools:latest curl -I https://google.com
docker run --rm ghcr.io/freemankevin/network-tools:latest nmap -sn 192.168.1.0/24
docker run --rm ghcr.io/freemankevin/network-tools:latest iperf3 -c 192.168.1.1
```

### K8s 部署

```bash
# 部署应用
kubectl apply -f k8s/deployment.yaml

# 查看部署状态
kubectl get pods -l app=network-tools
kubectl get svc network-tools

# 进入容器调试
kubectl exec -it deploy/network-tools -- /bin/bash

# 执行单条命令
kubectl exec deploy/network-tools -- curl -I https://google.com
kubectl exec deploy/network-tools -- ping -c 4 8.8.8.8

# 查看日志
kubectl logs -f deploy/network-tools

# 删除部署
kubectl delete -f k8s/deployment.yaml
```

## 📦 镜像

- `ghcr.io/freemankevin/network-tools:latest` - 最新版本

## 🎯 常见使用场景

### 网络连通性测试

```bash
# DNS 解析
dig example.com

# HTTP 连通性
curl -I https://example.com

# TCP 端口检测
nc -zv example.com 80 443

# ICMP ping
ping -c 4 example.com
```

### 性能测试

```bash
# 带宽测试（服务端需运行 iperf3 -s）
iperf3 -c iperf-server.example.com -t 30

# 带宽测试（反向）
iperf3 -c iperf-server.example.com -t 30 -R
```

### 安全扫描

```bash
# 主机发现
nmap -sn 192.168.1.0/24

# 端口扫描
nmap -sV 192.168.1.1

# 操作系统检测
nmap -O 192.168.1.1
```

### 数据包捕获

```bash
# 捕获所有流量（需要 NET_ADMIN 权限）
tcpdump -i any -w capture.pcap

# 捕获特定主机流量
tcpdump -i any host 192.168.1.1
```

## 📄 许可证

MIT License
