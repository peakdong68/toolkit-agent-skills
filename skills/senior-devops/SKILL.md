---
name: senior-devops
description: >
  当用户需要 CI/CD 流水线、Docker 配置、Kubernetes 部署、
  基础设施即代码、监控或零停机部署策略时使用。触发词：用户提到
  "devops"、"docker"、"kubernetes"、"CI/CD"、"infrastructure"、"monitoring"、"deploy to production"、
  "container"、"terraform"、"observability"。
---

# 高级 DevOps 工程师

## 概述

设计、构建并维护生产环境基础设施与部署流水线。本技能涵盖 Docker 容器化、Kubernetes 编排、基于 GitHub Actions 的 CI/CD、使用 Terraform/Pulumi 的基础设施即代码、Prometheus/Grafana 监控、告警策略、零停机部署以及回滚流程。

## 阶段一：基础设施设计

1. 定义部署拓扑（单服务器、集群、多区域）
2. 选择容器化策略（Docker、Buildpacks）
3. 选择编排平台（Kubernetes、ECS、Cloud Run）
4. 规划网络（负载均衡器、DNS、TLS）
5. 设计密钥管理方案

**停止 — 在实施前向用户展示基础设施设计方案以获得批准。**

### 基础设施决策表

| 规模 | 拓扑 | 编排 | 推荐方案 |
|---|---|---|---|
| 个人项目 / MVP | 单服务器 | Docker Compose | Railway, Fly.io |
| 初创公司 (< 10 万用户) | 小型集群 | ECS, Cloud Run | AWS ECS, GCP Cloud Run |
| 成长期 (10 万 - 100 万用户) | 多可用区集群 | Kubernetes | EKS, GKE |
| 企业级 (100 万+ 用户) | 多区域 | Kubernetes + 服务网格 | EKS/GKE + Istio |
| 合规要求高 | 专有/私有云 | Kubernetes | 自托管 K8s |

## 阶段二：流水线实现

1. 构建 CI 流水线（代码检查、测试、构建、安全扫描）
2. 构建 CD 流水线（部署到预发布、生产环境）
3. 配置环境特定设置
4. 设置制品仓库（容器镜像、软件包）
5. 实施部署策略（蓝绿部署、金丝雀发布、滚动更新）

**停止 — 验证流水线配置语法并提交审查。**

## 阶段三：可观测性

1. 部署监控栈（Prometheus、Grafana）
2. 配置告警规则与升级流程
3. 设置日志聚合
4. 实现分布式追踪
5. 为常见事件创建操作手册

**停止 — 在宣告完成前，验证监控是否覆盖所有关键服务。**

## Dockerfile 最佳实践

```dockerfile
# 1. 使用具体版本标签（而非 :latest）
FROM node:20-alpine AS base

# 2. 设置工作目录
WORKDIR /app

# 3. 在独立层安装依赖（缓存优化）
FROM base AS deps
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile --prod

FROM base AS build-deps
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile

# 4. 在独立阶段构建
FROM build-deps AS builder
COPY . .
RUN pnpm build

# 5. 生产镜像 — 最小化体积
FROM base AS runner
ENV NODE_ENV=production

# 6. 不以 root 用户运行
RUN addgroup --system --gid 1001 app && \
    adduser --system --uid 1001 app
USER app

# 7. 仅复制所需内容
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# 8. 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -qO- http://localhost:3000/health || exit 1

# 9. 暴露端口并设置入口点
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### 关键 Dockerfile 规则

| 规则 | 原因 |
|---|---|
| 多阶段构建 | 最小化镜像体积 |
| `.dockerignore` 文件 | 排除 node_modules、.git、测试文件 |
| 非 root 用户 | 安全加固 |
| 指定基础镜像版本 | 构建可复现 |
| 层顺序（依赖在前，源码在后） | 缓存效率 |
| HEALTHCHECK 指令 | 容器健康监控 |
| 构建参数/层中不包含密钥 | 防止凭据泄露 |

## Docker Compose 模式

```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: runner
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/app
      - REDIS_URL=redis://cache:6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:3000/health"]
      interval: 10s
      timeout: 5s
      retries: 3

  db:
    image: postgres:16-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5

  cache:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

## GitHub Actions 工作流

```yaml
name: CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint
      - run: pnpm typecheck
      - run: pnpm test -- --coverage

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npx audit-ci --moderate
      - uses: aquasecurity/trivy-action@master
        with:
          scan-type: fs
          severity: HIGH,CRITICAL

  build-and-push:
    needs: [lint-and-test, security-scan]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy to production
        run: echo "Deploying ${{ github.sha }}"
```

## Terraform / Pulumi 模式

### Terraform 结构

```
modules/
  vpc/
    main.tf, variables.tf, outputs.tf
  ecs/
    main.tf, variables.tf, outputs.tf
environments/
  staging/
    main.tf, terraform.tfvars
  production/
    main.tf, terraform.tfvars
```

### 关键 IaC 规则

| 规则 | 原因 |
|---|---|
| 远程状态后端（S3 + DynamoDB） | 共享状态、锁定机制 |
| 状态锁定 | 防止并发修改 |
| 环境特定变量文件 | 关注点分离 |
| 模块版本控制 | 可复现的共享基础设施 |
| CI 中执行 `terraform plan` | 应用前发现问题 |
| 定期漂移检测 | 检测手动变更 |
| 为所有资源打标签 | 归属权、成本分配 |

## 监控（Prometheus + Grafana）

### USE 方法（资源维度）

| 资源 | 利用率 | 饱和度 | 错误 |
|---|---|---|---|
| CPU | cpu_usage_percent | cpu_throttled | — |
| 内存 | memory_usage_bytes | oom_kills | — |
| 磁盘 | disk_usage_percent | io_wait | disk_errors |
| 网络 | bytes_total | queue_length | errors_total |

### RED 方法（服务维度）

- **速率（Rate）**：每秒请求数
- **错误（Errors）**：每秒错误率
- **持续时间（Duration）**：延迟分布（p50、p95、p99）

### 告警规则

```yaml
groups:
  - name: app-alerts
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
```

### 告警最佳实践

| 实践 | 原因 |
|---|---|
| 基于症状告警，而非原因 | 减少噪音，聚焦影响 |
| 每条告警附带操作手册链接 | 支持快速响应 |
| 分级严重程度 | critical=电话通知，warning=工单，info=日志 |
| 告警前聚合 | 避免抖动 |
| 每季度审查并精简 | 防止告警疲劳 |

## 零停机部署策略

| 策略 | 工作原理 | 风险 | 回滚速度 |
|---|---|---|---|
| 滚动更新 | 逐个替换实例 | 低 | 中等 |
| 蓝绿部署 | 在两个环境间切换流量 | 低 | 即时 |
| 金丝雀发布 | 将小部分流量路由至新版本，逐步增加 | 非常低 | 即时 |
| 功能开关 | 部署代码但默认关闭，通过开关启用 | 非常低 | 即时 |

### 回滚流程

1. **自动化**：健康检查失败 -> 自动回滚
2. **手动**：`kubectl rollout undo deployment/app`
3. **数据库**：仅向前迁移，保持向后兼容
4. **配置**：通过密钥管理器版本回退

### 数据库迁移安全

| 规则 | 理由 |
|---|---|
| 迁移必须向后兼容 | 旧代码 + 新架构必须能协同工作 |
| 同一部署中永不重命名/删除列 | 需要两阶段变更 |
| 两阶段：添加列 -> 部署 -> 移除旧列 | 零停机架构演进 |
| 始终测试每个迁移的回滚 | 确保可逆性 |

## 反模式 / 常见错误

| 反模式 | 为何错误 | 正确做法 |
|---|---|---|
| 手动生产环境部署 | 无审计轨迹，易出错 | 通过 CI/CD 自动化 |
| 共享或硬编码密钥 | 安全风险 | 使用密钥管理器 |
| 部署前无回滚计划 | 部署失败时陷入困境 | 每次部署前文档化回滚方案 |
| 生产环境使用 `latest` 标签镜像 | 不可复现 | 固定具体版本标签 |
| 以 root 用户运行容器 | 安全漏洞 | Dockerfile 中使用非 root 用户 |
| 因不可操作告警导致告警疲劳 | 真实问题被忽略 | 基于症状告警，调优阈值 |
| 跳过预发布环境 | 在生产环境发现缺陷 | 始终先部署到预发布环境 |
| 手动配置的独特服务器（"雪花服务器"） | 无法复现，无法扩展 | 基础设施即代码 |
| 有监控无告警 | 无人发现问题 | 将告警接入监控系统 |

## 核心原则

- 基础设施即代码 — 生产环境无手动变更
- 不可变基础设施 — 替换而非修补
- 牛群而非宠物 — 服务器可随意丢弃
- 安全左移 — 在流水线早期进行扫描
- 最小权限 — 处处使用最小权限
- 自动化所有运行超过两次的操作
- 定期测试灾难恢复计划

## 文档查阅（Context7）

使用 `mcp__context7__resolve-library-id` 然后 `mcp__context7__query-docs` 获取最新文档。返回的文档将覆盖记忆中的知识。
- `docker` — 用于 Dockerfile 语法、compose 配置或多阶段构建
- `kubernetes` — 用于资源清单、kubectl 命令或 Helm charts
- `terraform` — 用于提供程序配置、资源块或状态管理

---

## 集成点

| 技能 | 集成方式 |
|---|---|
| `deployment` | 提供更高阶的部署流水线编排 |
| `security-review` | CI 流水线中的安全扫描阶段 |
| `planning` | 基础设施变更像功能一样进行规划 |
| `verification-before-completion` | 部署后验证关卡 |
| `finishing-a-development-branch` | 合并触发部署流水线 |
| `mcp-builder` | MCP 服务器需要容器化与部署 |

## 技能类型

**灵活（FLEXIBLE）** — 根据项目的云提供商、团队规模与运维成熟度调整工具与模式。核心原则（基础设施即代码、不可变性、可观测性）保持不变；具体工具可互换。