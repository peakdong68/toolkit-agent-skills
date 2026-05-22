---
name: deployment
description: >
  在设置 CI/CD 流水线、创建部署配置、生成部署检查清单或配置基础设施时使用。触发条件：新项目需要部署、迁移 CI/CD 提供商、添加预发布/生产环境、自动化发布流程、为部署设置监控。
---

# 部署

## 概述

设置 CI/CD 流水线和部署配置，自动化从代码到生产的路径。此技能可检测部署目标、生成流水线配置、创建部署前/后检查清单，并配置监控——产出完全自动化、支持回滚的部署流水线。

**开始时声明：** "我正在使用部署技能来设置部署流水线。"

## 阶段 1：检测部署目标

**此阶段后暂停——向用户展示发现结果并确认后再继续。**

通过提问识别完整的部署上下文：

**平台检测：**

- 部署到哪里？（Vercel、AWS、GCP、Azure、DigitalOcean、自托管）
- 基于容器？（Docker、Kubernetes）
- 无服务器？（Lambda、Cloud Functions、Edge Functions）

**CI/CD 检测：**

- 使用什么 CI 系统？（GitHub Actions、GitLab CI、CircleCI、Jenkins）
- 什么触发部署？（推送到 main 分支、标签、手动触发）
- 多环境？（开发、预发布、生产）

**基础设施检测：**

- 是否需要数据库迁移？
- 环境变量管理？（密钥管理器、.env 文件）
- CDN/缓存？资源流水线？
- 监控/告警？（Datadog、Sentry、New Relic）

### 平台选择决策表

| 项目类型                | 推荐平台                          | CI/CD                    | 原因                   |
| ----------------------- | --------------------------------- | ------------------------ | ---------------------- |
| 静态站点 / SPA          | Vercel、Netlify、Cloudflare Pages | 内置                     | 零配置，边缘 CDN       |
| Node.js API             | AWS ECS、Cloud Run、Railway       | GitHub Actions           | 容器支持，自动扩缩容   |
| 单体仓库（前端 + 后端） | Vercel + AWS / Railway            | GitHub Actions           | 关注点分离，独立扩缩容 |
| 企业级 / 合规要求高     | AWS EKS、GKE                      | GitLab CI、Jenkins       | 完全控制，审计追踪     |
| 业余 / 侧边项目         | Railway、Fly.io、Render           | 内置或 GitHub Actions    | 简单，低成本           |
| ML / 数据流水线         | AWS SageMaker、GCP Vertex         | GitHub Actions + Airflow | GPU 支持，流水线编排   |

## 阶段 2：设计流水线

**此阶段后暂停——向用户展示流水线设计并获批准后再生成配置。**

### 标准流水线阶段

```
┌─────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  构建    │──▶│   测试   │──▶│  代码检查/│──▶│  部署    │──▶│  验证    │
│          │   │          │   │  校验    │   │          │   │          │
└─────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
```

**构建：** 安装依赖、编译、打包
**测试：** 单元测试、集成测试、覆盖率检查
**代码检查/校验：** 代码规范检查、类型检查、安全审计
**部署：** 推送到目标环境
**验证：** 健康检查、冒烟测试、监控

### 分支策略决策表

| 分支               | 操作                          | 环境         | 门禁         |
| ------------------ | ----------------------------- | ------------ | ------------ |
| `feature/*`        | 构建 + 测试 + 代码检查        | 无           | PR 检查通过  |
| `main`             | 构建 + 测试 + 代码检查 + 部署 | 预发布       | 所有检查通过 |
| `release/*` 或标签 | 构建 + 测试 + 代码检查 + 部署 | 生产         | 手动审批     |
| `hotfix/*`         | 构建 + 测试 + 部署            | 生产（加急） | 高级成员审批 |

### 部署策略决策表

| 策略       | 适用场景                     | 风险等级 | 回滚速度         |
| ---------- | ---------------------------- | -------- | ---------------- |
| 直接部署   | 个人/业余项目、预发布环境    | 高       | 慢（重新部署）   |
| 蓝绿部署   | 有健康检查的应用、低停机需求 | 低       | 即时（切换）     |
| 金丝雀发布 | 高流量生产环境、渐进式发布   | 非常低   | 快（重定向流量） |
| 滚动更新   | Kubernetes 集群、无状态服务  | 低       | 中等             |
| 功能开关   | 部署与发布解耦               | 非常低   | 即时（切换开关） |

## 阶段 3：生成配置

### GitHub Actions 示例

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
      - run: npm test -- --coverage
      - run: npm run build

  deploy-staging:
    needs: build-and-test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      # [平台特定的部署步骤]

  deploy-production:
    needs: build-and-test
    if: startsWith(github.ref, 'refs/tags/v')
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      # [平台特定的部署步骤]
```

### GitLab CI 示例

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - npm ci
    - npm run build
  artifacts:
    paths: [dist/]

test:
  stage: test
  script:
    - npm run lint
    - npm run type-check
    - npm test -- --coverage

deploy-staging:
  stage: deploy
  environment: staging
  script:
    -  # 平台特定的部署
  only:
    - main

deploy-production:
  stage: deploy
  environment: production
  script:
    -  # 平台特定的部署
  when: manual
  only:
    - tags
```

## 阶段 4：创建部署检查清单

**暂停——向用户展示检查清单。根据其技术栈进行定制。**

### 部署前检查清单

```markdown
## 部署前检查清单

- [ ] CI 上所有测试通过
- [ ] 代码已评审并批准
- [ ] 无严重/高危安全漏洞
- [ ] 目标环境变量已配置
- [ ] 数据库迁移已测试（如适用）
- [ ] 功能开关已配置（如适用）
- [ ] 回滚方案已文档化
- [ ] 监控/告警已配置
- [ ] 更新日志已更新
- [ ] 版本号已升级
```

### 部署后验证

```markdown
## 部署后验证

- [ ] 健康检查端点返回 200
- [ ] 冒烟测试通过
- [ ] 错误率在正常范围内
- [ ] 响应时间在 SLA 范围内
- [ ] 数据库迁移成功应用
- [ ] 功能开关按预期激活/禁用
- [ ] 监控仪表板显示预期指标
- [ ] 错误追踪中无新增错误（Sentry 等）
```

## 阶段 5：审查与定稿

向用户展示完整的流水线配置：

1. 验证 CI/CD 配置文件语法有效
2. 验证所有环境变量已文档化
3. 验证存在回滚方案
4. 验证部署前/后检查清单完整
5. 验证流水线可本地测试（act 等工具）

将配置保存到 `.github/workflows/` 或等效目录。

## 反模式 / 常见错误

| 反模式                         | 为何错误               | 正确做法                  |
| ------------------------------ | ---------------------- | ------------------------- |
| 手动生产环境部署               | 易出错，无审计追踪     | 通过 CI/CD 流水线自动化   |
| 无回滚方案                     | 部署失败时生产环境卡住 | 每次部署前定义回滚方案    |
| 跳过预发布环境                 | 在生产环境发现缺陷     | 始终先部署到预发布环境    |
| 代码/配置文件中硬编码密钥      | 安全风险               | 使用密钥管理器或环境变量  |
| 生产环境使用 `latest` 标签镜像 | 部署不可复现           | 固定具体版本标签          |
| 无并发控制                     | 部署冲突               | 在 CI 中添加并发组        |
| 无健康检查即部署               | 无法感知部署健康状态   | 添加健康端点 + 部署后检查 |
| 监控告警噪音过大导致疲劳       | 真正问题被忽略         | 基于症状告警，调整阈值    |

## 核心原则

- **自动化一切**——关键路径中无手动步骤
- **快速反馈**——尽早失败，快速失败
- **环境一致性**——预发布环境与生产环境匹配
- **随时可回滚**——每次部署都有回滚方案
- **可观测**——部署前、中、后均有监控
- **安全**——代码中无密钥，使用密钥管理
- **幂等**——重复部署同一版本产生相同结果

## 反自我合理化防护

- 切勿跳过预发布环境直接部署到生产环境——始终先在 staging 环境验证。
- 切勿在未制定回滚计划的情况下部署——每次部署都必须可逆。
- 切勿在配置文件中硬编码密钥——使用环境变量或密钥管理服务。
- 切勿跳过部署后的健康检查——等待服务稳定后再确认成功。
- 切勿在生产环境中使用 `latest` 标签——始终使用明确的版本号。

## 集成点

| 技能                             | 集成方式                                     |
| -------------------------------- | -------------------------------------------- |
| `senior-devops`                  | 提供部署配置中使用的 Docker、K8s 和 IaC 模式 |
| `git-commit-helper`              | 约定式提交驱动更新日志和版本升级             |
| `finishing-a-development-branch` | 分支完成触发部署流水线                       |
| `verification-before-completion` | 部署后验证门禁                               |
| `security-review`                | 流水线中的安全扫描阶段                       |
| `planning`                       | 部署计划是实施计划的一部分                   |

## 技能类型

**灵活**——根据项目的云提供商、团队规模和运维成熟度，适配流水线设计、平台选择和工具链。原则（自动化、回滚、可观测性）保持不变；具体工具可互换。
