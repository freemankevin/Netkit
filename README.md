# Network Testing Tools Container

基于 Alpine Linux 的轻量级网络测试工具镜像，专为私有化离线 K8s 容器云环境设计。

## ✨ 特性

- **体积小**: 基于 Alpine (~150MB)
- **工具丰富**: 包含常用网络测试工具
- **安全**: 非 root 用户运行
- **离线友好**: 专为私有化离线环境设计，无需互联网访问

## 🛠 内置工具

| 类别 | 工具 |
|------|------|
| HTTP 客户端 | curl, wget |
| TCP 工具 | netcat (nc) |
| DNS 查询 | dig, drill |
| 端口扫描 | nmap |
| 带宽测试 | iperf3 |
| 数据包捕获 | tcpdump |
| 网络诊断 | ping, traceroute, mtr |
| 网络工具 | ethtool, ip, conntrack |
| 实用工具 | jq, yq, vim, bash, openssh |

## 🚀 快速使用

### 1. Docker 本地测试

```bash
# 构建镜像
docker build -t network-tools:latest .

# 运行容器
docker run -it --rm network-tools:latest

# 在容器内执行命令
docker run --rm network-tools:latest curl -I https://google.com
docker run --rm network-tools:latest nmap -sn 192.168.1.0/24
docker run --rm network-tools:latest iperf3 -c 192.168.1.1
```

### 2. K8s 部署

```bash
# 应用部署配置
kubectl apply -f k8s/deployment.yaml

# 进入容器调试
kubectl exec -it deploy/network-tools -- /bin/bash
```

### 3. Helm 部署

```bash
# 离线环境部署
helm install network-tools ./helm/network-tools \
  --set image.repository=your-registry/network-tools \
  --set image.tag=latest
```

## 📦 镜像版本

- `your-registry/network-tools:latest` - 最新版本
- `your-registry/network-tools:v1.0.0` - 语义版本

**注意**: 请将 `your-registry` 替换为你的私有镜像仓库地址。

## 🏗 CI/CD 流程

```
GitHub Push → GitHub Actions 构建 → 推送到 GitHub Container Registry → K8s 拉取运行
                  ↓
            安全扫描 (Trivy)
```

**注意**: GitHub Actions 会自动为镜像打上 `latest` 标签。

## 🔒 安全特性

- 非 root 用户 (networker)
- 只读根文件系统（可选）
- 最小权限原则

## 📝 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| TARGET_HOST | 测试目标主机 | internal-api.example.com |

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

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！
