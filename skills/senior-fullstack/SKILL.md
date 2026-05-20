---
name: senior-fullstack
description: "当用户需要进行端到端的 TypeScript 开发时使用——涵盖从数据库模式到 API 层再到 UI 的全流程，涉及 tRPC、Prisma、Next.js、身份验证和部署。触发条件：全栈功能实现、从数据库到 UI 的流水线、tRPC 路由创建、Prisma 模式设计、身份验证设置、部署配置。"
---

# 高级全栈工程师

## 概述

提供完整的、端到端的 TypeScript 应用程序，涵盖数据库设计、API 层、前端 UI、身份验证和部署。本技能专注于现代 TypeScript 全栈技术栈：Next.js App Router、用于类型安全 API 的 tRPC、用于数据库访问的 Prisma，以及带有监控的生产环境部署。

**开始声明：**“我正在使用 senior-fullstack 技能进行端到端 TypeScript 开发。”

---

## 第一阶段：数据层

**目标：**设计数据库模式和数据访问模式。

### 操作

1. 使用 Prisma 设计数据库模式
2. 定义关系和索引
3. 创建开发用种子数据
4. 设置迁移工作流
5. 为数据访问实现仓储（Repository）模式

### Prisma 模式示例

```prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String
  role      Role     @default(USER)
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([email])
  @@index([createdAt])
}

model Post {
  id        String   @id @default(cuid())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id], onDelete: Cascade)
  authorId  String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([authorId])
  @@index([published, createdAt])
}
```

### 索引策略决策表

| 查询模式 | 索引类型 | 示例 |
|--------------|-----------|---------|
| 通过唯一字段查找 | 唯一索引 | `@@unique([email])` |
| 通过外键过滤 | 标准索引 | `@@index([authorId])` |
| 过滤 + 排序组合 | 复合索引 | `@@index([published, createdAt])` |
| 全文搜索 | 全文索引 | 依赖具体数据库 |
| 空间/地理查询 | 空间索引 | 依赖具体数据库 |

### 停止 — 在满足以下条件前，切勿进入第二阶段：
- [ ] 模式已定义所有关系
- [ ] 索引覆盖所有查询模式
- [ ] 已存在种子数据脚本
- [ ] 已生成并测试迁移

---

## 第二阶段：API 层

**目标：**使用 tRPC 和 Zod 验证构建类型安全的 API。

### 操作

1. 定义 tRPC 路由和过程（procedures）
2. 使用 Zod 实现输入验证
3. 添加身份验证中间件
4. 在服务层构建业务逻辑
5. 添加错误处理和日志记录

### tRPC 路由示例

```typescript
export const userRouter = router({
  list: protectedProcedure
    .input(z.object({
      page: z.number().min(1).default(1),
      pageSize: z.number().min(1).max(100).default(20),
      search: z.string().optional(),
    }))
    .query(async ({ ctx, input }) => {
      const { page, pageSize, search } = input;
      const where = search ? { name: { contains: search, mode: 'insensitive' } } : {};
      const [users, total] = await Promise.all([
        ctx.db.user.findMany({
          where, skip: (page - 1) * pageSize, take: pageSize, orderBy: { createdAt: 'desc' },
        }),
        ctx.db.user.count({ where }),
      ]);
      return { users, total, totalPages: Math.ceil(total / pageSize) };
    }),

  create: protectedProcedure
    .input(createUserSchema)
    .mutation(async ({ ctx, input }) => {
      return ctx.db.user.create({ data: input });
    }),
});
```

### 授权模式决策表

| 模式 | 适用场景 | 示例 |
|---------|----------|---------|
| 基于角色（RBAC） | 简单的权限模型 | 管理员 vs 普通用户 |
| 资源级权限 | 仅限所有者访问 | 用户只能编辑自己的帖子 |
| 基于属性（ABAC） | 复杂规则 | 组织成员资格 + 角色 + 资源状态 |
| 功能开关（Feature flags） | 渐进式发布 | 高级功能 |

### 停止 — 在满足以下条件前，切勿进入第三阶段：
- [ ] 所有 tRPC 路由均配备 Zod 验证
- [ ] 身份验证中间件已保护相应路由
- [ ] 业务逻辑位于服务层（而非路由中）
- [ ] 错误处理返回结构化错误

---

## 第三阶段：UI 层

**目标：**默认使用服务端组件构建页面，交互部分使用客户端组件。

### 操作

1. 默认使用服务端组件构建页面
2. 为交互功能添加客户端组件
3. 通过 tRPC hooks 连接 API
4. 实现乐观更新
5. 添加加载和错误状态

### 组件类型决策表

| 需求 | 组件类型 | 数据源 |
|------|---------------|-------------|
| 静态内容、数据展示 | 服务端组件 | 直接调用 DB/API |
| 交互式表单 | 客户端组件 | tRPC mutation hook |
| 实时更新 | 客户端组件 | tRPC 订阅或轮询 |
| 搜索/过滤 | 客户端组件 | 带防抖的 tRPC query |
| 导航外壳/布局 | 服务端组件 | 会话数据 |

### 停止 — 在满足以下条件前，切勿进入第四阶段：
- [ ] 页面默认使用服务端组件
- [ ] 客户端组件数量最少且有充分理由
- [ ] 所有数据获取路径均具备加载和错误状态
- [ ] 突变（mutations）的乐观更新正常工作

---

## 第四阶段：生产环境

**目标：**为部署做好准备，包含身份验证、监控和 CI/CD。

### 操作

1. 设置身份验证（NextAuth.js / Clerk / Lucia）
2. 配置部署环境（Vercel / Docker）
3. 添加监控和错误追踪
4. 实现 CI/CD 流水线
5. 性能审计

### 身份验证方案决策表

| 方案 | 适用场景 | SSR 支持 | 可自托管 |
|----------|----------|-------------|-------------|
| NextAuth.js (Auth.js) | OAuth 提供商、JWT/会话 | 是 | 是 |
| Clerk | 快速上手、托管服务 | 是 | 否 |
| Lucia | 定制化、轻量级 | 是 | 是 |
| Supabase Auth | Supabase 生态系统 | 是 | 部分支持 |

### 监控清单

- [ ] 错误追踪（Sentry）包含 source maps
- [ ] 性能监控（Vercel Analytics 或自定义方案）
- [ ] 数据库查询性能（Prisma 指标）
- [ ] API 端点延迟和错误率
- [ ] 可用性监控（外部 Ping）
- [ ] 日志聚合与结构化日志
- [ ] 错误率突增告警

### Docker 部署

```dockerfile
FROM node:20-alpine AS base
RUN corepack enable

FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN pnpm prisma generate
RUN pnpm build

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["node", "server.js"]
```

### 停止 — 满足以下条件即表示生产就绪：
- [ ] 身份验证已配置并测试
- [ ] 部署流水线正常工作（预览 + 生产）
- [ ] 监控和告警已启用
- [ ] 已完成性能审计

---

## 全栈类型安全流水线

```
Prisma 模式 -> Prisma Client (类型) -> tRPC 路由 -> tRPC Hooks -> React 组件
     |                  |                     |              |              |
  数据库迁移        类型安全的数据库          经 Zod 验证的     自动类型推导    渲染的 UI
                   查询请求                API            查询请求
```

---

## 项目结构

```
prisma/
  schema.prisma
  migrations/
  seed.ts
src/
  app/                    # Next.js App Router
    (auth)/               # 身份验证路由组
    (dashboard)/          # 受保护路由组
    api/trpc/[trpc]/      # tRPC 处理器
  server/
    db.ts                 # Prisma 客户端单例
    trpc.ts               # tRPC 初始化
    routers/              # tRPC 路由
    services/             # 业务逻辑
  components/
    ui/                   # 设计系统原子组件
    features/             # 功能组件
  hooks/                  # 自定义 React Hooks
  lib/
    trpc.ts               # tRPC 客户端
    auth.ts               # 身份验证配置
    validators.ts         # Zod 校验器
tests/
  unit/
  integration/
  e2e/
```

---

## 反模式 / 常见错误

| 反模式 | 为何错误 | 正确做法 |
|-------------|----------------|-----------------|
| 在组件中写原生 SQL | 绕过类型安全和安全性 | 通过 tRPC 使用 Prisma |
| 服务端组件能胜任时仍使用客户端请求 | 引入不必要的 JS，速度更慢 | 静态数据使用服务端组件 |
| 将 Prisma 客户端共享给前端 | 安全漏洞，暴露数据库 | Prisma 仅限服务端代码使用 |
| 外键缺少索引 | 连接和查找缓慢 | 为每个外键建立索引 |
| 将 Token 存储在 localStorage | XSS 漏洞 | 使用 HttpOnly Cookie |
| 跳过 Zod 验证 | 运行时类型错误 | 在 API 边界验证所有输入 |
| 单体式 tRPC 路由 | 难以维护，易引发合并冲突 | 按领域拆分（用户、帖子等） |
| 在 tRPC 过程中编写业务逻辑 | 难以测试，不可复用 | 提取至服务层 |

---

## 文档查阅（Context7）

使用 `mcp__context7__resolve-library-id`，然后使用 `mcp__context7__query-docs` 获取最新文档。返回的文档将覆盖记忆中的知识。
- `react` — 用于组件模式、Hooks 或 React 19+ 特性
- `next.js` — 用于 App Router、API 路由或服务端组件
- `prisma` — 用于模式设计、客户端查询或迁移
- `tailwindcss` — 用于原子化 CSS 模式或配置

---

## 集成点

| 技能 | 关系 |
|-------|-------------|
| `senior-frontend` | UI 层遵循前端模式 |
| `senior-backend` | API 层遵循后端模式 |
| `senior-architect` | 架构决策指导服务边界 |
| `security-review` | 身份验证实现遵循安全模式 |
| `testing-strategy` | 全栈测试使用策略框架 |
| `code-review` | 代码审查覆盖全栈各层 |
| `performance-optimization` | 优化策略应用于所有层级 |

---

## 核心原则

- 从数据库到浏览器仅使用单一语言（TypeScript）
- 全栈类型安全（无运行时类型不匹配）
- 默认使用服务端组件，仅在必要时使用客户端组件
- 在 API 边界使用 Zod 验证所有输入
- 为每种查询模式配置数据库索引
- 基于环境的配置（禁止硬编码值）

---

## 技能类型

**灵活（FLEXIBLE）** — 根据项目上下文调整技术选型。强烈建议遵循四阶段流程。全栈类型安全是不可妥协的底线。所有 API 输入必须使用 Zod 进行验证。数据库模式变更必须使用迁移。