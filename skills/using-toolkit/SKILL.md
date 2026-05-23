---
name: using-toolkit
description: 在开始任何对话、接收新任务或不确定哪个 skill 适用时使用 —— 建立如何查找和使用全部 64 个 toolkit skills 的方法，要求在任何回复（包括澄清性问题）之前必须先调用 Skill 工具
---

<SUBAGENT-STOP>
如果你是被派遣作为子代理（subagent）来执行特定任务的，请跳过此技能。
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
如果你认为某个 skill 有哪怕 1% 的可能适用于当前任务，你也必须调用该 skill。

如果某个 skill 适用于你的任务，你没有选择。你必须使用它。

这一点没有商量余地。这不是可选项。你不能通过任何理性分析来绕过此规则。
</EXTREMELY-IMPORTANT>

## 概述

全部 64 个 toolkit skills 的主目录和调度系统。确保在对话开始时正确识别 skill。

## 如何访问 Skills

**在 Claude Code 中：** 使用 `Skill` 工具。当你调用一个 skill 时，其内容会被加载并呈现给你 —— 直接遵循其中的指引。绝不要使用 Read 工具读取 skill 文件。

---

## 阶段 1：Skill 识别

在任何操作之前：扫描目录，识别所有匹配的 skills（哪怕是 1% 的相关性），通过 Skill 工具调用它们。

---

## 阶段 2：Skill 优先级排序

按顺序调用：(1) Process（brainstorming, planning）→ (2) Specialist（frontend, backend, architect）→ (3) Quality（TDD, review）→ (4) Docs → (5) Design → (6) Ops → (7) Terminal（verification）。

---

## 阶段 3：Skill 执行

**刚性 skills（Rigid skills）：** 严格遵循。**柔性 skills（Flexible skills）：** 根据上下文调整。在声称完成之前，必须调用 `verification-before-completion`。

---

## 可用 Skills（共 64 个）

### 核心 Skills（6 个）

| Skill                            | 使用场景                               |
| -------------------------------- | -------------------------------------- |
| `using-toolkit`                  | 会话开始时 —— 建立 skill 使用规范      |
| `self-learning`                  | 开始处理不熟悉的项目，或被纠正时       |
| `resilient-execution`            | 当某种方法失败时 —— 确保用替代方案重试 |
| `circuit-breaker`                | 自主循环、重复操作、停滞检测           |
| `auto-improvement`               | 自我改进系统，追踪有效性，从错误中学习 |
| `verification-before-completion` | 在声称任何任务完成之前                 |

### 过程与工作流 Skills（9 个）

| Skill                         | 使用场景                                   |
| ----------------------------- | ------------------------------------------ |
| `planning`                    | 在任何实现之前 —— 强制结构化规划           |
| `brainstorming`               | 在创造性工作之前 —— 探索想法、功能、设计   |
| `task-management`             | 在实现过程中将工作拆解为可追踪的步骤       |
| `executing-plans`             | 逐步执行已批准的规划文档                   |
| `subagent-driven-development` | 多任务执行，包含两阶段评审关口             |
| `dispatching-parallel-agents` | 同时运行多个独立任务                       |
| `autonomous-loop`             | Ralph 风格的迭代自主开发循环               |
| `ralph-status`                | 在每个自主循环迭代结束时 —— 结构化进度报告 |
| `task-decomposition`          | 层次化任务拆解、依赖关系映射、并行化       |

### 质量保证 Skills（17 个）

| Skill                      | 使用场景                                          |
| -------------------------- | ------------------------------------------------- |
| `code-review`              | 完成任务后、提交之前                              |
| `test-driven-development`  | 编写任何新代码（RED-GREEN-REFACTOR）              |
| `systematic-debugging`     | 调查 bug、错误、意外行为                          |
| `testing-strategy`         | 为项目选择测试方法                                |
| `security-review`          | 审查漏洞、认证、输入验证                          |
| `performance-optimization` | 优化速度、减少加载时间                            |
| `acceptance-testing`       | 验证实现是否符合规格的验收标准                    |
| `llm-as-judge`             | 评估主观质量（语气、UX、可读性、美观度）          |
| `senior-frontend`          | React/Next.js/TypeScript 专家，测试覆盖率 >85%    |
| `senior-backend`           | API 设计、微服务、事件驱动架构                    |
| `senior-architect`         | 系统设计、可扩展性、权衡分析、ADR                 |
| `senior-fullstack`         | 全栈端到端开发                                    |
| `clean-code`               | SOLID、DRY、代码坏味、重构模式                    |
| `react-best-practices`     | React hooks、context、suspense、server components |
| `webapp-testing`           | 基于 Playwright 的 Web 测试、截图、浏览器日志     |
| `senior-prompt-engineer`   | Prompt 设计、优化、chain-of-thought               |
| `senior-data-scientist`    | 机器学习流水线、统计分析、实验设计                |

### 文档 Skills（5 个）

| Skill                       | 使用场景                                |
| --------------------------- | --------------------------------------- |
| `prd-generation`            | 生成产品需求文档                        |
| `tech-docs-generator`       | 生成或更新技术文档                      |
| `writing-skills`            | 创建新的 skills、commands 或 agent 定义 |
| `spec-writing`              | 使用 JTBD 方法论和验收标准编写规格说明  |
| `reverse-engineering-specs` | 从现有代码库生成无实现细节的规格说明    |

### 设计 Skills（3 个）

| Skill                    | 使用场景                       |
| ------------------------ | ------------------------------ |
| `api-design`             | 设计 API 端点并生成规格说明    |
| `frontend-ui-design`     | 组件架构、响应式设计、可访问性 |
| `database-schema-design` | 数据建模、迁移、索引           |

### 运维 Skills（7 个）

| Skill                            | 使用场景                                           |
| -------------------------------- | -------------------------------------------------- |
| `deployment`                     | 设置 CI/CD 流水线和部署检查清单                    |
| `using-git-worktrees`            | 创建隔离的开发环境                                 |
| `finishing-a-development-branch` | 完成分支上的工作、准备合并                         |
| `git-commit-helper`              | 约定式提交、语义化版本、变更日志                   |
| `senior-devops`                  | CI/CD、Docker、Kubernetes、基础设施即代码          |
| `mcp-builder`                    | MCP 服务器开发、tools、resources、transport layers |
| `agent-development`              | 构建 AI agents、tool use、记忆、规划               |

### 创意 Skills（6 个）

| Skill                    | 使用场景                                                   |
| ------------------------ | ---------------------------------------------------------- |
| `ui-ux-pro-max`          | 完整的 UI/UX 设计智能体系，包含样式、调色板、字体、UX 指南 |
| `ui-design-system`       | 设计令牌、组件库、Tailwind CSS、响应式模式                 |
| `canvas-design`          | HTML Canvas、SVG、数据可视化、生成艺术                     |
| `mobile-design`          | React Native、Flutter、SwiftUI、平台 HIG 合规性            |
| `ux-researcher-designer` | 用户研究、人物画像、旅程地图、可用性测试                   |
| `artifacts-builder`      | 生成独立的 artifacts、交互式演示、原型                     |

### 业务 Skills（3 个）

| Skill                     | 使用场景                                         |
| ------------------------- | ------------------------------------------------ |
| `seo-optimizer`           | 技术 SEO、meta 标签、结构化数据、Core Web Vitals |
| `content-research-writer` | 研究方法论、长文内容、引用                       |
| `content-creator`         | 营销文案、社交媒体、品牌语调                     |

### 文档处理 Skills（3 个）

| Skill             | 使用场景                           |
| ----------------- | ---------------------------------- |
| `docx-processing` | Word 文档生成、模板填充            |
| `pdf-processing`  | PDF 生成、表单填充、OCR、合并/拆分 |
| `xlsx-processing` | Excel 操作、公式、图表             |

### 生产力 Skills（1 个）

| Skill            | 使用场景                     |
| ---------------- | ---------------------------- |
| `file-organizer` | 项目结构、文件命名、目录架构 |

---

## 决策表：选择合适的 Skill

| 用户请求包含                         | 主要 Skill                                               | 辅助 Skills                                  |
| ------------------------------------ | -------------------------------------------------------- | -------------------------------------------- |
| "构建"、"实现"、"创建功能"           | `planning`                                               | `brainstorming`、`tdd`、`code-review`        |
| "修复"、"bug"、"错误"、"坏了"        | `systematic-debugging`                                   | `tdd`、`resilient-execution`                 |
| "测试"、"覆盖率"、"规格"             | `test-driven-development`                                | `testing-strategy`、`acceptance-testing`     |
| "评审"、"检查"、"审计"               | `code-review`                                            | `security-review`、`clean-code`              |
| "规划"、"我们应该如何"               | `planning`                                               | `brainstorming`、`task-decomposition`        |
| "部署"、"CI/CD"、"流水线"            | `deployment`                                             | `senior-devops`                              |
| "API"、"endpoint"、"REST"、"GraphQL" | `api-design`                                             | `senior-backend`                             |
| "React"、"Next.js"、"组件"           | `senior-frontend`                                        | `react-best-practices`、`frontend-ui-design` |
| "数据库"、"schema"、"迁移"           | `database-schema-design`                                 | `senior-backend`                             |
| "设计"、"UI"、"UX"                   | `ui-ux-pro-max`                                          | `ui-design-system`、`frontend-ui-design`     |
| "移动端"、"iOS"、"Android"           | `mobile-design`                                          | `ui-ux-pro-max`                              |
| "文档"、"docs"、"README"             | `tech-docs-generator`                                    | `prd-generation`                             |
| "规格"、"需求"、"PRD"                | `spec-writing`                                           | `prd-generation`                             |
| "自主"、"循环"、"ralph"              | `autonomous-loop`                                        | `ralph-status`、`circuit-breaker`            |
| "安全"、"漏洞"、"认证"               | `security-review`                                        | `senior-backend`                             |
| "SEO"、"meta 标签"、"搜索引擎"       | `seo-optimizer`                                          | `content-research-writer`                    |
| "PDF"、"Word"、"Excel"               | `pdf-processing` / `docx-processing` / `xlsx-processing` | —                                            |
| "agent"、"AI"、"tool use"            | `agent-development`                                      | `mcp-builder`                                |
| "MCP"、"服务器"、"transport"         | `mcp-builder`                                            | `agent-development`                          |

---

## 工作流模式

| 模式                 | Skill 链                                                                    |
| -------------------- | --------------------------------------------------------------------------- |
| "构建功能 X"         | brainstorming -> planning -> executing-plans -> code-review -> verification |
| "修复 bug Y"         | systematic-debugging -> TDD -> code-review -> verification                  |
| "编写新代码"         | test-driven-development（始终）                                             |
| "自主运行"           | autonomous-loop -> ralph-status -> circuit-breaker                          |
| "编写规格说明"       | spec-writing（JTBD 方法论）                                                 |
| "理解遗留代码"       | reverse-engineering-specs -> spec-writing（审计）                           |
| "检查验收标准"       | acceptance-testing（backpressure 链）                                       |
| "验证主观质量"       | llm-as-judge（基于量规的评估）                                              |
| "为 API 编写文档"    | tech-docs-generator 或 api-design                                           |
| "为 X 创建 PRD"      | prd-generation                                                              |
| "设置 CI/CD"         | deployment                                                                  |
| "我们应该如何测试？" | testing-strategy                                                            |
| "设计数据库"         | database-schema-design                                                      |
| "构建 UI 组件"       | frontend-ui-design                                                          |
| "检查安全问题"       | security-review                                                             |
| "让它更快"           | performance-optimization                                                    |
| "此分支已完成"       | finishing-a-development-branch                                              |
| "设计 UI"            | ui-ux-pro-max -> ui-design-system -> frontend-ui-design                     |
| "构建移动应用"       | mobile-design -> planning -> tdd                                            |
| "优化 SEO"           | seo-optimizer                                                               |
| "撰写营销文案"       | content-creator                                                             |
| "处理文档"           | docx-processing / pdf-processing / xlsx-processing                          |
| "构建 AI agent"      | agent-development -> planning -> tdd                                        |
| "设置基础设施"       | senior-devops -> deployment                                                 |
| "拆解复杂任务"       | task-decomposition -> dispatching-parallel-agents                           |

---

## 反模式

- 绝不要因为任务"简单"就跳过 skill 检查 —— 始终检查目录
- 绝不要凭记忆调用 skills —— 使用 Skill 工具获取当前版本
- 绝不要使用 Read 工具读取 skill 文件 —— 使用 Skill 工具
- 绝不要跳过验证 —— 始终最后调用 `verification-before-completion`
- 绝不在检查 skills 之前回复 —— skill 检查永远是第一步

---

## 防理性分析守卫

如果你开始想"这很简单 / 我需要先了解上下文 / 让我先探索一下 / 这不需要 skill / 我记得这个 skill / 这个 skill 大材小用了 / 我先做一件事" —— 停下来。优先检查 skills。没有例外。

---

## 集成点

关键集成：`self-learning`（项目上下文）、`verification-before-completion`（终端检查点）、`circuit-breaker`（停滞安全）、`auto-improvement`（有效性追踪）、`planning`（最常见的首要 skill）、`resilient-execution`（故障恢复）。

---

## 核心规则

编码前先规划。始终 TDD。用证据验证完成情况。合并前先评审。使用 subagents 进行并行工作。持续自我学习。尝试 3 种方法后再升级。在循环中报告 RALPH_STATUS。保护配置文件。用验收标准编写规格说明。

---

## Skill 类型

**刚性（Rigid）**（TDD、debugging、planning、verification、code-review、autonomous-loop、circuit-breaker、spec-writing、acceptance-testing）：严格遵循。
**柔性（Flexible）**（brainstorming、tech-docs、api-design、frontend、database、performance、security-review、prd-generation）：根据上下文调整。

---

## 查找缺失的 Skills

`npx skills find [query]` 搜索，`npx skills add <owner/repo@skill> -g -y` 安装。优先选择周安装量超过 1K 且来自可信来源的 skills。

---

## Skill 类型

**刚性（RIGID）** —— Skill 检查是强制性的。每个任务都以目录扫描开始。没有例外。没有理性分析。
