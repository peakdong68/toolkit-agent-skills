# superkit-agents

## Quick Start

**Marketplace install:**

```
/plugin marketplace add peakdong68/toolkit-agent-skills

/plugin install kit-core@toolkit
```

**Local / development:**

```bash

git clone https://github.com/peakdong68/toolkit-agent-skills.git

/plugin marketplace add ./path/to/toolkit-agent-skills
/plugin install kit-core@toolkit

```


---
## 工作流示例

### 新功能（完整生命周期）

```
1. /interview-me    → 访谈澄清用户真正想要什么，避免构建错误的东西
2. /brainstorm     → 探索想法，创建设计文档 
3. /specs          → 使用 JTBD 方法论编写规范 
4. /plan           → 创建包含细粒度任务的实现计划,选择执行技能 
   → `task-management` ：标准实施（少于 3 个任务）,顺序跟踪执行
   → `subagent-driven-development`：大型实施（包含 3 个及以上可独立实现的任务）,并行执行，带审查关卡
   → `autonomous-loop`：自主开发会话  ,Ralph 风格的迭代执行
   → `executing-plans`：单一聚焦任务 ,直接执行计划 （/execute）
5. /execute          → 遵循 TDD 并跟踪进度
6. /review         → 对照计划与标准进行验证 
7. /verify         → 使用全新证据确认一切正常 
8. finishing-a-development-branch   → 合并、创建 PR 或清理
9. /archive         → 归档
```

### 缺陷修复

```
1. /debug          → 系统化的四阶段调试方法论
2. /tdd            → 编写复现缺陷的测试，然后修复
3. /review         → 验证修复
4. /verify         → 使用全新证据确认修复生效
```

### Ralph 自主会话

```
1. /specs          → 编写或审计规范
2. /ralph          → 启动自主循环
   → 规划模式：分析规范，生成 IMPLEMENTATION_PLAN.md
   → 构建模式：选择任务、实现、测试、提交
   → 状态检查：生成 RALPH_STATUS，评估退出门槛
   → 循环直至双条件退出门槛满足
3. /review         → 最终代码审查
4. /verify         → 验证所有验收测试通过
```

### 遗留代码库接入

```
1. /learn          → 扫描并发现项目上下文
2. reverse-engineering-specs → 从现有代码生成规范
3. /specs          → 审计并优化生成的规范
4. /plan           → 规划改进或新功能
5. /execute        → 在完整测试覆盖下实现
```

### API 设计与实现

```
1. api-design      → 设计端点，生成 OpenAPI 规范
2. /specs          → 编写行为规格
3. /plan           → 创建实现计划
4. testing-strategy → 定义测试策略
5. /tdd            → 带测试实现
6. security-review → 检查漏洞
```

### 前端组件开发

```
1. frontend-ui-design → 组件架构、无障碍访问（a11y）、响应式设计
2. /plan              → 创建实现计划
3. /tdd               → 带测试实现
4. performance-opt    → 检查打包体积、Web Vitals 指标
5. /review            → 代码审查
```

### 数据库架构变更

```
1. database-schema-design → 数据建模、规划迁移、索引
2. /plan                  → 创建实现计划
3. /tdd                   → 带迁移测试实现
4. /verify                → 验证迁移双向均可正常运行
```

### 创建产品需求 PRD

```
1. /prd            → 创建产品需求文档 
4. /plan           → 规划参考 PRD 需求进行任务拆解
5. /execute        → 执行计划，遵循 TDD 并跟踪进度
```

### 文档生成

```
1. /docs           → 从代码生成技术文档
2. llm-as-judge    → 评估文档质量
```

### 安全审计

```
1. security-review → OWASP Top 10、认证模式、输入验证
2. /plan           → 规划修复方案
3. /tdd            → 带回归测试修复漏洞
4. /verify         → 确认所有问题已解决
```

### 性能优化

```
1. performance-optimization → 性能分析，识别瓶颈
2. /plan                    → 规划优化方案
3. /tdd                     → 带基准测试实现
4. /verify                  → 确认达到性能目标
```

## 斜杠命令 

| 命令 | 描述 | 调用技能 |
|---------|-------------|----------|
| `/plan` | 启动结构化规划 | `planning` |
| `/interview-me` | 访谈澄清用户意图 | `interview-me` |
| `/brainstorm` | 启动头脑风暴会话 | `brainstorming` |
| `/execute` | 执行已批准的计划 | `executing-plans` |
| `/tdd` | 启动 TDD 工作流 | `test-driven-development` |
| `/debug` | 启动调试方法 | `systematic-debugging` |
| `/review` | 请求代码评审 | `code-review` |
| `/verify` | 验证完成声明 | `verification-before-completion` |
| `/prd` | 生成 PRD | `prd-generation` |
| `/learn` | 扫描并学习项目上下文 | `self-learning` |
| `/docs` | 生成技术文档 | `tech-docs-generator` |
| `/worktree` | 设置 git worktree | `using-git-worktrees` |
| `/ralph` | 启动 Ralph 自主开发循环 | `autonomous-loop` |
| `/specs` | 编写或审计规范 | `spec-writing` |
| `/loop` | 启动自主循环迭代 | `autonomous-loop` |
| `/frontend` | 高级前端开发 | `senior-frontend` |
| `/backend` | 高级后端开发 | `senior-backend` |
| `/architect` | 架构设计与评审 | `senior-architect` |
| `/fullstack` | 全栈开发 | `senior-fullstack` |
| `/design-system` | 设计系统生成 | `ui-design-system` |
| `/ui-ux` | UI/UX 设计智能 | `ui-ux-pro-max` |
| `/mobile` | 移动端设计模式 | `mobile-design` |
| `/clean` | 整洁代码评审 | `clean-code` |
| `/devops` | DevOps 与基础设施 | `senior-devops` |
| `/agent` | AI 代理开发 | `agent-development` |
| `/mcp` | MCP 服务器开发 | `mcp-builder` |
| `/commit` | Git 提交助手 | `git-commit-helper` |
| `/decompose` | 任务分解 | `task-decomposition` |
| `/archive` | 归档已完成功能 | `archive` |

 
---

## 技能概览

### Meta — 发现适用技能

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [using-toolkit](skills/using-toolkit/SKILL.md) | 主入口，确立如何查找、选择和使用所有工具包技能 | 每次会话启动、接收新任务、不确定该用哪个技能时 |
| [self-learning](skills/self-learning/SKILL.md) | 自动扫描项目、发现并记忆上下文、模式与偏好 | 接手新项目、遇到意外模式、用户纠正你的假设时 |

### Core — 始终运行的守护机制

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [resilient-execution](skills/resilient-execution/SKILL.md) | 失败时至少尝试 3 种不同方法再放弃 | 任务失败、方法不奏效、遇到错误时 |
| [circuit-breaker](skills/circuit-breaker/SKILL.md) | 检测停滞循环、限制速率、保护配置文件、冷却恢复 | 自主循环运行、重复操作、检测到停滞模式时 |
| [auto-improvement](skills/auto-improvement/SKILL.md) | 持续追踪效果、分类错误、识别模式、改进工作流 | 每个会话自动激活，无需手动调用 |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | 5 步 HARD-GATE 协议，强制要求全新证据才能声明完成 | 任务完成前、功能交付前、声明"已完成"前 |

### Define — 定义要构建什么

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [interview-me](skills/interview-me/SKILL.md) | 一次一问的访谈法，挖掘用户真正想要的东西而非表面需求 | 需求描述不充分、缺少"为谁/为何/成功标准"时 |
| [brainstorming](skills/brainstorming/SKILL.md) | 创意探索，在规划前对比多种设计方案 | 开始新功能、探索想法、用户描述模糊目标时 |
| [spec-writing](skills/spec-writing/SKILL.md) | 用 JTBD 方法论编写行为规格，Given/When/Then 验收标准 | 需要正式规格、从头脑风暴过渡到实现时 |
| [prd-generation](skills/prd-generation/SKILL.md) | 将产品愿景转化为结构化 PRD，含用户故事和优先级 | 新产品功能、需要产品需求文档时 |
| [reverse-engineering-specs](skills/reverse-engineering-specs/SKILL.md) | 从现有代码库生成无实现细节的行为规格 | 接手遗留代码、需要为已有功能补充规格时 |

### Plan — 规划如何构建

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [planning](skills/planning/SKILL.md) | 结构化 5 阶段规划：上下文→提问→方案对比→文档→执行交接 | 开始任何实现任务、功能请求、Bug 修复或重构前 |
| [task-decomposition](skills/task-decomposition/SKILL.md) | 层次化任务拆解、依赖映射、并行化分析和关键路径规划 | 复杂任务需要拆解为可管理子任务时 |

### Execute — 构建与实现

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [task-management](skills/task-management/SKILL.md) | 将工作拆分为离散步骤，在实现中追踪进度和检查点 | 已批准的计划需要转为可追踪任务时 |
| [executing-plans](skills/executing-plans/SKILL.md) | 按批次逐步执行已批准的计划文档，含 TDD 和检查点审查 | 单一聚焦任务、有已批准计划需要执行时 |
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md) | 派发子代理并行执行，含两阶段审查门控（规格合规+代码质量） | 3+ 独立任务、追求执行速度、任务有清晰验收标准时 |
| [dispatching-parallel-agents](skills/dispatching-parallel-agents/SKILL.md) | 协调多个独立子代理并行处理互不依赖的子任务 | 子任务操作不同文件、串行执行时间显著长于并行时 |
| [autonomous-loop](skills/autonomous-loop/SKILL.md) | Ralph 风格迭代开发：规划→构建→状态检查→循环直至完成 | 自主开发会话、`/ralph` 或 `/loop` 命令时 |
| [ralph-status](skills/ralph-status/SKILL.md) | 结构化进度报告，含 EXIT_SIGNAL 协议和双条件退出门控 | 每次自主循环迭代结束时自动输出 |

### QA — 测试、审查与验证

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [code-review](skills/code-review/SKILL.md) | 对照计划和编码标准审查代码质量，分类为 Critical/Important/Suggestion | 任务完成、合并前、验证工作符合要求时 |
| [test-driven-development](skills/test-driven-development/SKILL.md) | 严格执行 RED-GREEN-REFACTOR 循环，禁止无测试就写代码 | 编写任何新代码、添加功能、修复需要代码变更的 Bug 时 |
| [testing-strategy](skills/testing-strategy/SKILL.md) | 根据项目选择测试框架、定义覆盖率阈值、建立测试模式 | 新项目搭建、CI/CD 设计、覆盖率审计、框架迁移时 |
| [systematic-debugging](skills/systematic-debugging/SKILL.md) | 4 阶段调试法：观察→假设→实验→修复，防止散弹式调试 | 测试失败、运行时错误、意外行为、性能退化时 |
| [acceptance-testing](skills/acceptance-testing/SKILL.md) | 验收驱动背压机制，行为验证门控，防止未通过测试就声明完成 | 规格到代码验证、功能完成验证、合并前验收门控时 |
| [llm-as-judge](skills/llm-as-judge/SKILL.md) | 基于结构化评分量规评估主观质量标准（语调、UI 体验、可读性）| 文档质量检查、错误消息语调审查、设计美学评估时 |
| [security-review](skills/security-review/SKILL.md) | OWASP Top 10、认证模式、输入验证、密钥管理、依赖审计 | 认证实现、输入处理、密钥管理、部署前安全检查时 |
| [performance-optimization](skills/performance-optimization/SKILL.md) | 性能分析、缓存策略、打包优化、Web Vitals、数据库查询优化 | 页面加载慢、Web Vitals 差、数据库超时、打包体积大时 |
| [webapp-testing](skills/webapp-testing/SKILL.md) | 基于 Playwright 的 E2E 测试、截图对比、浏览器日志分析、无障碍审计 | E2E 测试搭建、视觉回归测试、CI 测试流水线时 |

### Specialize — 专业领域角色

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [senior-frontend](skills/senior-frontend/SKILL.md) | React/Next.js/TypeScript 专家，严格组件架构，状态管理，>85% 测试覆盖 | React 组件开发、Next.js 页面、状态管理设计时 |
| [senior-backend](skills/senior-backend/SKILL.md) | API 设计、微服务、事件驱动、数据库集成、缓存、可观测性 | REST/GraphQL API、服务架构、消息队列、健康检查时 |
| [senior-architect](skills/senior-architect/SKILL.md) | 系统设计、可扩展性分析、权衡评估、ADR 编写 | 新系统设计、技术选型、扩展策略、基础设施拓扑时 |
| [senior-fullstack](skills/senior-fullstack/SKILL.md) | 端到端 TypeScript 开发：数据库→API→UI，含 tRPC/Prisma/Next.js/Auth | 全栈功能实现、数据库到 UI 管线、认证搭建时 |
| [senior-devops](skills/senior-devops/SKILL.md) | CI/CD、Docker、Kubernetes、Terraform、监控、零停机部署 | DevOps、容器化、基础设施即代码、可观测性时 |
| [senior-data-scientist](skills/senior-data-scientist/SKILL.md) | ML 流水线、统计分析、特征工程、模型选择、实验追踪 | 数据集探索、模型训练、超参数调优、可视化创建时 |
| [senior-prompt-engineer](skills/senior-prompt-engineer/SKILL.md) | 提示词设计、优化、Few-shot、Chain-of-Thought、结构化输出、评分框架 | 创建新提示词、A/B 测试提示词、构建评分框架时 |
| [clean-code](skills/clean-code/SKILL.md) | SOLID、DRY、代码异味识别、命名规范、复杂度降低、错误处理改进 | 代码质量审查、重构指导、需要减少技术债务时 |
| [react-best-practices](skills/react-best-practices/SKILL.md) | React hooks 设计、组件组合、Server Components、错误边界、渲染优化 | React hooks 设计、Server/Client 组件决策、错误边界放置时 |

### Design — 架构与接口设计

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [api-design](skills/api-design/SKILL.md) | REST/GraphQL/tRPC 端点设计、请求/响应 Schema、OpenAPI 规范 | 设计 API 端点、生成 OpenAPI 规范、选择 API 范式时 |
| [database-schema-design](skills/database-schema-design/SKILL.md) | 数据建模、迁移规划、索引设计、查询优化、SQL/NoSQL 选型 | 设计数据库 Schema、创建迁移、建模数据关系时 |
| [frontend-ui-design](skills/frontend-ui-design/SKILL.md) | 组件架构、响应式布局、设计系统、状态管理方案选型 | 设计 UI 组件、创建组件架构、选择状态管理方案时 |

### Creative — 创意与视觉设计

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [ui-ux-pro-max](skills/ui-ux-pro-max/SKILL.md) | 全栈 UI/UX 设计智能：67 种风格、161 种配色、57 种字体、图表选型 | 需要完整设计方案、配色、字体、无障碍、响应式时 |
| [ui-design-system](skills/ui-design-system/SKILL.md) | 设计令牌、组件库、主题系统、Tailwind CSS v4 响应式模式 | 构建设计系统、组件库、暗色模式令牌、品牌主题时 |
| [canvas-design](skills/canvas-design/SKILL.md) | HTML Canvas、SVG、D3.js 数据可视化、生成艺术 | Canvas、SVG、图表、数据可视化、交互动画时 |
| [mobile-design](skills/mobile-design/SKILL.md) | React Native/Flutter/SwiftUI 模式、平台 HIG 合规、手势、离线优先 | 移动端 App 设计、iOS/Android、跨平台开发时 |
| [ux-researcher-designer](skills/ux-researcher-designer/SKILL.md) | 用户研究、人物画像、旅程地图、可用性测试、信息架构 | 用户研究、可用性测试、卡片分类、启发式评估时 |
| [artifacts-builder](skills/artifacts-builder/SKILL.md) | 独立 HTML/CSS/JS 工件、交互演示、原型、可视化工具 | 需要独立页面、交互式演示、无需构建步骤的原型时 |

### Docs — 文档与归档

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [tech-docs-generator](skills/tech-docs-generator/SKILL.md) | 从代码生成 API 参考、架构文档、README、组件文档 | 需要生成或更新技术文档时 |
| [writing-skills](skills/writing-skills/SKILL.md) | 用 TDD 方法创建新技能：测试提示词→最小实现→硬化→验证 | 创建新技能、命令或代理定义时 |
| [archive](skills/archive/SKILL.md) | 归档已完成功能，更新全局规格索引，pre-archive 验证 | 功能完成、Sprint 收尾、清理过期 spec/plan 目录时 |

### Ops — 部署与自动化

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [deployment](skills/deployment/SKILL.md) | CI/CD 流水线、部署配置、发布检查清单、环境管理 | 新项目需要部署、迁移 CI/CD、添加 staging/production 环境时 |
| [using-git-worktrees](skills/using-git-worktrees/SKILL.md) | 创建隔离 Git 工作树，并行开发互不干扰 | 开始新功能分支、同时处理多个任务无需 stash 时 |
| [finishing-a-development-branch](skills/finishing-a-development-branch/SKILL.md) | 结构化分支完成流程：合并、创建 PR、清理归档 | 分支工作完成、准备合并、创建 PR 时 |
| [git-commit-helper](skills/git-commit-helper/SKILL.md) | 约定式提交、语义版本控制、变更日志生成 | 需要帮助写 commit message、版本号管理、生成 changelog 时 |
| [mcp-builder](skills/mcp-builder/SKILL.md) | MCP 服务器开发：工具定义、资源管理、提示模板、传输层 | 构建 MCP 服务器、为 AI 客户端创建工具时 |
| [agent-development](skills/agent-development/SKILL.md) | 构建 AI 代理：工具使用模式、记忆管理、规划策略、安全护栏 | 构建 AI 代理、工具使用、多代理协调、护栏设计时 |

### Business — 内容与营销

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [content-research-writer](skills/content-research-writer/SKILL.md) | 研究方法论、长篇内容、学术引用、事实核查 | 白皮书、研究文章、案例研究、证据驱动的论证时 |
| [content-creator](skills/content-creator/SKILL.md) | 营销文案、社交媒体、品牌语调、广告文案、Newsletter | 社交媒体帖子、邮件活动文案、落地页文字、广告文案时 |

### Productivity — 效率工具

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [file-organizer](skills/file-organizer/SKILL.md) | 项目结构组织：Monorepo 模式、功能目录架构、命名约定、barrel export | 重构项目结构、搭建 Monorepo、定义命名规范、规划目录迁移时 |

 
---

## 代理

| Agent | What It Does | Use When |
|-------|-------------|-----------|
| [planner](agents/planner.md) | 创建实现计划，分析架构，评估权衡 | 多步骤功能开发前需要结构化计划时 |
| [code-reviewer](agents/code-reviewer.md) | 对照计划和标准审查代码，分类 Critical/Important/Suggestion | 任务完成后、合并前需要质量验证时 |
| [prd-writer](agents/prd-writer.md) | 根据需求生成结构化 PRD，含用户故事和优先级 | 产品需求需要正式文档化时 |
| [doc-generator](agents/doc-generator.md) | 从代码生成 API 参考、架构文档、README | 需要生成或更新技术文档时 |
| [spec-reviewer](agents/spec-reviewer.md) | 对照规范验收标准审查实现合规性 | 实现完成后需要验证规范合规性时 |
| [quality-reviewer](agents/quality-reviewer.md) | 审查代码质量、模式、性能、安全性 | 代码审查阶段需要全面质量评估时 |
| [loop-orchestrator](agents/loop-orchestrator.md) | 管理自主开发循环：选择任务、评估退出、生成状态报告 | Ralph 风格迭代开发会话时 |
| [spec-writer](agents/spec-writer.md) | 生成 JTBD 行为规格，Given/When/Then 验收标准 | 需要为功能编写正式规格时 |
| [acceptance-judge](agents/acceptance-judge.md) | 通过结构化评分量规评估主观质量（语调、UX、可读性）| 需要 LLM-as-judge 模式评估时 |
| [frontend-developer](agents/frontend-developer.md) | 三阶段前端开发：上下文发现→组件开发→测试交接 | 前端功能开发、React 组件实现时 |
| [ui-ux-designer](agents/ui-ux-designer.md) | 设计系统生成、组件规范、风格指南、配色方案 | 构建设计系统、需要 UI/UX 设计规范时 |
| [backend-architect](agents/backend-architect.md) | 服务边界设计、契约优先 API、扩展性规划 | 后端服务架构设计、API 契约定义时 |
| [context-manager](agents/context-manager.md) | 项目上下文跟踪、依赖映射、技术栈文档化 | 接手新项目、需要了解项目全貌时 |
| [database-architect](agents/database-architect.md) | 多数据库策略、数据建模、事件溯源、迁移规划 | 数据库架构设计、Schema 变更时 |
| [architect-reviewer](agents/architect-reviewer.md) | 架构评审、可扩展性评估、技术债务识别 | 架构决策评审、系统重构评估时 |
| [typescript-pro](agents/typescript-pro.md) | 高级 TypeScript 类型模式、条件类型、品牌类型 | 复杂类型设计、类型安全保障时 |
| [task-decomposer](agents/task-decomposer.md) | 层次化任务拆解、依赖分析、并行化策略 | 复杂任务需要 WBS 拆解时 |
| [mobile-developer](agents/mobile-developer.md) | 跨平台移动开发、React Native/Flutter/SwiftUI 模式 | 移动端 App 开发、平台特定功能实现时 |



---

## Ralph 集成 — 自主迭代开发循环

本工具包整合了 [Ralph](https://github.com/frankbria/ralph-claude-code) 和 [Ralph Playbook](https://github.com/ClaytonFarr/ralph-playbook) 的关键概念 — 这是 Geoffrey Huntley 提出的一种自主 AI 开发方法论。

### 自主循环（`/ralph` 或 `/loop`）

迭代开发周期：**规划** → **构建** → **状态检查** → 重复直至完成。

- **每个循环仅处理一个任务** — 每次迭代选择并完成恰好一个任务
- **上下文效率** — 主上下文利用率保持在 40-60%，最多支持 5 个并行读取子代理
- **上游/下游引导** — 规范塑造输入，测试/构建/代码检查创建背压
- **双重条件退出门控** — 需要同时满足完成语言表述和显式的 `EXIT_SIGNAL: true`

### 熔断器

防止无限循环和资源耗尽的安全机制：

- 3 次循环无进展、5 次相同错误或输出下降 70% 后触发熔断
- 重试前有 30 分钟冷却期
- 速率限制（可配置每小时调用次数）
- 文件保护防止意外删除配置

### JTBD 规范（`/specs`）

用于编写无实现细节规范的"待办事项"（Jobs to Be Done）方法论：

- 将需求分解为关注主题
- "一句话不含'和'"测试以确保适当范围界定
- 采用 Given/When/Then 格式的验收标准
- SLC（简单/可爱/完整）发布规划

### 验收测试与 LLM-as-Judge

- **验收测试** — 背压链：规范 → 测试 → 代码（修复代码，而非规范）
- **LLM-as-judge** — 针对主观标准（语调、用户体验、可读性）的结构化评分评估
 
---
 
##  许可证

[MIT](LICENSE)
