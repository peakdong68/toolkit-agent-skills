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


---
## 工作流示例

### 新功能（完整生命周期）

```
1. /brainstorm     → 探索想法，创建设计文档 
2. /specs          → 使用 JTBD 方法论编写规范 
3. /plan           → 创建包含细粒度任务的实现计划,选择执行技能 
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

### Meta — Discover which skill applies

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [using-toolkit](skills/using-toolkit/SKILL.md) | Maps incoming work to the right skill workflow and defines shared operating rules | Starting a session or deciding which skill applies |
| [self-learning](skills/self-learning/SKILL.md) | Auto-discovers and remembers project context, patterns, and preferences | Onboarding to a new project, encountering unexpected patterns, or when assumptions are corrected |

### Define — Clarify what to build

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [interview-me](skills/interview-me/SKILL.md) | One-question-at-a-time interview that extracts what the user actually wants instead of what they think they should want, until ~95% confidence | The ask is underspecified, or the user invokes "interview me" / "grill me" |
| [brainstorming](skills/brainstorming/SKILL.md) | Structured divergent/convergent thinking to turn vague ideas into concrete proposals | You have a rough concept that needs exploration |
| [spec-writing](skills/spec-writing/SKILL.md) | Write a PRD covering objectives, commands, structure, code style, testing, and boundaries before any code | Starting a new project, feature, or significant change |
| [prd-generation](skills/prd-generation/SKILL.md) | Converts product vision into structured PRDs with user stories and priorities | A new product feature needs documented requirements |
| [reverse-engineering-specs](skills/reverse-engineering-specs/SKILL.md) | Generates implementation-free behavioral specs from existing codebases | Inheriting legacy code, or needing specs for undocumented features |

### Plan — Break it down

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [planning](skills/planning/SKILL.md) | Decompose specs into small, verifiable tasks with acceptance criteria and dependency ordering | You have a spec and need implementable units |
| [task-decomposition](skills/task-decomposition/SKILL.md) | Hierarchical task breakdown, dependency mapping, parallelization analysis, critical path planning | Complex tasks need decomposition into manageable subtasks |

### Build — Write the code

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [task-management](skills/task-management/SKILL.md) | Breaks work into discrete tracked steps with progress reporting and checkpoint reviews | An approved plan needs conversion to tracked tasks |
| [executing-plans](skills/executing-plans/SKILL.md) | Executes approved plan documents in batches with TDD and checkpoint reviews | A single focused task with an approved plan to execute |
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md) | Dispatches subagents for parallel execution with two-stage review gates | 3+ independent tasks, speed matters, tasks have clear acceptance criteria |
| [dispatching-parallel-agents](skills/dispatching-parallel-agents/SKILL.md) | Coordinates multiple independent subagents working on unrelated subtasks in parallel | Subtasks touch different files, serial execution would be significantly slower |
| [autonomous-loop](skills/autonomous-loop/SKILL.md) | Ralph-style iterative development: plan → build → status check → loop until done | Autonomous dev sessions, `/ralph` or `/loop` commands |
| [ralph-status](skills/ralph-status/SKILL.md) | Structured progress reporting with EXIT_SIGNAL protocol and dual-condition exit gates | End of every autonomous loop iteration |
| [senior-frontend](skills/senior-frontend/SKILL.md) | React/Next.js/TypeScript expert with rigorous component architecture, >85% test coverage | React component development, Next.js pages, state management design |
| [senior-backend](skills/senior-backend/SKILL.md) | API design, microservices, event-driven systems, database integration, caching, observability | REST/GraphQL APIs, service architecture, message queues, health checks |
| [senior-architect](skills/senior-architect/SKILL.md) | System design, scalability analysis, trade-off evaluation, ADR writing | New system design, technology selection, scaling strategy |
| [senior-fullstack](skills/senior-fullstack/SKILL.md) | End-to-end TypeScript: database → API → UI, with tRPC/Prisma/Next.js/Auth | Full-stack feature implementation, DB-to-UI pipeline, auth setup |
| [senior-devops](skills/senior-devops/SKILL.md) | CI/CD, Docker, Kubernetes, Terraform, monitoring, zero-downtime deployments | DevOps, containerization, infrastructure-as-code, observability |
| [senior-data-scientist](skills/senior-data-scientist/SKILL.md) | ML pipelines, statistical analysis, feature engineering, model selection, experiment tracking | Dataset exploration, model training, hyperparameter tuning, visualization |
| [senior-prompt-engineer](skills/senior-prompt-engineer/SKILL.md) | Prompt design, optimization, few-shot, chain-of-thought, structured output, evaluation | Creating new prompts, A/B testing prompts, building evaluation frameworks |
| [clean-code](skills/clean-code/SKILL.md) | SOLID, DRY, code smell detection, naming conventions, complexity reduction | Code quality review, refactoring guidance, technical debt reduction |
| [react-best-practices](skills/react-best-practices/SKILL.md) | React hooks design, component composition, Server Components, error boundaries, render optimization | Hook design, Server/Client component decisions, error boundary placement |
| [api-design](skills/api-design/SKILL.md) | REST/GraphQL/tRPC endpoint design, request/response schemas, OpenAPI specifications | Designing API endpoints, generating OpenAPI specs, choosing API paradigms |
| [database-schema-design](skills/database-schema-design/SKILL.md) | Data modeling, migration planning, index design, query optimization, SQL/NoSQL selection | Designing database schemas, creating migrations, modeling data relationships |
| [frontend-ui-design](skills/frontend-ui-design/SKILL.md) | Component architecture, responsive layouts, design systems, state management selection | Designing UI components, creating component architectures, choosing state management |
| [ui-ux-pro-max](skills/ui-ux-pro-max/SKILL.md) | Full UI/UX design intelligence: 67 styles, 161 palettes, 57 fonts, chart selection | Complete design, color palette, typography, accessibility, responsive design |
| [ui-design-system](skills/ui-design-system/SKILL.md) | Design tokens, component libraries, theme systems, Tailwind CSS v4 responsive patterns | Building design systems, component libraries, dark mode tokens, brand themes |
| [canvas-design](skills/canvas-design/SKILL.md) | HTML Canvas, SVG, D3.js data visualization, generative art | Canvas, SVG, charts, data visualization, interactive animations |
| [mobile-design](skills/mobile-design/SKILL.md) | React Native/Flutter/SwiftUI patterns, platform HIG compliance, gestures, offline-first | Mobile app design, iOS/Android, cross-platform development |
| [ux-researcher-designer](skills/ux-researcher-designer/SKILL.md) | User research, personas, journey maps, usability testing, information architecture | User research, usability tests, card sorting, heuristic evaluation |
| [artifacts-builder](skills/artifacts-builder/SKILL.md) | Standalone HTML/CSS/JS artifacts, interactive demos, prototypes, visual tools | Standalone pages, interactive demos, prototypes with no build step |
| [tech-docs-generator](skills/tech-docs-generator/SKILL.md) | Generates API references, architecture docs, READMEs, component docs from code | Generating or updating technical documentation |
| [writing-skills](skills/writing-skills/SKILL.md) | Creates new skills with TDD: test prompts → minimal implementation → harden → validate | Creating new skills, commands, or agent definitions |
| [mcp-builder](skills/mcp-builder/SKILL.md) | MCP server development: tool definitions, resource management, prompt templates, transport | Building MCP servers, creating tools for AI clients |
| [agent-development](skills/agent-development/SKILL.md) | Build AI agents: tool use patterns, memory management, planning strategies, guardrails | Building AI agents, tool use, multi-agent coordination, safety guardrails |
| [content-research-writer](skills/content-research-writer/SKILL.md) | Research methodology, long-form content, academic citations, fact-checking | Whitepapers, research articles, case studies, evidence-based arguments |
| [content-creator](skills/content-creator/SKILL.md) | Marketing copy, social media content, brand voice, ad copy, newsletters | Social media posts, email campaign copy, landing page text, ad copy |

### Verify — Prove it works

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [test-driven-development](skills/test-driven-development/SKILL.md) | Enforces strict RED-GREEN-REFACTOR cycle — no production code without a failing test | Writing any new code, adding features, fixing bugs that require code changes |
| [testing-strategy](skills/testing-strategy/SKILL.md) | Selects test frameworks, defines coverage thresholds, establishes testing patterns per project | New project setup, CI/CD pipeline design, coverage audit, framework migration |
| [systematic-debugging](skills/systematic-debugging/SKILL.md) | 4-phase debugging: observe → hypothesize → experiment → fix, prevents shotgun debugging | Test failures, runtime errors, unexpected behavior, performance regressions |
| [acceptance-testing](skills/acceptance-testing/SKILL.md) | Acceptance-driven backpressure with behavioral validation gates | Spec-to-code validation, feature completion verification, pre-merge acceptance gate |
| [llm-as-judge](skills/llm-as-judge/SKILL.md) | Evaluates subjective quality criteria using structured rubrics (tone, UX feel, readability) | Documentation quality check, error message tone review, design aesthetic review |
| [webapp-testing](skills/webapp-testing/SKILL.md) | Playwright-based E2E testing, screenshot comparison, browser log analysis, a11y audit | E2E test setup, visual regression testing, CI test pipeline |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | 5-step HARD-GATE protocol requiring fresh evidence before claiming completion | Before marking a task done, delivering a feature, or claiming "it's finished" |

### Review — Quality gate before merge

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [code-review](skills/code-review/SKILL.md) | Reviews code against plans and standards, categorizes as Critical/Important/Suggestion | Task completion, before merge, verifying work meets requirements |
| [security-review](skills/security-review/SKILL.md) | OWASP Top 10, auth patterns, input validation, secrets management, dependency audit | Auth implementation, input handling, secrets management, pre-deployment security check |
| [performance-optimization](skills/performance-optimization/SKILL.md) | Profiling, caching strategies, bundle optimization, Web Vitals, database query tuning | Slow page loads, poor Web Vitals, database timeouts, large bundle sizes |

### Deploy — Ship with confidence

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [deployment](skills/deployment/SKILL.md) | CI/CD pipelines, deployment configs, release checklists, environment management | New project needs deployment, migrating CI/CD, adding staging/production |
| [using-git-worktrees](skills/using-git-worktrees/SKILL.md) | Creates isolated Git worktrees for parallel development without interference | Starting a new feature branch, working on multiple tasks without stashing |
| [finishing-a-development-branch](skills/finishing-a-development-branch/SKILL.md) | Structured branch completion: merge, create PR, cleanup, archive | Branch work is done, ready to merge, creating a PR |
| [git-commit-helper](skills/git-commit-helper/SKILL.md) | Conventional commits, semantic versioning, changelog generation | Help with commit messages, version bumping, changelog generation |
| [archive](skills/archive/SKILL.md) | Archives completed features, updates global spec index, pre-archive validation | Feature completion, sprint wrap-up, cleaning up stale spec/plan directories |
| [file-organizer](skills/file-organizer/SKILL.md) | Project structure: monorepo patterns, feature-based architecture, naming conventions, barrel exports | Restructuring projects, setting up monorepos, defining naming conventions |

### Guard — Always-on protection

| Skill | What It Does | Use When |
|-------|-------------|-----------|
| [resilient-execution](skills/resilient-execution/SKILL.md) | Retries with at least 3 genuinely different approaches before giving up | A task fails, an approach doesn't work, or errors are encountered |
| [circuit-breaker](skills/circuit-breaker/SKILL.md) | Detects stalled loops, enforces rate limits, protects config files, manages cooldown recovery | Autonomous loops running, repeated operations, or stagnation patterns detected |
| [auto-improvement](skills/auto-improvement/SKILL.md) | Continuously tracks effectiveness, classifies errors, recognizes patterns, improves workflows | Activates automatically every session — no manual invocation needed |

 
---

## 代理

| Agent | What It Does | Use When |
|-------|-------------|-----------|
| [planner](agents/planner.md) | Creates implementation plans, analyzes architecture, evaluates trade-offs | Multi-step feature work needs a structured plan before coding |
| [code-reviewer](agents/code-reviewer.md) | Reviews code against plans and standards, categorizes Critical/Important/Suggestion | After task completion, before merge, quality verification needed |
| [prd-writer](agents/prd-writer.md) | Generates structured PRDs with user stories and priorities from requirements | Product requirements need formal documentation |
| [doc-generator](agents/doc-generator.md) | Generates API references, architecture docs, READMEs from code | Technical documentation needs generation or updating |
| [spec-reviewer](agents/spec-reviewer.md) | Reviews implementation against spec acceptance criteria for compliance | After implementation, verifying spec compliance |
| [quality-reviewer](agents/quality-reviewer.md) | Reviews code quality, patterns, performance, and security | Code review phase needs comprehensive quality assessment |
| [loop-orchestrator](agents/loop-orchestrator.md) | Manages autonomous dev loops: task selection, exit evaluation, status reporting | Ralph-style iterative development sessions |
| [spec-writer](agents/spec-writer.md) | Generates JTBD behavioral specs with Given/When/Then acceptance criteria | Formal specs needed for a feature |
| [acceptance-judge](agents/acceptance-judge.md) | Evaluates subjective quality via structured scoring rubrics (tone, UX, readability) | LLM-as-judge evaluation pattern needed |
| [frontend-developer](agents/frontend-developer.md) | Three-phase frontend dev: context discovery → component development → test handoff | Frontend feature development, React component implementation |
| [ui-ux-designer](agents/ui-ux-designer.md) | Design system generation, component specs, style guides, color schemes | Building design systems, UI/UX design specs needed |
| [backend-architect](agents/backend-architect.md) | Service boundary design, contract-first API, scalability planning | Backend service architecture design, API contract definition |
| [context-manager](agents/context-manager.md) | Project context tracking, dependency mapping, tech stack documentation | Onboarding to a new project, understanding the full codebase |
| [database-architect](agents/database-architect.md) | Multi-database strategy, data modeling, event sourcing, migration planning | Database architecture design, schema changes |
| [architect-reviewer](agents/architect-reviewer.md) | Architecture review, scalability assessment, technical debt identification | Architecture decision review, system refactoring assessment |
| [typescript-pro](agents/typescript-pro.md) | Advanced TypeScript type patterns, conditional types, branded types | Complex type design, type safety guarantees |
| [task-decomposer](agents/task-decomposer.md) | Hierarchical task breakdown, dependency analysis, parallelization strategy | Complex tasks need WBS decomposition |
| [mobile-developer](agents/mobile-developer.md) | Cross-platform mobile dev, React Native/Flutter/SwiftUI patterns | Mobile app development, platform-specific feature implementation |



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
