# `/archive` 命令文档

## 概述

`/archive` 用于将已完成的功能目录从 `docs/specs/` 和 `docs/plans/` 归档至 `docs/archive/`，通过 git 历史验证任务完成状态（而非代码分析），并更新全局索引。

**触发方式：** `/archive`

**与 `/review` 的区别：** `/archive` 只检查文档复选框和 git log 来确认完成状态，绝不查看源代码。

---

## 使用场景

- 功能开发完成，任务清单全部 `[x]`
- Sprint 收尾，清理已完成的 spec/plan 目录
- 项目清理，归档过期或已完成的工作
- 保持 `docs/specs/` 和 `docs/plans/` 整洁，仅保留进行中的工作

---

## 执行流程

| 阶段 | 操作 | 关键动作 |
|------|------|---------|
| 1 — 发现 | 扫描 `docs/specs/` 和 `docs/plans/` | 检查 `[x]` 状态 + `git log` 交叉验证 |
| 2 — 确认 | 展示候选列表 | 等待用户明确批准 |
| 3 — 执行 | 移动文件至 `docs/archive/` | 修复过时引用路径 |
| 4 — 索引 | 更新 `docs/global/index.md` | 追加行 + 更新时间戳 |
| 5 — 报告 | 输出归档摘要 | 列出已归档功能 |

---

## 归档目录结构

### 归档前

```
docs/
├── specs/
│   └── 2026-05-10-color-extraction/
│       ├── 01-color-extraction.md
│       ├── 02-palette-rendering.md
│       └── 03-export-formats.md
├── plans/
│   └── 2026-05-10_color-extraction/
│       └── plan.md
└── global/
    └── index.md
```

### 归档后

```
docs/
├── archive/
│   ├── specs/
│   │   └── 2026-05-10-color-extraction/
│   │       ├── 01-color-extraction.md
│   │       ├── 02-palette-rendering.md
│   │       └── 03-export-formats.md
│   └── plans/
│       └── 2026-05-10_color-extraction/
│           └── plan.md
├── specs/        # 原目录已清理
├── plans/        # 原目录已清理
└── global/
    └── index.md  # 已更新：新增归档行 + 时间戳
```

---

## 完成判定规则

| 标记 | 置信度 | 处理方式 |
|------|--------|---------|
| 全部 `[x]` + 有匹配 git 提交 | **高** | 执行归档 |
| 全部 `[x]` 但无匹配 git 提交 | **低** | 标记人工审核，暂不归档 |
| 存在 `[ ]` 未完成 | **未完成** | 跳过 |
| 无 plan.md | **未知** | 跳过 |

---

## 全局索引

### `docs/global/index.md` 格式

```markdown
# 全局规格索引

## 已完成功能

| 功能 | 摘要 | 领域 | 归档日期 |
|------|------|------|---------|
| [color-extraction](../archive/plans/2026-05-10_color-extraction/) | 图片上传自动提取主导颜色 | image-processing | 2026-05-21 |

## 领域索引

*最后更新: 2026-05-21 — 由 2026-05-10-color-extraction 归档时更新*
```

### 更新规则

1. 在 `## 已完成功能` 表格顶行追加新记录
2. 摘要从 `design.md` 标题或 `plan.md` 目标字段提取，一句话
3. 领域从功能主题段推断
4. 日期为当天 ISO 格式（YYYY-MM-DD）
5. 更新页脚 `*最后更新:*` 时间戳

---

## 相关命令

| 命令 | 关系 |
|------|------|
| `/specs` | 创建规范文件，定义功能验收标准 |
| `/plan` | 创建实施计划，跟踪任务完成 |
| `/review` | 代码审查，检查代码质量 |
| `/commit` | 提交代码变更 |
| `/archive` | 归档已完成功能（本命令） |

---

## 注意事项

- **绝不分析源代码** — 这是归档，不是代码审查
- **必须用户确认** — 文件移动不可逆，执行前需明确批准
- **同时归档 spec + plan** — 避免留下孤立文件
- **检查 git 历史** — 复选框可能被提前勾选，需 git log 佐证
- **修复过时引用** — 归档后检查文档中的过时引用路径，确保指向正确路径
