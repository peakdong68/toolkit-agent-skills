---
name: archive
description: '当归档已完成功能、将已完成工作移至 docs/archive/、更新全局规范索引或运行 /archive 命令时使用。在功能完成、迭代收尾、清理过期规范/计划目录或任何要求“归档”已完成工作的请求时触发。'
---

# 归档已完成功能

## 概述

将已完成的功能目录从 `docs/specs/` 和 `docs/plans/` 归档至 `docs/archive/specs/` 和 `docs/archive/plans/`，并将 PRD 文件从 `docs/prds/` 归档至 `docs/archive/prds/`，保留原始子目录结构。通过 git 历史（而非代码分析）验证任务完成情况。此技能与 `code-review` 不同：它检查文档复选框和 git 日志以确认已完成的工作，绝不检查源代码。每次归档运行都会更新全局规范索引 `docs/global/index.md`。

**开始时声明：** "我正在使用归档技能来归档已完成的功能。"

---

## 阶段 1：发现已完成的功能

**目标：** 识别任务全部勾选完成的功能目录候选。

### 操作步骤

1. 扫描 `docs/specs/` 和 `docs/plans/` 中的功能目录：

```bash
ls docs/specs/
ls docs/plans/
```

2. 对于每个功能目录，检查任务完成状态：
   - 读取 `plan.md` 或 `plan-*.md` 文件，检查 `[x]` / `[ ]` 复选框状态
   - 识别所有任务均标记为 `[x]` 的目录

3. 扫描 `docs/prds/` 中的 PRD 文件：

```bash
ls docs/prds/
```

   - PRD 文件遵循命名模式 `YYYY-MM-DD-<feature>.md`（单一 Markdown 文件，非目录）
   - PRD 无复选框——完成情况通过 git 历史判断：检查是否有引用 PRD 功能名称或 PRD 提交本身的提交记录

4. 与 git 历史交叉验证：

```bash
git log --oneline -20          # 最近的提交记录
git diff --stat HEAD~N..HEAD   # 近期工作中变更的文件
```

将提交信息与任务描述进行匹配，以确认完成是真实的（而不仅仅是勾选了复选框）。

### 决策表：完成可信度

| 迹象                             | 可信度 | 操作                     |
| -------------------------------- | ------ | ------------------------ |
| 全部 `[x]` + 匹配的 git 提交记录 | 高     | 继续归档                 |
| 全部 `[x]` 但无匹配的 git 历史   | 低     | 标记为需人工审核，勿归档 |
| 仍有 `[ ]` 未完成的混合状态      | 未完成 | 跳过 —— 功能尚未完成     |
| 未找到 plan.md                   | 未知   | 跳过 —— 无检查清单可验证 |

### 停止 —— 在满足以下条件前，请勿进入阶段 2：

- [ ] 已识别候选功能目录
- [ ] Git 历史已确认每个候选的任务完成情况
- [ ] 低可信度的功能已标记为需人工审核

---

## 阶段 2：与用户确认

**目标：** 展示归档候选列表，并在移动文件前获得明确批准。

### 操作步骤

1. 列出候选及其完成证据：

```
| 功能目录 | 已完成任务 | Git 提交数 | 可信度 |
|-------------------|-----------|-------------|-----------|
| docs/specs/2026-05-10-login/ | 5/5 [x] | 3 条匹配 | 高 |
```

2. 只问一个明确的问题："是否归档这些已完成的功能？"

**停止 —— 在用户明确批准前，请勿进入阶段 3。**

---

## 阶段 3：执行归档

**目标：** 将已完成的功能目录移至 `docs/archive/` 并清理。

### 操作步骤

1. 将规范目录和计划目录移入归档区，保留子目录结构：

```bash
mkdir -p docs/archive/specs docs/archive/plans
# 将规范目录移入 archive/specs/
mv docs/specs/<date>_<topic> docs/archive/specs/
# 将计划目录移入 archive/plans/
mv docs/plans/<date>_<topic> docs/archive/plans/
```

2. 将 PRD 文件移入归档区：

```bash
mkdir -p docs/archive/prds
# 将 PRD 文件移入 archive/prds/
mv docs/prds/YYYY-MM-DD-<feature>.md docs/archive/prds/
```

3. 验证所有归档位置：

```bash
ls docs/archive/specs/<date>_<topic>/    # 规范文件（01-*.md 等）
ls docs/archive/plans/<date>_<topic>/           # 计划文件（plan.md、design.md 等）
ls docs/archive/prds/YYYY-MM-DD-<feature>.md    # PRD 文件
```

3. **修复归档文档中的相对路径引用** — 扫描 `docs/archive/specs/<date>_<topic>/` 和 `docs/archive/plans/<date>_<topic>/` 中所有 `.md` 文件的内部相对链接（如 `[text](../specs/...)` 或 `[text](../plans/...)`）。由于规范和计划目录在 `docs/archive/` 下保留了兄弟关系，它们之间的相对路径仍然有效。但需更新指向留在 `docs/` 中（未归档）的资源的路径。

4. 确认原始位置已清理（`docs/specs/` 或 `docs/plans/` 中不再存在这些目录，且 PRD 文件不再存在于 `docs/prds/` 中）。

### 停止 —— 在满足以下条件前，请勿进入阶段 4：

- [ ] 所有已确认的目录均已移至 `docs/archive/`
- [ ] 归档文档中的相对路径引用已检查并修复
- [ ] 原始位置已清理（无残留文件）
- [ ] 归档目录中包含所有预期文件

---

## 阶段 4：更新全局规范索引

**目标：** 更新 `docs/global/index.md` 以反映归档操作。

### 操作步骤

1. 读取 `docs/global/index.md` — 如果不存在，使用以下模板创建。

2. **将归档行追加到 `## 已完成功能` 表格** — 插入到顶部：

```
| [<目录名称>](../archive/plans/2026-05-10_color-extraction/) | <一句话摘要> | <领域> | <今日 ISO 日期> |
```

- **摘要：** 从 `design.md` 标题/概述或 `plan.md` 目标字段中提取 —— 最多一句话。
- **领域：** 从功能主题段推断（例如 `2026-05-10-tool-search` → `tool-search`）。
- **日期：** 今天的 ISO 格式日期（YYYY-MM-DD）。

3. 如果 `## 已完成功能` 分区不存在，在 `## 领域索引` 之前创建（如果无领域索引，则在文件末尾创建）。

4. **更新页脚时间戳** — 找到或创建 `*最后更新：*` 行：

```
*最后更新：YYYY-MM-DD —— 归档自 <目录名称>*
```

### 全局索引模板（新建时使用）

```markdown
# 全局规范索引

## 已完成功能

| 功能 | 摘要 | 领域 | 归档日期 |
| ---- | ---- | ---- | -------- |

## 领域索引

<!-- 按领域分组的规范 -->

_最后更新：YYYY-MM-DD —— 归档自 <目录名称>_
```

4. **确保 CLAUDE.md 引用 `docs/global/index.md`** — 如果 CLAUDE.md 的 `## 文档索引` 部分中 `## 核心索引` 表格未引用 `docs/global/index.md`，添加之：
   ```markdown
   | `docs/global/index.md` | `archive` 技能 | 全局规范索引——已完成功能和领域规范分组 |
   ```

### 停止 —— 在满足以下条件前，请勿进入阶段 5：

- [ ] `docs/global/index.md` 存在且已添加新的归档行
- [ ] 页脚时间戳已更新为今天的日期
- [ ] CLAUDE.md 的 `## 文档索引` 已引用 `docs/global/index.md`

---

## 阶段 5：报告

**目标：** 汇总归档操作。

```markdown
## 归档摘要

**日期：** [今天]
**已归档功能数：** [数量]

| 目录   | 摘要   | 领域   |
| ------ | ------ | ------ |
| [目录] | [摘要] | [领域] |

**全局索引已更新：** `docs/global/index.md`
```

---

## 反模式 / 常见错误

| 反模式                         | 为何失败                           | 正确做法                        |
| ------------------------------ | ---------------------------------- | ------------------------------- |
| 未经 git 历史检查就归档        | 复选框可能被提前勾选               | 将 `[x]` 与 `git log` 交叉验证  |
| 归档仍有未完成任务的功能       | 未完成的工作变得不可见             | 仅在所有 `[ ]` 已解决后才归档   |
| 未经用户确认就移动文件         | 破坏性操作 —— 用户可能需要这些文档 | 始终在阶段 2 获取明确批准       |
| 跳过全局索引更新               | 功能变得无法发现                   | 始终更新 `docs/global/index.md` |
| 归档期间分析源代码             | 这是归档，不是代码审查             | 仅检查文档和 git 历史           |
| 只归档计划不归档规范（或反之） | 留下孤立的一半功能                 | 将匹配的规范+计划对一起归档     |
| 功能实现前归档 PRD               | PRD 仍与活跃工作相关               | 仅在功能完成时才归档 PRD         |
| 忘记将 PRD 与规范/计划一起归档   | PRD 在 docs/prds/ 中变得陈旧       | 将 PRD 与其匹配的规范+计划对一起归档 |

---

## 反自我合理化防护

- **[HARD-GATE]** 未将 `[x]` 完成情况与 git 历史交叉确认前，切勿归档（阶段 1）
- **[HARD-GATE]** 未经用户明确批准，切勿移动文件（阶段 2）
- **[HARD-GATE]** 切勿跳过全局索引更新（阶段 4）
- **切勿** 分析源代码 —— 这不是代码审查
- **切勿** 归档仍有 `[ ]` 未完成任务的目录
- **切勿** 归档低可信度候选，除非经过人工审核

---

## 集成点

| 技能                             | 关系                                                         |
| -------------------------------- | ------------------------------------------------------------ |
| `code-review`                    | 归档检查文档完成情况；代码审查检查代码质量 —— 互补的质量关卡 |
| `spec-writing`                   | 规范定义功能；归档在功能完成后将其归档                       |
| `planning`                       | 计划跟踪任务；归档在归档前验证 `[x]` 完成状态                |
| `finishing-a-development-branch` | 分支清理通常在归档之前                                       |
| `task-management`                | 任务状态为归档完成检查提供输入                               |
| `prd-generation`                 | PRD 定义高层级需求；功能实现后归档将其归档                   |

---

## 具体示例

### 归档前状态

```
docs/specs/2026-05-10-color-extraction/
├── 01-color-extraction.md
├── 02-palette-rendering.md
└── 03-export-formats.md

docs/plans/2026-05-10_color-extraction/
└── plan.md                    # 6/6 个任务 [x]，git log 显示 4 条匹配提交
```

### 归档命令执行过程

```
用户：/archive
→ 阶段 1 发现 2026-05-10-color-extraction（6/6 [x]，4 条匹配提交 → 高可信度）
→ 阶段 2 展示候选，用户批准
→ 阶段 3 将两个目录移至 docs/archive/
→ 阶段 4 更新 docs/global/index.md，添加归档行 + 时间戳
→ 阶段 5 报告："已归档 1 个功能：color-extraction"
```

### 归档后状态

```
docs/archive/specs/2026-05-10-color-extraction/
├── 01-color-extraction.md
├── 02-palette-rendering.md
└── 03-export-formats.md

docs/archive/plans/2026-05-10_color-extraction/
└── plan.md

docs/global/index.md             # 已更新：新行 + 时间戳
docs/specs/                      # 已清理（目录已移除）
docs/plans/                      # 已清理（目录已移除）
```

---

## 技能类型

**严格（RIGID）** — 五个阶段是顺序且强制性的。Git 历史交叉验证、用户批准关卡和全局索引更新必须严格遵循。绝不检查源代码。
