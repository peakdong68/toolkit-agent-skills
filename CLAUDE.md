# @pixelandprocess/superkit-agents — 智能体操作手册

> 请参阅 `using-toolkit` 技能以了解身份定义、硬性限制（hard-gates）、工作流状态机及完整命令参考。

---

## 1 技能目录

**核心（6）：** `using-toolkit`、`self-learning` `/learn`、`resilient-execution`、`circuit-breaker`、`auto-improvement`、`verification-before-completion` `/verify`

**流程（9）：** `planning` `/plan`、`brainstorming` `/brainstorm`、`task-management`、`executing-plans` `/execute`、`subagent-driven-development`、`dispatching-parallel-agents`、`autonomous-loop` `/ralph` `/loop`、`ralph-status`、`task-decomposition` `/decompose`

**质量保证/测试（17）：** `code-review` `/review`、`test-driven-development` `/tdd`、`testing-strategy`、`systematic-debugging` `/debug`、`security-review`、`performance-optimization`、`acceptance-testing`、`llm-as-judge`、`senior-frontend` `/frontend`、`senior-backend` `/backend`、`senior-architect` `/architect`、`senior-fullstack` `/fullstack`、`clean-code` `/clean`、`react-best-practices`、`webapp-testing`、`senior-prompt-engineer`、`senior-data-scientist`

**文档（6）：** `prd-generation` `/prd`、`tech-docs-generator` `/docs`、`writing-skills`、`spec-writing` `/specs`、`reverse-engineering-specs`、`archive` `/archive`

**设计（3）：** `api-design`、`frontend-ui-design`、`database-schema-design`

**运维（7）：** `deployment`、`using-git-worktrees` `/worktree`、`finishing-a-development-branch`、`git-commit-helper` `/commit`、`senior-devops` `/devops`、`mcp-builder` `/mcp`、`agent-development` `/agent`

**创意（6）：** `ui-ux-pro-max` `/ui-ux`、`ui-design-system` `/design-system`、`canvas-design`、`mobile-design` `/mobile`、`ux-researcher-designer`、`artifacts-builder`

**商业（3）：** `seo-optimizer` `/seo`、`content-research-writer`、`content-creator`

**文档处理（3）：** `docx-processing`、`pdf-processing`、`xlsx-processing`

**生产力（1）：** `file-organizer`

**沟通（1）：** `email-composer` `/email`


**刚性技能：** 严格遵循。**弹性技能：** 根据上下文灵活调整。

---

## 2 智能体调度表

| 智能体                | 用途                                                 | 调度时机                             | 预期输出                                                |
| -------------------- | ------------------------------------------------------- | -------------------------------------------- | -------------------------------------------------------------- |
| `planner`            | 制定实现计划                             | 在任何多步骤功能开发前           | 包含文件路径和 TDD 步骤的优先级任务列表            |
| `code-reviewer`      | 审查代码质量                                     | 任务完成后、合并前          | 分类问题（严重/重要/建议）及修复方案 |
| `prd-writer`         | 生成产品需求文档（PRD）                                           | 当产品需求需要文档化时 | 结构化的 PRD，包含用户故事、需求（P0/P1/P2）      |
| `doc-generator`      | 生成技术文档                                 | 当代码需要文档时                | API 参考、架构概述、入门指南 |
| `spec-reviewer`      | 验证规范符合度                                  | 实现完成后、审查前          | 合规报告，包含缺口与违规项                     |
| `quality-reviewer`   | 评估代码质量                                     | 审查阶段期间                          | 涵盖模式、性能、安全的质量评估    |
| `loop-orchestrator`  | 管理自主循环                                 | Ralph 风格迭代开发期间     | RALPH_STATUS 区块、任务选择、退出评估           |
| `spec-writer`        | 编写规范                                    | 当功能需要行为规范时          | 包含 Given/When/Then 验收标准的 JTBD 规范            |
| `acceptance-judge`   | 评估主观质量                             | 当客观测试不足时       | 带通过/失败评分及改进建议的评分表       |
| `frontend-developer` | 结合上下文发现的三阶段前端开发         | 前端功能开发                        | 带测试的组件代码                                      |
| `ui-ux-designer`     | 设计系统生成、组件规范               | 设计系统创建                       | 样式指南、组件规范                                  |
| `backend-architect`  | 服务边界、契约优先 API                  | 服务架构                         | API 契约、扩展方案                                    |
| `context-manager`    | 项目上下文跟踪、依赖映射            | 上下文发现                            | 依赖图、技术栈摘要                             |
| `database-architect` | 多数据库策略、事件溯源                       | 数据库设计                              | 架构、迁移脚本、索引                                    |
| `architect-reviewer` | 架构审查、技术债务评估               | 架构决策                       | 架构决策记录（ADR）、可扩展性评估                              |
| `typescript-pro`     | 高级类型模式、品牌类型                   | TypeScript 类型设计                       | 类型定义、工具类型                                |
| `task-decomposer`    | 层级任务拆解                             | 任务规划                                | 任务树、依赖图                                    |
| `mobile-developer`   | 跨平台移动开发模式                          | 移动开发                           | 平台特定代码                                         |
                                           |


---

## 3 RALPH 自主循环协议

### 架构

Ralph 循环是一种受 Geoffrey Huntley 技术启发的迭代开发周期。每次迭代加载相同的上下文，执行一个聚焦的任务，并将状态持久化到磁盘。

### “每次循环仅一个任务”原则

每次迭代从 `IMPLEMENTATION_PLAN.md` 中选取并完成恰好一个任务。这减少了上下文切换，并支持清晰的进度衡量。

### 上下文效率

| 资源            | 预算             | 策略                                  |
| ------------------- | ------------------ | ----------------------------------------- |
| 主上下文窗口 | 40-60% 占用率 | “智能区”——留有充足的思考空间   |
| 读取型子智能体      | 最多 500 个并行 | 通过 `Agent` 工具使用 `subagent_type="Explore"` |
| 构建型子智能体     | 每次 1 个        | 通过 `Agent` 工具使用 `subagent_type="general-purpose"` |
| Token 格式        | 优先使用 Markdown    | 比 JSON 效率高约 30%             |


### 引导机制

**上游引导（塑造输入）：**

- 优先加载详细规范（约 5,000 tokens）
- 每次迭代使用相同的 PROMPT + AGENTS 文件
- 现有代码模式指导新代码生成

**下游引导（验证门槛）：**

- 测试 → 拒绝无效实现
- 构建 → 捕获编译错误
- Linter → 强制执行代码风格一致性
- 类型检查器 → 验证契约
- LLM-as-judge → 评估主观标准

### RALPH_STATUS 区块

**[HARD-GATE:STATUS]** 每次循环迭代结束时必须包含：

```
---RALPH_STATUS---
STATUS: [IN_PROGRESS | COMPLETE | BLOCKED]
TASKS_COMPLETED_THIS_LOOP: [数量]
FILES_MODIFIED: [数量]
TESTS_STATUS: [PASSING | FAILING | NOT_RUN]
WORK_TYPE: [IMPLEMENTATION | TESTING | DOCUMENTATION | REFACTORING]
EXIT_SIGNAL: [false | true]
RECOMMENDATION: [单行下一步行动或完成总结]
---END_RALPH_STATUS---
```

### 双条件退出门槛

**[HARD-GATE:EXIT]** 必须同时满足以下两项条件方可退出：

1. **完成指标** — 近期输出中“完成/done”类表述出现 >= 2 次
2. **明确的 EXIT_SIGNAL** — 状态区块中 `EXIT_SIGNAL: true`

仅当无剩余任务、所有测试通过、无错误且无有意义的工作可做时，EXIT_SIGNAL 才为 true。

### 熔断器阈值

| 条件        | 阈值                              | 动作                  |
| ---------------- | -------------------------------------- | ----------------------- |
| 无进展      | 连续 3 次循环，0 个任务完成 | 触发熔断（OPEN circuit）            |
| 相同错误 | 连续 5 次出现完全相同的错误         | 触发熔断（OPEN circuit）            |
| 输出量下降   | 输出量下降 70%           | 触发熔断（OPEN circuit）            |
| 冷却期         | 30 分钟                             | 熔断后重试前的等待时间 |


### 文件保护

**[HARD-GATE:PROTECT]** 自主操作期间，以下路径绝对禁止删除：

- `.ralph/`、`.ralphrc`、`IMPLEMENTATION_PLAN.md`、`AGENTS.md`
- `.claude/`、`CLAUDE.md`、`specs/`

---

## 4 规范制定方法论

### JTBD → 主题 → 规范 → 故事地图

1. **识别任务（Jobs）：** “当 [情境] 时，我想 [动机]，以便 [结果]。”
2. **拆解为主题：** 应用“单句不含‘和/并且’”测试
3. **编写规范：** 使用 Given/When/Then 验收标准，不包含实现细节
4. **组织：** 以能力 × 发布切片构建故事地图

### 核心准则

**[HARD-GATE:SPEC]** 规范中绝不能包含实现细节：

| 禁止项                   | 允许项                                  |
| --------------------------- | ---------------------------------------- |
| 代码块、函数名 | 行为描述                  |
| 技术选型          | 能力要求                  |
| 算法建议       | 带有可衡量目标的成功标准 |


### 验收标准格式

```markdown
### [标准名称]
- Given [前置条件]
- When [操作]
- Then [可观察的行为结果]
```

### SLC 发布标准

| 标准    | 问题                             |
| ------------ | ------------------------------------ |
| **简单（Simple）**   | 能否以极窄的范围快速发布？  |
| **令人喜爱（Lovable）**  | 用户是否真的愿意使用它？ |
| **完整（Complete）** | 是否完整达成了一项任务？      |

发布必须同时满足以上三项标准。

### 逆向工程（现有项目/棕地）

针对无规范的现有代码库：

1. 详尽追踪每条代码路径、数据流、状态变更
2. 生成剥离实现细节的规范
3. 记录实际行为（缺陷 = “已记录的特性”）
4. 运行完整性检查清单（所有入口点、分支、错误均已记录）

---

## 5 质量与验证协议

### 背压链

```
SPECS ──推导──▶ TESTS ──验证──▶ CODE
  ▲                                       │
  └──────── 背压反馈 ─────────────────┘
  （若测试失败，修复代码——不得修改规范或测试）
```

### 验证门槛（完成前必须全部通过）

| 门槛              | 工具                       | 要求                |
| ----------------- | -------------------------- | ----------------------- |
| 单元测试        | 测试运行器                | 始终必需                  |
| 集成测试 | 测试运行器                | 适用时必需         |
| 验收测试  | 测试运行器（基于规范验收标准） | 始终必需                  |
| 构建             | 构建工具                 | 始终必需                  |
| Lint              | Linter                     | 始终必需                  |
| 类型检查         | 类型检查器               | 适用时必需         |
| LLM-as-judge      | 子智能体评估        | 主观标准必需 |
| 代码审查       | code-reviewer 智能体        | 合并前必需            |


### TDD 红-绿-重构

1. **红（RED）：** 编写定义期望行为的失败测试
2. **绿（GREEN）：** 编写最少量的代码使测试通过
3. **重构（REFACTOR）：** 清理代码，同时保持测试通过

**[HARD-GATE:TDD]** 未先编写失败测试，禁止编写生产代码。

### LLM-as-judge 模式

针对主观标准（语气、美学、UX、可读性）：

1. 定义评分维度及权重（总和为 1.0）
2. 设定锚点（1=最差，5=合格，10=最佳）
3. 设定通过阈值（5.0 最低可行，7.0 生产标准，8.5 卓越标准）
4. 对照评分表评估产出物
5. 打分、说明理由、提出改进建议
6. 对照阈值判定通过/失败

### 代码审查清单

1. **计划对齐** — 代码是否匹配已批准的计划？
2. **代码质量** — 是否整洁、易读、可维护？
3. **架构** — 是否与现有模式一致？
4. **测试** — 覆盖率是否充足？是否包含验收测试？
5. **文档** — 是否在需要时已更新？

问题分类：**严重（必须修复）** | **重要（应当修复）** | **建议（可考虑）**

---

## 6 内存管理协议

### 记忆文件

| 文件                    | 用途        | 更新来源                                     |
| --------------------- | --------- | ---------------------------------------- |
| `project-context.md`  | 技术栈、架构、依赖 | `self-learning`、手动                       |
| `learned-patterns.md` | 编码规范与模式   | `self-learning`、`code-review`            |
| `user-preferences.md` | 沟通与工作流偏好  | `self-learning`、手动                       |
| `decisions-log.md`    | 架构决策及理由   | `planning`、`brainstorming`、`code-review` |


### 自动加载

会话启动时，通过会话启动钩子自动加载记忆文件。它们在不同对话间持久化保存。

### 更新触发条件

- `**/learn`** — 完整项目扫描，填充所有记忆文件
- **用户纠正** — 更新 `learned-patterns.md` 或 `user-preferences.md`
- **架构决策** — 更新 `decisions-log.md`
- **新发现** — 更新 `project-context.md`

### 衰减/清理规则

- 定期审查记忆文件，剔除过时信息
- 移除不再匹配代码库的模式
- 依赖变更时更新技术栈信息
- 决策日志仅追加（作为历史记录）

---

## 7 错误处理与恢复

### 错误分类

| 类型          | 示例                       | 策略                        |
| ------------- | ----------------------------- | ------------------------------- |
| **瞬时/临时** | 网络超时、速率限制   | 指数退避重试              |
| **永久** | 缺失依赖、错误 API | 更换方法                 |
| **未知**   | 意外错误格式       | 调查、分类，再采取行动 |


### 重试策略（resilient-execution）

**[HARD-GATE:RETRY]** 在升级上报前，至少尝试 3 种不同方法：

1. **方法 1：** 直接解决（最明显的修复）
2. **方法 2：** 替代方法（不同技术）
3. **方法 3：** 迂回方案（以不同方式解决底层问题）
4. **升级上报：** 完整汇报上下文——尝试了什么、为何失败

### 熔断器恢复

熔断触发后：

1. 重新生成计划（全新 PLANNING 迭代）
2. 更换方法（尝试替代策略）
3. 缩小范围（将卡住的任务拆分为子任务）
4. 升级上报（报告阻塞供人工审查）

### 清理期间的文件保护

在任何破坏性操作（`rm`、`git clean`、`git checkout .`）前：

1. 检查操作是否针对受保护文件
2. 若是：立即中止并上报
3. 若否：谨慎继续
4. 操作后：验证受保护文件仍然存在

---

## 8 子智能体调度规则

### 如何调度子智能体

所有子智能体调度均使用 **`Agent` 工具**。要并行运行多个智能体，需在**单条消息**中多次调用 `Agent` 工具。

**关键参数：**

| 参数 | 描述 |
|---|---|
| `prompt` | 包含所有必要上下文的详细任务描述 |
| `description` | 简短标签（3-5 个词） |
| `subagent_type` | `"Explore"`（快速搜索代码库）、`"Plan"`（架构规划）、`"general-purpose"`（默认） |
| `run_in_background` | `true` 表示异步——完成时将收到通知 |
| `model` | 可选覆写：`"sonnet"`、`"opus"`、`"haiku"` |

### 何时调度 vs 内联执行

| 场景                                  | 动作                          |
| ----------------------------------------- | ------------------------------- |
| 2 个以上独立任务且无共享状态 | `Agent` 工具 — 单条消息中多次并行调用 |
| 单一聚焦任务                       | 内联执行                       |
| 跨代码库大量读取/搜索   | `Agent` 工具配合 `subagent_type="Explore"` |
| 构建或测试执行                   | `Agent` 工具 — 仅限每次 1 个 |
| 代码审查                               | `Agent` 工具调度 `code-reviewer` 智能体 |
| 质量评估                        | `Agent` 工具调度 `acceptance-judge` 智能体 |


### 并行限制

| 操作              | 最大并行数 | 原理                         |
| ---------------------- | ------------ | --------------------------------- |
| 文件读取/搜索 | 500          | I/O 密集型，可安全并行    |
| 规范审计/更新 | 100          | 独立文件操作       |
| 构建/测试       | 1            | 必须串行以准确捕获失败 |
| 代码审查            | 1            | 需要变更的整体视图    |


### 两阶段审查门槛（subagent-driven-development）

1. **阶段 1：规范审查** — 实现是否匹配规范？
2. **阶段 2：质量审查** — 代码是否符合质量标准？

任务标记完成前，两项门槛必须全部通过。

### 结果聚合

当并行 `Agent` 工具调用返回时：

1. 收集所有结果
2. 检查冲突或矛盾
3. 综合为统一视图
4. 上报任何分歧供人工审查

---

## 9 Git 与分支协议

### 约定式提交（Conventional Commits）

```
<type>(<scope>): <description>

Types: feat, fix, docs, test, refactor, chore, style, perf, ci, build
```

示例：

- `feat(auth): add OAuth2 login flow`
- `fix(api): handle null response from payment gateway`
- `test(user): add acceptance tests for registration`
- `docs(readme): update installation instructions`

### 适配 Ralph 的工作分支

将自主工作限制在功能分支内：

```
git checkout -b ralph/<scope>
```

每个分支拥有独立的 `IMPLEMENTATION_PLAN.md`。仅包含该范围内的任务。

### 分支完结

使用 `finishing-a-development-branch` 技能进行结构化处理：

- 合并至 main/develop
- 创建拉取请求（PR）
- 清理并归档

### 安全规则

- **绝不**跳过钩子（`--no-verify`）
- **绝不**在未获用户明确确认时强制推送
- **绝不**在未获确认时修改已发布的提交
- **始终**使用约定式提交格式
- **始终**在提交信息中包含理由

---

## 10 反模式与预防自我合理化

出现以下想法意味着**立即停止**——你正在找借口（自我合理化）：

| 危险信号想法                            | 正确应对                                                              |
| ------------------------------------------- | ----------------------------------------------------------------------------- |
| “这只是个简单问题”            | 问题即任务。检查可用技能。                                        |
| “我需要先获取更多上下文”                 | 技能检查优先于澄清问题。                                |
| “让我先探索一下代码库”         | 技能会告诉你如何探索。先检查技能。                                  |
| “这不需要正式技能”          | 只要存在对应技能，就必须使用。无例外。                                     |
| “我记得这个技能”                     | 技能会迭代更新。通过 Skill 工具读取最新版本。                           |
| “这个技能小题大做”                     | 简单的事会变复杂。直接使用技能。                                         |
| “我先随便做一件事再说”         | 在执行任何操作前，先检查技能。                                       |
| “这个不需要测试”              | [HARD-GATE:TDD] TDD 不是可选项。先写测试。                    |
| “我稍后再审查”                         | [HARD-GATE:REVIEW] 立即审查。未经审查绝不合并。                       |
| “我可以跳过验证”                   | [HARD-GATE:VERIFY] 验证是强制性的。                                 |
| “循环卡住了，让我跳过这一步”      | 遵循熔断器协议。不要跳过——进行诊断。                              |
| “规范显而易见，我懒得写了” | [HARD-GATE:SPEC] 必须写。遵循 JTBD 方法论。                                  |
| “我肉眼看看质量就行”                 | 使用确定性测试或 LLM-as-judge。绝不凭肉眼主观判断。                       |
| “让我赶紧推送这个快速修复”           | 规划 → TDD → 审查 → 验证。即使是“快速”修复也必须遵循。                         |
| “验收标准是隐含的”      | 将其明确化。使用 Given/When/Then。始终如此。                                  |
| “我写完代码再补测试”                      | RED 必须在 GREEN 之前。始终先写测试。                                          |
| “这个重构不需要测试”          | 若行为改变，测试必须变。若行为不变，现有测试会保护你。 |


---

## 11 FIND-SKILLS 集成

当工具包技能无法覆盖特定需求时：

### 发现

```bash
npx skills find [query]       # 搜索技能生态
```

### 质量验证

| 标准         | 最低要求                                   |
| ----------------- | ----------------------------------------- |
| 周安装量   | 推荐 1,000+                          |
| 来源信誉 | 优先选择 vercel-labs、anthropics、microsoft |
| GitHub 星标      | 仅作参考辅助信号              |


### 安装

```bash
npx skills add <owner/repo@skill> -g -y    # 全局安装
npx skills check                            # 检查更新
npx skills update                           # 更新全部
```

### 何时搜索

- 任务需要 65 项工具包技能未涵盖的领域专业知识
- 用户询问工具包不具备的能力
- 需要专用框架或技术提供针对性指导

---

## 12 文档索引

由工具包技能维护的关键项目文档。这些文件是权威来源——始终以路径引用，而非重复内容。

### 核心索引

| 文档 | 维护者 | 描述 |
|---|---|---|
| `docs/global/index.md` | `archive` 技能 | 全局规范索引——已完成功能和领域规范分组 |

### 技术文档

由 `tech-docs-generator` 技能生成的文档。生成后，在下方添加一行：

| 文档 | 类型 | 描述 |
|---|---|---|
| _示例_ `docs/api-reference.md` | _API 参考_ | _公共 API 接口及签名和示例_ |

### 使用规则

在探索项目时，首先检查此索引。如果此处列出的文件在磁盘上存在，直接阅读——不要重复分析已有文档的代码。当通过 `tech-docs-generator` 生成新文档时，始终更新上方的 `## 技术文档` 表格。当通过 `archive` 归档功能时，确保 `docs/global/index.md` 在上方的 `## 核心索引` 中被引用。

---

