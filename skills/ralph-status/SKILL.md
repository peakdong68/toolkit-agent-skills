---
name: ralph-status
description: "用于在自主循环迭代中报告进度。在每次自主循环迭代结束时、当 autonomous-loop 技能完成 BUILD 阶段、当监控或退出评估需要进度报告时，或当生成带有退出信号协议的机器可解析 RALPH_STATUS 块时触发。"
---

# Ralph 状态报告

## 概述

Ralph 状态块是一个结构化的、机器可解析的进度报告，包含在每次自主循环迭代的末尾。它支持自动化监控、退出检测和进度跟踪。该格式是严格的，必须精确遵循——机器解析依赖于一致的结构。

**起始声明：**“正在为本次迭代生成 RALPH_STATUS 块。”

## 触发条件

- 每次自主循环迭代结束时（强制）
- 自主循环中的 BUILD 阶段完成后
- 当监控系统需要进度数据时
- 当需要进行退出门限评估时
- 当 `autonomous-loop` 技能调用此技能时

---

## 阶段 1：数据收集

**目标：** 收集状态块所需的所有指标。

1. 统计本次迭代中已完成的任务数
2. 统计修改的文件数（创建、编辑、删除）
3. 运行测试套件并记录结果
4. 确定主要工作类型
5. 检查是否存在阻碍或问题

### 指标收集表

| 指标 | 确定方法 | 示例 |
|--------|-----------------|---------|
| TASKS_COMPLETED_THIS_LOOP | 统计本次迭代中标记为完成的任务数 | 1 |
| FILES_MODIFIED | 通过 git diff 或跟踪统计更改的文件数 | 3 |
| TESTS_STATUS | 运行测试套件，记录总体结果 | PASSING |
| WORK_TYPE | 对主要活动进行分类 | IMPLEMENTATION |
| 阻碍因素 | 检查是否有任务无法继续推进 | 无 |

### 工作类型分类

| 工作类型 | 适用场景 |
|-----------|-----------|
| IMPLEMENTATION | 编写新代码（功能、端点、服务） |
| TESTING | 主要活动是编写或修复测试 |
| DOCUMENTATION | 主要活动是文档、规范或注释 |
| REFACTORING | 主要活动是重构（不改变行为） |

**暂停 — 在满足以下条件前，切勿进入阶段 2：**
- [ ] 已收集所有指标
- [ ] 已实际运行测试套件（非假设）
- [ ] 已确定工作类型

---

## 阶段 2：STATUS 评估

**目标：** 根据迭代结果确定正确的 STATUS 值。

### STATUS 决策表

| 条件 | STATUS 值 | EXIT_SIGNAL |
|-----------|-------------|-------------|
| 仍有任务剩余，但本次迭代已完成工作 | IN_PROGRESS | false |
| 仍有任务剩余，未完成工作（处于调查阶段） | IN_PROGRESS | false |
| 无法继续，需要外部输入 | BLOCKED | false |
| 所有任务完成，所有测试通过 | COMPLETE | 评估阶段 3 |
| 所有任务完成，但测试失败 | IN_PROGRESS | false |

### STATUS 值定义

| 值 | 含义 | 循环动作 |
|-------|---------|------------|
| IN_PROGRESS | 工作仍在进行，仍有任务剩余或测试失败 | 继续循环 |
| COMPLETE | 所有计划工作已完成，测试通过 | 评估退出门限 |
| BLOCKED | 无外部输入无法继续 | 暂停并报告 |

### 当处于 BLOCKED 状态时

1. 在 RECOMMENDATION 中清晰描述阻碍进展的原因
2. 设置 `EXIT_SIGNAL: false`（阻塞不等于完成）
3. 若阻塞状态跨迭代持续存在，熔断器可能会触发

**暂停 — 在满足以下条件前，切勿进入阶段 3：**
- [ ] 已确定 STATUS 值
- [ ] 若为 BLOCKED，已清晰描述阻碍因素

---

## 阶段 3：EXIT_SIGNAL 评估

**目标：** 确定 EXIT_SIGNAL 应为 true 还是 false。

<HARD-GATE>
仅当同时满足以下所有条件时，EXIT_SIGNAL 才可为 `true`：
</HARD-GATE>

| 条件 | 验证方法 | 必需 |
|-----------|--------------|----------|
| 无剩余任务 | IMPLEMENTATION_PLAN.md 中无未勾选项 | 是 |
| 所有测试通过 | TESTS_STATUS 为 PASSING | 是 |
| 最新迭代无错误 | 执行干净，无未解决的异常 | 是 |
| 无有意义的剩余工作 | 无待办事项，无未完成功能，代码审查已完成 | 是 |

### EXIT_SIGNAL 决策表

| 任务剩余 | 测试状态 | 错误 | 有意义的剩余工作 | EXIT_SIGNAL |
|----------------|-------------|--------|----------------|-------------|
| 是 | 任意 | 任意 | 任意 | false |
| 否 | FAILING | 任意 | 任意 | false |
| 否 | PASSING | 是 | 任意 | false |
| 否 | PASSING | 否 | 是 | false |
| 否 | PASSING | 否 | 否 | **true** |

### 双条件退出门限

循环编排器使用两个独立的信号来确认退出：

1. **启发式检测：** 完成性语言（“全部完成”、“一切通过”、“无剩余工作”）在最近输出中出现 >= 2 次
2. **显式声明：** 状态块中包含 `EXIT_SIGNAL: true`

两者必须同时为真。这用于防止：
- 随意使用完成性语言导致的误报
- Claude 声称“完成”但仍在高效工作时导致的过早退出

**暂停 — 除非已验证全部四个条件，否则切勿将 EXIT_SIGNAL 设为 true。**

---

## 阶段 4：块生成

**目标：** 以精确格式编写 RALPH_STATUS 块。

<HARD-GATE>
每次循环迭代必须以该精确格式结束。不得有任何变体。不得添加额外字段。不得遗漏字段。
</HARD-GATE>

### 必需格式

```
---RALPH_STATUS---
STATUS: [IN_PROGRESS | COMPLETE | BLOCKED]
TASKS_COMPLETED_THIS_LOOP: [number]
FILES_MODIFIED: [number]
TESTS_STATUS: [PASSING | FAILING | NOT_RUN]
WORK_TYPE: [IMPLEMENTATION | TESTING | DOCUMENTATION | REFACTORING]
EXIT_SIGNAL: [false | true]
RECOMMENDATION: [one-line summary of next action or completion state]
---END_RALPH_STATUS---
```

### 字段规范

| 字段 | 类型 | 允许值 | 描述 |
|-------|------|---------------|-------------|
| STATUS | 枚举 | IN_PROGRESS, COMPLETE, BLOCKED | 当前迭代结果 |
| TASKS_COMPLETED_THIS_LOOP | 整数 | 0+ | 本次迭代完成的任务数 |
| FILES_MODIFIED | 整数 | 0+ | 更改的文件数（创建、编辑、删除） |
| TESTS_STATUS | 枚举 | PASSING, FAILING, NOT_RUN | 本次迭代后测试套件的状态 |
| WORK_TYPE | 枚举 | IMPLEMENTATION, TESTING, DOCUMENTATION, REFACTORING | 主要活动类别 |
| EXIT_SIGNAL | 布尔值 | false, true | 所有工作是否已完成 |
| RECOMMENDATION | 字符串 | 自由文本（仅限一行） | 下一步操作或最终总结 |

### RECOMMENDATION 编写指南

| STATUS | RECOMMENDATION 内容 |
|--------|----------------------|
| IN_PROGRESS | “下一步：[具体的下一个任务]” |
| COMPLETE | “所有任务已完成，测试通过，[总结]” |
| BLOCKED | “受阻：[具体的阻碍描述]” |

---

## 阶段 5：验证

**目标：** 在输出前验证状态块是否正确。

### 验证检查

| 检查项 | 规则 | 违反后果 |
|-------|------|------------|
| 格式精确 | 与模板逐字符匹配（除值外） | 重写块 |
| STATUS 一致性 | COMPLETE 要求评估 EXIT_SIGNAL | 修正 STATUS 或 EXIT_SIGNAL |
| TESTS_STATUS 符合实际 | 值与实际测试运行结果匹配 | 重新运行测试 |
| EXIT_SIGNAL 合理 | 仅当满足全部 4 个条件时为 true | 设为 false |
| 存在 RECOMMENDATION | 非空，仅一行 | 添加建议 |
| 无额外字段 | 仅包含定义的 7 个字段 | 移除额外内容 |

---

## 反模式 / 常见错误

| 反模式 | 失败原因 | 正确做法 |
|-------------|-------------|-----------------|
| 遗漏状态块 | 循环无法评估退出，监控失明 | 每次迭代均以状态块结束 |
| 测试失败时仍将 EXIT_SIGNAL 设为 true | 过早退出，代码损坏 | 验证全部 4 个条件 |
| 添加自定义字段 | 机器解析中断 | 仅使用定义的 7 个字段 |
| 多行 RECOMMENDATION | 换行会导致解析中断 | 仅限一行 |
| 未运行测试即填写 TESTS_STATUS | 产生虚假信心 | 实际运行测试套件 |
| 仍有任务剩余却标记 STATUS: COMPLETE | 信号矛盾 | 检查 IMPLEMENTATION_PLAN.md |
| 跳过 RECOMMENDATION | 缺乏对下一次迭代的指导 | 始终包含可操作的建议 |
| 处于 BLOCKED 时设置 EXIT_SIGNAL: true | 矛盾——阻塞不等于完成 | BLOCKED 始终对应 EXIT_SIGNAL: false |
| 更改分隔符格式 | 机器解析依赖精确的分隔符 | 严格使用 ---RALPH_STATUS--- |
| 猜测 FILES_MODIFIED | 指标不准确 | 统计实际更改数 |

---

## 反合理化防御

<HARD-GATE>
切勿跳过状态块。除非已验证全部四个条件，否则切勿将 EXIT_SIGNAL 设为 true。切勿修改块格式。机器解析依赖于精确、一致的结构。
</HARD-GATE>

如果你发现自己有以下想法：
- “状态块只是额外开销……”——它是退出门限机制。绝不可跳过。
- “所有事都做完了，EXIT_SIGNAL: true……”——先验证全部四个条件。
- “我加个额外字段来提供更多细节……”——不行。使用 RECOMMENDATION 记录细节。
- “测试大概通过了，TESTS_STATUS: PASSING……”——运行它们。验证。然后再报告。

---

## 集成点

| 技能 | 关系 | 时机 |
|-------|-------------|------|
| `autonomous-loop` | 父级——在每次迭代结束时调用此技能 | 每次迭代 |
| `circuit-breaker` | 消费者——监控停滞模式 | 读取状态块 |
| `verification-before-completion` | 上游——提供测试结果 | 状态块生成前 |
| 监控仪表盘 | 消费者——显示实时进度 | 读取状态块 |
| 日志聚合 | 消费者——历史性能分析 | 存储状态块 |

---

## 具体示例

### 示例：典型的 IN_PROGRESS 状态

```
---RALPH_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 3
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
RECOMMENDATION: Next: implement user authentication middleware
---END_RALPH_STATUS---
```

### 示例：完成状态

```
---RALPH_STATUS---
STATUS: COMPLETE
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 2
TESTS_STATUS: PASSING
WORK_TYPE: DOCUMENTATION
EXIT_SIGNAL: true
RECOMMENDATION: All tasks complete, tests passing, documentation updated
---END_RALPH_STATUS---
```

### 示例：受阻状态

```
---RALPH_STATUS---
STATUS: BLOCKED
TASKS_COMPLETED_THIS_LOOP: 0
FILES_MODIFIED: 0
TESTS_STATUS: PASSING
WORK_TYPE: IMPLEMENTATION
EXIT_SIGNAL: false
RECOMMENDATION: Blocked: need database credentials for integration test setup
---END_RALPH_STATUS---
```

### 示例：测试失败状态

```
---RALPH_STATUS---
STATUS: IN_PROGRESS
TASKS_COMPLETED_THIS_LOOP: 1
FILES_MODIFIED: 4
TESTS_STATUS: FAILING
WORK_TYPE: TESTING
EXIT_SIGNAL: false
RECOMMENDATION: 3 tests failing in auth module — investigating root cause next iteration
---END_RALPH_STATUS---
```

---

## 流程总结

1. 完成迭代工作（实现、测试、文档或重构）
2. 统计已完成任务和修改的文件
3. 运行测试套件并记录结果
4. 评估 STATUS 值
5. 评估 EXIT_SIGNAL 条件（全部 4 项满足才可为 `true`）
6. 以精确格式编写 RALPH_STATUS 块
7. 包含清晰、可操作的 RECOMMENDATION

---

## 技能类型

**严格模式**——状态块格式必须精确遵循。机器解析依赖于一致的结构。不得添加字段，不得更改格式，不得跳过块。