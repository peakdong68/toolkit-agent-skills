# superkit-agents

## Quick Start

**Marketplace install:**

```
/plugin marketplace add peakdong68/toolkit-agent-skills

/plugin install toolkit@toolkit-agents
```

**Local / development:**

```bash

git clone https://github.com/peakdong68/toolkit-agent-skills.git

claude --plugin-dir /path/to/toolkit-agent-skills

```
## 您将获得什么

| 65 项技能 | 20 个代理 | 32 条命令 | 钩子 | 记忆系统 |
|:---------:|:--------:|:-----------:|:-----:|:-------------:|
| 覆盖开发各阶段的结构化工作流 | 用于并行工作的专业化子代理 | 触发技能的斜杠命令 | 会话启动时的上下文注入 | 持久化的项目知识库 |


---
## 工作流示例

### 新功能（完整生命周期）

```
1. /brainstorm     → 探索想法，创建设计文档 
2. /specs          → 使用 JTBD 方法论编写规范 
3. /plan           → 创建包含细粒度任务的实现计划,选择执行技能 
   → `task-management` ：标准实施（少于 10 个任务）,顺序跟踪执行
   → `subagent-driven-development`：型实施（10 个以上独立任务）,并行执行，带审查关卡
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
2. /brainstorm     → 先探索方法再规划
3. /specs          → PRD 提供高层级需求；规格说明用 JTBD 细化它们
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

---

## 技能概览

<details>
<summary><strong>核心（6 项）</strong> — 始终推荐的基础技能</summary>

| 技能 | 描述 |
|-------|-------------|
| `using-toolkit` | 主技能 — 确立如何查找和使用所有工具包技能 |
| `self-learning` | 自动发现并记忆项目上下文 |
| `resilient-execution` | 永不失败 — 使用替代方法重试 |
| `circuit-breaker` | 循环停滞检测、速率限制和恢复模式 |
| `auto-improvement` | 自我改进系统，跟踪有效性，从错误中学习 |
| `verification-before-completion` | 在任何完成声明之前进行 5 步验证门控 |

</details>

<details>
<summary><strong>流程与工作流（9 项）</strong> — 规划、执行和自主循环</summary>

| 技能 | 描述 |
|-------|-------------|
| `brainstorming` | 规划前的创意探索与设计 |
| `planning` | 任何实现工作前的结构化规划 |
| `task-management` | 将工作分解为离散的跟踪步骤 |
| `executing-plans` | 逐步执行已批准的计划文档 |
| `subagent-driven-development` | 同一会话内执行，带有两阶段评审门控 |
| `dispatching-parallel-agents` | 协调多个独立代理并行工作 |
| `autonomous-loop` | Ralph 风格的迭代开发，带有自主规划和构建循环 |
| `ralph-status` | 带有退出信号协议的结构化状态报告 |
| `task-decomposition` | 层次化分解、依赖映射、并行化 |

</details>

<details>
<summary><strong>质量保证（17 项）</strong> — 测试、评审、调试和专业角色</summary>

| 技能 | 描述 |
|-------|-------------|
| `code-review` | 针对计划和标准进行质量验证 |
| `test-driven-development` | 采用 RED-GREEN-REFACTOR 循环的 TDD 工作流 |
| `testing-strategy` | 根据项目上下文选择测试方法 |
| `systematic-debugging` | 带有根本原因分析的 4 阶段调试方法 |
| `security-review` | OWASP Top 10、认证模式、输入验证、密钥管理 |
| `performance-optimization` | 性能分析、缓存、打包优化、Web Vitals |
| `acceptance-testing` | 验收驱动的背压机制，带有行为验证门控 |
| `llm-as-judge` | 针对主观质量标准的非确定性验证 |
| `senior-frontend` | React/Next.js/TypeScript 专家，测试覆盖率 >85% |
| `senior-backend` | API 设计、微服务、事件驱动架构 |
| `senior-architect` | 系统设计、可扩展性、权衡分析、ADR |
| `senior-fullstack` | 全栈端到端开发 |
| `clean-code` | SOLID、DRY、代码异味、重构模式 |
| `react-best-practices` | React hooks、context、suspense、服务器组件 |
| `webapp-testing` | 基于 Playwright 的 Web 测试、截图、浏览器日志 |
| `senior-prompt-engineer` | 提示词设计、优化、思维链 |
| `senior-data-scientist` | ML 流水线、统计分析、实验设计 |

</details>

<details>
<summary><strong>设计（3 项）</strong> — API、UI 和数据库设计</summary>

| 技能 | 描述 |
|-------|-------------|
| `api-design` | 带有 OpenAPI 规范的结构化 API 端点设计 |
| `frontend-ui-design` | 组件架构、响应式设计、可访问性 |
| `database-schema-design` | 数据建模、迁移、索引、查询优化 |

</details>

<details>
<summary><strong>文档（6 项）</strong> — PRD、规范和技术文档</summary>

| 技能 | 描述 |
|-------|-------------|
| `prd-generation` | 生成产品需求文档 |
| `tech-docs-generator` | 从代码生成技术文档 |
| `writing-skills` | 使用 TDD 和最佳实践创建新技能 |
| `spec-writing` | 基于 JTBD 的规范编写，带有验收标准 |
| `reverse-engineering-specs` | 从现有代码库生成无实现细节的规范 |
| `archive` | 归档已完成功能、更新规范索引、归档前验证 |

</details>

<details>
<summary><strong>运维（7 项）</strong> — Git、CI/CD、DevOps 和 MCP</summary>

| 技能 | 描述 |
|-------|-------------|
| `deployment` | CI/CD 流水线生成和部署检查清单 |
| `using-git-worktrees` | 使用 git worktrees 的隔离开发环境 |
| `finishing-a-development-branch` | 带有合并选项的结构化分支完成流程 |
| `git-commit-helper` | 约定式提交、语义版本控制、变更日志 |
| `senior-devops` | CI/CD、Docker、Kubernetes、基础设施即代码 |
| `mcp-builder` | MCP 服务器开发、工具、资源、传输层 |
| `agent-development` | 构建 AI 代理、工具使用、记忆、规划 |

</details>

<details>
<summary><strong>创意（6 项）</strong> — UI/UX、设计系统、移动端和画布</summary>

| 技能 | 描述 |
|-------|-------------|
| `ui-ux-pro-max` | 完整 UI/UX 设计智能，含 67 种风格、161 种配色、57 种字体 |
| `ui-design-system` | 设计令牌、组件库、Tailwind CSS、响应式模式 |
| `canvas-design` | HTML Canvas、SVG、数据可视化、生成艺术 |
| `mobile-design` | React Native、Flutter、SwiftUI、平台 HIG 合规性 |
| `ux-researcher-designer` | 用户研究、人物画像、旅程地图、可用性测试 |
| `artifacts-builder` | 生成独立工件、交互式演示、原型 |

</details>

<details>
<summary><strong>商业（3 项）</strong> — SEO、内容和营销</summary>

| 技能 | 描述 |
|-------|-------------|
| `seo-optimizer` | 技术 SEO、元标签、结构化数据、Core Web Vitals |
| `content-research-writer` | 研究方法、长篇内容、引用 |
| `content-creator` | 营销文案、社交媒体、品牌语调 |

</details>

<details>
<summary><strong>文档处理（3 项）</strong> — Word、PDF 和 Excel</summary>

| 技能 | 描述 |
|-------|-------------|
| `docx-processing` | Word 文档生成、模板填充 |
| `pdf-processing` | PDF 生成、表单填充、OCR、合并/拆分 |
| `xlsx-processing` | Excel 操作、公式、图表 |

</details>

<details>
<summary><strong>生产力与沟通（2 项）</strong></summary>

| 技能 | 描述 |
|-------|-------------|
| `file-organizer` | 项目结构、文件命名、目录架构 |
| `email-composer` | 专业邮件撰写、语调调整 |

</details>

<details>
<summary><strong>框架与语言（3 项）</strong> — Laravel 和 PHP</summary>

| 技能 | 描述 |
|-------|-------------|
| `laravel-specialist` | Laravel 开发 — Eloquent、Blade、Livewire、队列、Pest 测试 |
| `php-specialist` | 现代 PHP 8.x — 枚举、纤程、readonly、PSR 标准、静态分析 |
| `laravel-boost` | Laravel Boost 性能优化 — 缓存、数据库、Octane |

</details>

---

## 代理与命令

<details>
<summary><strong>20 个代理</strong> — 用于并行工作的专业化子代理</summary>

| 代理 | 描述 |
|-------|-------------|
| `planner` | 创建实现计划的高级架构师 |
| `code-reviewer` | 针对计划和标准审查代码 |
| `prd-writer` | 根据收集的需求生成 PRD |
| `doc-generator` | 从代码生成技术文档 |
| `spec-reviewer` | 针对规范合规性审查实现 |
| `quality-reviewer` | 审查代码质量、模式、性能、安全性 |
| `loop-orchestrator` | 管理自主开发循环迭代 |
| `spec-writer` | 生成带有验收标准的 JTBD 规范 |
| `acceptance-judge` | 通过 LLM-as-judge 模式评估主观质量 |
| `frontend-developer` | 三阶段前端开发：上下文发现、开发、交接 |
| `ui-ux-designer` | 设计系统生成、组件规范、风格指南 |
| `backend-architect` | 服务边界、契约优先 API、扩展性 |
| `context-manager` | 项目上下文跟踪、依赖映射 |
| `database-architect` | 多数据库策略、领域驱动设计、事件溯源 |
| `architect-reviewer` | 架构评审、可扩展性评估、技术债务 |
| `typescript-pro` | 高级类型模式、条件类型、品牌类型 |
| `task-decomposer` | 层次化任务分解、并行化策略 |
| `mobile-developer` | 跨平台移动开发、平台特定模式 |
| `laravel-developer` | Laravel 专家，具备 Eloquent、Blade、Livewire 和 Pest 专业知识 |
| `php-developer` | 现代 PHP 8.x 开发，符合 PSR 标准并支持静态分析 |

</details>

<details>
<summary><strong>31 条斜杠命令</strong> — 在 Claude Code 中直接触发技能</summary>

| 命令 | 描述 | 调用技能 |
|---------|-------------|----------|
| `/plan` | 启动结构化规划 | `planning` |
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
| `/seo` | SEO 优化 | `seo-optimizer` |
| `/email` | 邮件撰写 | `email-composer` |
| `/mcp` | MCP 服务器开发 | `mcp-builder` |
| `/commit` | Git 提交助手 | `git-commit-helper` |
| `/decompose` | 任务分解 | `task-decomposition` |
| `/laravel` | Laravel 开发 | `laravel-specialist` |
| `/php` | 现代 PHP 开发 | `php-specialist` |
| `/archive` | 归档已完成功能 | `archive` |

</details>



---

## Ralph 集成 — 自主迭代开发循环

本工具包整合了 [Ralph](https://github.com/frankbria/ralph-claude-code) 和 [Ralph Playbook](https://github.com/ClaytonFarr/ralph-playbook) 的关键概念 — 这是 Geoffrey Huntley 提出的一种自主 AI 开发方法论。

### 自主循环（`/ralph` 或 `/loop`）

迭代开发周期：**规划** → **构建** → **状态检查** → 重复直至完成。

- **每个循环仅处理一个任务** — 每次迭代选择并完成恰好一个任务
- **上下文效率** — 主上下文利用率保持在 40-60%，最多支持 500 个并行读取子代理
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