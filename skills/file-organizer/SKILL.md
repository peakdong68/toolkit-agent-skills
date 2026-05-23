---
name: file-organizer
description: >
  当用户需要项目结构组织时使用——单体仓库模式、基于功能的架构、命名规范、桶式导出（barrel exports）或配置文件放置。
  触发条件：重构项目目录、设置单体仓库、定义命名规范、创建桶式导出、组织配置文件、规划从扁平结构到基于功能结构的迁移、建立导入排序规则。
---

# 文件组织器

## 概述

设计并维护能够随团队和代码库增长而扩展的良好项目结构。本技能涵盖单体仓库模式、基于功能与基于层的架构、命名规范、索引/桶式文件、配置文件放置以及文档结构。

每当需要建立、审查或重构项目的文件组织以提升清晰度和可扩展性时，请应用此技能。

## 多阶段流程

### 第一阶段：评估

1. 审查当前项目结构并识别痛点
2. 衡量项目规模（文件数量、团队规模、功能数量）
3. 识别现有的命名规范和导入模式
4. 归类配置文件位置
5. 检查循环依赖或深层嵌套

> **停止 — 在不理解当前状态及其痛点的情况下，切勿提出新结构。**

### 第二阶段：策略选择

1. 使用下方决策表选择组织策略
2. 定义命名规范和文件放置规则
3. 规划桶式导出边界
4. 建立配置文件放置规则
5. 文档化导入排序约定

> **停止 — 在未文档化目标结构并获得团队共识之前，切勿开始迁移。**

### 第三阶段：迁移规划

1. 为现有项目规划迁移路径（增量式，而非一次性大爆炸）
2. 识别需要移动的文件及其新位置
3. 映射所需的导入变更
4. 尽可能创建自动化代码转换脚本（codemods）
5. 定义迁移出现问题时的回滚计划

> **停止 — 在未验证每个增量步骤测试通过之前，切勿执行迁移。**

### 第四阶段：执行与验证

1. 一次移动一个功能或模块
2. 使用自动化工具更新导入
3. 每次移动后验证测试通过
4. 完整迁移后移除旧结构
5. 为团队参考文档化规范

## 架构策略决策表

| 项目规模         | 团队规模     | 推荐方案            | 原因                     |
| ---------------- | ------------ | ------------------- | ------------------------ |
| < 20 个文件      | 1-2 名开发者 | 基于层              | 简单，低开销             |
| 20-100 个文件    | 2-5 名开发者 | 混合模式            | 简单性与可扩展性的平衡   |
| 100+ 个文件      | 5+ 名开发者  | 基于功能            | 自包含模块减少冲突       |
| 多个应用共享代码 | 任意         | 单体仓库            | 具有清晰边界的共享包     |
| 快速原型 / MVP   | 1-3 名开发者 | 基于层              | 速度优先于结构，后期重构 |
| 企业级，多团队   | 10+ 名开发者 | 基于功能 + 单体仓库 | 每个功能模块的团队所有权 |

## 架构模式

### 基于功能（领域驱动）

按业务领域组织。每个功能自包含。

```
src/
  features/
    auth/
      components/
        LoginForm.tsx
        SignupForm.tsx
      hooks/
        useAuth.ts
      api/
        auth.api.ts
      types/
        auth.types.ts
      utils/
        auth.utils.ts
      __tests__/
        auth.test.ts
      index.ts          # 公共 API（桶式导出）
    dashboard/
      components/
      hooks/
      api/
      types/
      index.ts
    billing/
      ...
  shared/               # 跨功能共享代码
    components/
      Button.tsx
      Modal.tsx
    hooks/
      useDebounce.ts
    utils/
      format.ts
    types/
      common.types.ts
```

**最适合**：5 人以上团队、中大型应用、清晰的领域边界。

### 基于层（技术导向）

按技术关注点组织。

```
src/
  components/
    Button.tsx
    Modal.tsx
    LoginForm.tsx
    DashboardCard.tsx
  hooks/
    useAuth.ts
    useDebounce.ts
  services/
    auth.service.ts
    billing.service.ts
  utils/
    format.ts
    validation.ts
  types/
    auth.types.ts
    billing.types.ts
  pages/
    Home.tsx
    Dashboard.tsx
```

**最适合**：小型团队（1-3 人）、简单应用、快速原型开发。

### 混合模式（推荐默认）

结合两者：共享层 + 功能模块。

```
src/
  app/                  # 应用级关注点
    layout.tsx
    providers.tsx
    routes.tsx
  features/             # 功能模块
    auth/
    dashboard/
    billing/
  components/           # 共享 UI 组件
    ui/                 # 设计系统原子组件
    layout/             # 布局组件
  hooks/                # 共享 Hooks
  lib/                  # 共享工具函数
  types/                # 共享类型
  config/               # 应用配置
  styles/               # 全局样式
```

## 单体仓库模式

### Turborepo / pnpm Workspaces

```
root/
  apps/
    web/                # Next.js Web 应用
      package.json
    api/                # API 服务器
      package.json
    mobile/             # React Native 应用
      package.json
  packages/
    ui/                 # 共享组件库
      package.json
    config/             # 共享配置（ESLint、TypeScript）
      eslint/
      typescript/
      package.json
    utils/              # 共享工具函数
      package.json
    types/              # 共享类型定义
      package.json
  package.json          # 根工作区配置
  turbo.json            # Turborepo 流水线配置
  pnpm-workspace.yaml
```

### 包边界

- 应用依赖包，永不依赖其他应用
- 包可以依赖其他包
- 无循环依赖
- 每个包具有清晰、单一的职责
- 共享包通过 `index.ts` 桶式导出

### 配置共享

```json
// packages/config/typescript/base.json
{
  "compilerOptions": {
    "strict": true,
    "moduleResolution": "bundler",
    "target": "ES2022"
  }
}

// apps/web/tsconfig.json
{
  "extends": "@repo/config/typescript/nextjs",
  "include": ["src"]
}
```

## 命名规范

### 文件与目录

| 类型     | 规范                               | 示例                     |
| -------- | ---------------------------------- | ------------------------ |
| 组件     | PascalCase                         | `UserProfile.tsx`        |
| Hooks    | camelCase 带 `use` 前缀            | `useAuth.ts`             |
| 工具函数 | camelCase                          | `formatDate.ts`          |
| 类型     | camelCase 带 `.types` 后缀         | `auth.types.ts`          |
| 测试     | 同名带 `.test` 后缀                | `UserProfile.test.tsx`   |
| 样式     | 同名带 `.module.css` 后缀          | `UserProfile.module.css` |
| 常量     | camelCase 或文件内使用 UPPER_SNAKE | `config.ts`              |
| API/服务 | camelCase 带 `.api` 或 `.service`  | `auth.api.ts`            |
| 目录     | kebab-case                         | `user-profile/`          |

### 组件文件命名

```
# 单文件组件
Button.tsx

# 组件与共置文件
Button/
  Button.tsx
  Button.test.tsx
  Button.stories.tsx
  Button.module.css
  index.ts            # 重新导出 Button
```

### 导入排序约定

```typescript
// 1. 外部包
import React from 'react';
import { useQuery } from '@tanstack/react-query';

// 2. 内部包（单体仓库）
import { Button } from '@repo/ui';

// 3. 功能级导入
import { useAuth } from '@/features/auth';

// 4. 相对导入（同一功能内）
import { LoginForm } from './LoginForm';
import { authSchema } from './auth.types';

// 5. 样式
import styles from './Auth.module.css';
```

## 索引文件与桶式导出

### 桶式导出模式

```typescript
// features/auth/index.ts — 公共 API
export { LoginForm } from './components/LoginForm';
export { useAuth } from './hooks/useAuth';
export type { User, AuthState } from './types/auth.types';

// 切勿导出内部实现细节
// 切勿导出仅在功能内部使用的工具函数
```

### 桶式导出决策表

| 上下文                   | 使用桶式导出？ | 原因                     |
| ------------------------ | -------------- | ------------------------ |
| 功能模块公共 API         | 是，始终使用   | 清晰边界，可控的表面面积 |
| 共享组件库               | 是，始终使用   | 为消费者提供单一导入点   |
| 工具函数库               | 是，始终使用   | 提升共享函数的可发现性   |
| 功能内部（内部使用）     | 否             | 直接导入，避免间接层     |
| 会导致循环依赖           | 否             | 打破循环，直接导入       |
| 会损害树摇优化（已验证） | 否             | 为打包体积使用直接导入   |

## 配置文件放置

### 根级配置

```
root/
  .editorconfig         # 编辑器设置
  .eslintrc.js          # ESLint 配置（或 eslint.config.js）
  .gitignore            # Git 忽略规则
  .prettierrc           # Prettier 配置
  .env.example          # 环境变量模板
  docker-compose.yml    # Docker 组合配置
  Dockerfile            # 容器构建文件
  package.json          # 依赖和脚本
  tsconfig.json         # TypeScript 配置
  next.config.js        # 框架配置
  tailwind.config.ts    # Tailwind 配置
  vitest.config.ts      # 测试配置
```

### 环境文件

```
.env                    # 本地默认值（已 git 忽略）
.env.example            # 带占位值的模板（已提交）
.env.local              # 本地覆盖（已 git 忽略）
.env.development        # 开发环境特定（可提交或不提交）
.env.production         # 生产环境特定（可提交或不提交）
.env.test               # 测试环境特定（可提交或不提交）
```

### 文档结构

```
docs/
  architecture/
    adr/                # 架构决策记录
      001-framework.md
      002-database.md
    diagrams/
  api/                  # API 文档
  guides/
    getting-started.md
    deployment.md
  contributing.md
```

## 迁移策略

### 增量迁移（推荐）

1. 在现有代码旁创建目标结构
2. 一次移动一个功能/模块
3. 使用自动化代码转换脚本更新导入
4. 每次移动后通过测试验证
5. 完整迁移后移除旧结构

### 自动化工具

- `ts-morph`：程序化 TypeScript 重构
- `jscodeshift`：JavaScript 代码转换脚本
- IDE 重构：重命名/移动时自动更新导入
- ESLint `import/order`：强制导入排序

## 反模式 / 常见错误

| 反模式                             | 失败原因                   | 替代方案                         |
| ---------------------------------- | -------------------------- | -------------------------------- |
| 深层嵌套文件夹（> 4 级）           | 难以导航，导入路径过长     | 扁平化结构，使用路径别名         |
| `utils/` 作为 dumping ground       | 变成难以维护的杂物抽屉     | 按领域或用途组织工具函数         |
| 功能间的循环依赖                   | 构建失败，所有权不清晰     | 功能仅从共享模块或自身模块导入   |
| 桶式导出重新导出所有内容           | 破坏树摇优化，打包体积膨胀 | 仅导出公共 API                   |
| 命名不一致（混合规范）             | 认知负担，合并冲突         | 选择一种规范，用 linter 强制执行 |
| 配置分散在多个位置                 | 难以查找和维护             | 所有配置放在项目根目录           |
| 测试放在独立的目录树中             | 难以找到文件的测试         | 测试与源代码共置                 |
| 一个扁平文件夹中有 100+ 文件       | 无法导航                   | 分组为子模块或功能               |
| 索引文件包含逻辑                   | 导入时产生意外副作用       | 索引文件仅重新导出               |
| 大爆炸式迁移（一次性移动所有内容） | 高风险，难以回滚           | 增量移动，每次移动后测试验证     |

## 反合理化防护

- 切勿在不理解当前痛点的情况下重构 — 先评估。
- 切勿跳过团队共识步骤 — 结构变更影响所有人。
- 切勿一次性迁移所有内容 — 一次移动一个模块并验证测试。
- 切勿"为未来可扩展性"创建深层嵌套结构 — 扁平化直到复杂度需要为止。
- 切勿忽略桶式导出对打包体积的影响 — 用打包分析器验证。

## 集成点

| 技能               | 如何关联                           |
| ------------------ | ---------------------------------- |
| `senior-frontend`  | 前端项目结构遵循基于功能或混合模式 |
| `senior-architect` | 架构决策影响模块边界和包结构       |
| `senior-fullstack` | 全栈项目需要协调的前端/后端组织    |
| `clean-code`       | 命名规范和模块边界支持整洁代码原则 |
| `deployment`       | 单体仓库结构影响 CI/CD 流水线配置  |

## 技能类型

**灵活（FLEXIBLE）** — 选择适合项目规模、团队结构和复杂度的组织策略。命名规范和桶式导出模式是建议，应根据现有项目约定进行调整。
