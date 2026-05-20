---
name: writing-skills
description: "在为 Claude Code 创建新 skills、commands 或 agent 定义时使用，包括编写 SKILL.md 文件、定义 triggers 和测试 skill 行为"
---

# Writing Skills

## 概述

创建有效且经过充分测试的 Claude Code skills，确保触发可靠、加载高效并产生一致的结果。本 skill 强制采用 TDD 方法创建 skill —— 先定义测试 prompts，编写最小化 skill，然后加固以防止误触发和 rationalization。

**这是一个 RIGID skill。** 必须严格遵循每一步。不得走捷径。

## 阶段 1：定义测试 Prompts（RED）

**[HARD-GATE]** 在编写任何 skill 内容之前，先定义应该触发该 skill 的 prompts。

编写 3-5 个测试 prompts：

| # | 测试类型 | 目的 | 示例 |
|---|---------|------|------|
| 1 | 明显触发 | 应明确匹配 | "Create a new React component with tests" |
| 2 | 隐晦触发 | 也应当匹配 | "I need a reusable button" |
| 3 | 接近但不匹配 | 不应匹配 | "Review this component code" |
| 4 | 边界情况 | 定义预期行为 | "Create a component and write its docs" |
| 5 | 模糊情况 | 定义哪个 skill 胜出 | "Set up the frontend" |

为每个测试记录预期行为：
```
Test prompt: "Create a new React component with tests"
Expected: 应触发 component-creation skill
Should NOT trigger: testing-strategy, code-review, writing-skills
```

STOP — 在所有测试 prompts 记录完成之前，不得进入阶段 2。

## 阶段 2：编写最小化 SKILL.md（GREEN）

创建能通过阶段 1 所有测试 prompts 的最小 skill 定义。

### 必需结构

每个 SKILL.md **必须**包含以下所有元素：

| 元素 | 必需 | 目的 |
|------|------|------|
| Frontmatter（`name`, `description`） | 是 | 标识和触发匹配 |
| CSO 优化的 description | 是 | 以 "Use when..." 开头，列出触发条件 |
| 概述（2-3 句话） | 是 | 目的和价值 |
| 带 STOP 标记的多阶段流程 | 是 | 编号的阶段及明确操作 |
| 决策表 | 是 | 用于选择不同方法的表格 |
| 反模式/常见错误表 | 是 | "不要做什么" 部分 |
| Anti-rationalization 防护 | 是 | HARD-GATE 或 "Do NOT skip" 标记 |
| 集成点表 | 是 | skill 如何连接到其他 skills |
| 具体示例 | 是 | 代码/命令示例（当不明显时） |
| skill 类型声明 | 是 | 末尾标明 RIGID 或 FLEXIBLE |

### Frontmatter 规则

```yaml
---
name: skill-name          # 小写字母加连字符，唯一标识符
description: "Use when [触发条件]"  # 最大 1024 字符
---
```

**[HARD-GATE]** `description` 字段**必须**以 "Use when" 开头。

### CSO（Claude Search Optimization）规则

`description` 字段决定 skill 何时被选中。像搜索查询一样优化它。

| 规则 | 说明 |
|------|------|
| 以 "Use when..." 开头 | 触发条件格式 |
| 列出具体条件，而非能力 | 什么会激活该 skill，而非它教什么 |
| 最大 1024 字符 | 简洁 |
| 使用动作动词 | "creating", "debugging", "designing", "reviewing" |

**正确示例：**
```yaml
description: "Use when creating database migrations, designing table schemas, adding indexes, or optimizing SQL queries"
```

**错误示例：**
```yaml
description: "A comprehensive guide to database design covering normalization, indexing, query optimization, and migration strategies"
```

### 触发条件模式

| 模式 | 格式 | 示例 |
|------|------|------|
| 基于动作 | "Use when creating..., updating..., deleting..." | CRUD 操作 |
| 基于问题 | "Use when debugging..., fixing..., resolving..." | 错误修复 |
| 基于产物 | "Use when working with Docker files, CI configs..." | 文件类型 |
| 基于阶段 | "Use when starting a project, finishing a feature..." | 工作流阶段 |

STOP — 在继续之前，验证 description 能够匹配阶段 1 的测试 prompts。

## 阶段 3：加固 Skill（REFACTOR）

审查并堵住漏洞：

| 检查项 | 问题 | 失败时的修复 |
|--------|------|-------------|
| 过度触发 | 是否匹配了不应匹配的 prompts？ | 缩小 description 范围 |
| 触发不足 | 是否遗漏了有效的 prompts？ | 添加缺失的触发条件 |
| Rationalization | agent 是否会想办法跳过步骤？ | 添加 "Do NOT skip" 约束 |
| 歧义性 | 指令是否有多种理解方式？ | 用具体示例使其明确 |
| Token 膨胀 | 是否超过 500 行？ | 将参考资料移至单独文件 |
| 缺少关卡 | 阶段之间是否有检查点？ | 添加 STOP 标记 |

### Token 效率目标

| Skill 类型 | 目标行数 | 策略 |
|------------|----------|------|
| 入门工作流 | < 100 行 | 最小化步骤 |
| 频繁加载的 skills | < 200 行 | 用表格代替散文 |
| 综合参考 skills | < 400 行 | 拆分为多个阶段 |
| 最大允许 | 500 行 | 将额外内容移至单独文件 |

### Token 精简策略

- 使用表格而非散文呈现结构化信息
- 使用简洁的祈使句，而非解释性段落
- 将参考资料移至单独文件（仅在需要时加载）
- 消除冗余 — 说一次就够了
- 仅当模式不明显时才使用代码示例

STOP — 在脑中重新运行测试 prompts。该 skill 是否对所有 5 个测试都能正确触发？是否对接近但不匹配的情况不触发？

## 阶段 4：验证并保存

1. 验证阶段 2 中的全部 10 个必需元素都存在
2. 验证 token 预算在目标范围内
3. 验证阶段之间有 STOP 标记
4. 保存 SKILL.md 文件
5. 用每个测试 prompt 调用 skill 进行测试

### 验证清单

| # | 检查项 | 状态 |
|---|-------|------|
| 1 | Frontmatter 包含 `name` 和 `description` | [ ] |
| 2 | description 以 "Use when" 开头 | [ ] |
| 3 | 概述为 2-3 句话 | [ ] |
| 4 | 阶段有编号并带 STOP 标记 | [ ] |
| 5 | 存在决策表（不是散文） | [ ] |
| 6 | 存在反模式表 | [ ] |
| 7 | 存在 anti-rationalization 防护 | [ ] |
| 8 | 存在集成点表 | [ ] |
| 9 | 存在具体示例 | [ ] |
| 10 | 声明了 skill 类型（RIGID/FLEXIBLE） | [ ] |
| 11 | 总行数低于 500 | [ ] |

## Skill 类型与测试

### 按 skill 类型的测试方法

| Skill 类型 | 测试方法 | 验证内容 |
|------------|----------|----------|
| **Technique**（TDD, debugging） | 应用于问题 X 和异常问题 Y | 产生正确步骤；正确适应 |
| **Pattern**（design patterns） | 展示代码 X（匹配）和代码 Y（接近但不匹配） | 正确识别；正确拒绝 |
| **Reference**（API docs, checklists） | 问 "X 的规则是什么？" 和 "边界情况 Z 呢？" | 找到正确答案；处理空白 |
| **Discipline**（security review） | 审查正确代码，然后在时间压力下审查 | 通过干净代码；即使在压力下也强制执行所有规则 |

## 反模式 / 常见错误

| 错误 | 为什么错误 | 正确做法 |
|------|-----------|----------|
| description 描述内容而非触发条件 | skill 永远不会被选中 | 以 "Use when..." 开头并列出触发条件 |
| 过于宽泛 — 什么都触发 | 对什么都无用 | 缩小到特定动作和产物 |
| 过长 — 1000+ 行 | 每次调用都浪费 context tokens | 控制在 500 行以下；拆分参考资料 |
| 缺少约束 | agent 会理性化地跳过步骤 | 添加 "Do NOT" 规则和 HARD-GATE 标记 |
| 未用真实 prompts 测试 | 生产环境中会误触发 | 在编写 skill 之前先写测试 prompts |
| 依赖外部文件 | 脆弱 — 文件可能不存在 | 自包含或先检查文件是否存在 |
| 能用表格的地方用了散文 | 更难扫描，消耗更多 tokens | 结构化比较用表格 |
| 阶段之间没有 STOP 标记 | agent 会无检查点地冲过去 | 每个阶段后加 STOP |

## Anti-Rationalization 防护

- **[HARD-GATE]** 未先定义测试 prompts（阶段 1）时，不得编写 skill
- **[HARD-GATE]** 不得省略 description 字段或使用非 "Use when" 格式
- **Do NOT skip** 加固阶段 — 每个 skill 都需要 rationalization 审查
- **Do NOT skip** 验证清单 — 全部 11 项必须通过
- **Do NOT** 创建超过 500 行的 skill — 拆分为 skill + 参考文件
- **Do NOT** 在表格更清晰的地方使用散文

## 集成点

| Skill | 关系 |
|-------|------|
| `self-learning` | Skills 通过 skill 系统被发现和加载 |
| `auto-improvement` | 跟踪 skill 效果并提出改进建议 |
| `spec-writing` | Skills 可使用 JTBD 方法论进行规范 |
| `code-review` | Skills 在部署前应进行质量审查 |
| `testing-strategy` | 测试 prompts 遵循测试方法论 |

## 具体示例：完整的最小化 Skill

```markdown
---
name: docker-setup
description: "Use when creating Dockerfiles, docker-compose configurations, or containerizing an application for development or production"
---

# Docker Setup

## 概述

指导为开发和生产环境创建 Docker 配置。生成遵循最佳实践的 Dockerfiles、docker-compose 文件和 .dockerignore。

## 阶段 1：发现
[询问：runtime, ports, volumes, env vars, multi-stage 需求]
STOP — 确认需求。

## 阶段 2：生成配置
[创建 Dockerfile, docker-compose.yml, .dockerignore]
STOP — 提交审查。

## 阶段 3：验证
[构建镜像，运行容器，验证 health check]

## 反模式
| 错误 | 修复 |
|------|------|
| 以 root 身份运行 | 使用非 root USER |
| 没有 .dockerignore | 始终创建一个 |

## Skill 类型
**Flexible**
```

## Skill 类型

**Rigid** — TDD 方法（先写测试 prompts）、必需的结构元素和验证清单必须严格遵循。不得跳过任何元素。