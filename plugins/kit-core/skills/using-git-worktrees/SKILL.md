---
name: using-git-worktrees
description: >
  当开始新的功能分支、创建隔离的开发环境，或在不使用暂存（stash）或切换分支的情况下同时处理多个任务时使用。触发条件：用户提及“worktree”、“为工作新建分支”、“并行开发”、“隔离环境”，或需要同时处理两件事。
---

# 使用 Git Worktree

## 概述

使用 `git worktree` 为并行开发任务创建隔离的工作目录，允许同时检出多个分支且互不冲突。本技能强制执行一个确定性的多阶段流程，从目录选择到设置验证，确保每个 worktree 在开始任何工作前都达到生产就绪状态。

## 适用场景

- 开始不应干扰当前工作的新功能分支
- 同时处理多个任务（如修复 bug + 开发功能）
- 为测试或代码评审创建干净的环境
- 在继续开发的同时运行耗时较长的进程（如测试、构建）

## 第一阶段：选择 Worktree 目录

[硬性关卡] 切勿跳过目录选择。在未检查优先级之前，切勿假设默认路径。

严格遵循以下优先级顺序：

### 优先级 1：匹配任务的现有 Worktree

检查是否已存在该任务的 worktree：

```bash
git worktree list
```

如果存在匹配的 worktree，直接使用它。切勿创建重复的 worktree。

### 优先级 2：CLAUDE.md 中的 Worktree 目录提示

检查项目的 CLAUDE.md 是否配置了 worktree 目录：

```
# 示例 CLAUDE.md 条目
worktree-directory: ../worktrees
```

如果已指定，则在该目录下创建 worktree。

### 优先级 3：询问用户

如果未配置提示且没有明显的惯例，请询问用户应在何处创建 worktree。建议一个合理的默认值：

```
../worktrees/<project-name>/<branch-name>
```

**停止 — 在继续之前，请与用户确认 worktree 目录。**

### 目录选择决策表

| 条件 | 操作 |
|---|---|
| 该分支的 worktree 已存在 | 导航至现有 worktree |
| CLAUDE.md 包含 `worktree-directory` | 使用配置的路径 |
| 项目已有现有 worktree | 使用相同的父目录模式 |
| 未找到惯例 | 询问用户，建议 `../worktrees/<project>/<branch>` |
| 用户指定仓库根目录内的路径 | 警告 — 必须将其添加到 `.gitignore` |

## 第二阶段：安全验证

[硬性关卡] 在所有安全检查通过之前，切勿创建任何 worktree。

### 检查 .gitignore 覆盖范围

如果 worktree 目录位于仓库根目录内，请确保它已包含在 `.gitignore` 中：

```bash
# 检查 worktree 路径是否会被追踪
git check-ignore <worktree-path>
```

如果未被忽略，请警告用户并建议将其添加到 `.gitignore`。

### 验证工作区是否干净

检查可能导致问题的未提交更改：

```bash
git status --porcelain
```

如果工作区不干净（有未提交的更改），请通知用户并询问如何继续：
- 先提交更改
- 暂存更改
- 强制继续（创建 worktree 本身是安全的）

### 验证分支未在其他 Worktree 中检出

```bash
git worktree list
```

一个分支不能同时在两个 worktree 中检出。如果该分支已被检出，请导航至该现有的 worktree。

### 安全检查决策表

| 检查项 | 结果 | 操作 |
|---|---|---|
| 路径在仓库内，但未在 `.gitignore` 中 | 失败 | 先添加到 `.gitignore` |
| 分支已在其他 worktree 中 | 失败 | 使用现有 worktree |
| 工作区不干净 | 警告 | 通知用户，询问偏好 |
| 路径已存在（非 worktree） | 失败 | 选择其他路径 |
| 所有检查通过 | 通过 | 进入第三阶段 |

## 第三阶段：创建 Worktree

```bash
# 用于新建分支
git worktree add <path> -b <branch-name> <base-branch>

# 用于现有分支
git worktree add <path> <existing-branch>
```

始终告知用户 worktree 创建的完整路径：

```
Worktree 创建于: /absolute/path/to/worktree
分支: feature/my-feature
基准: main
```

**停止 — 在进入设置阶段之前，确认 worktree 已成功创建。**

## 第四阶段：项目设置与自动检测

创建 worktree 后，检测并运行项目的设置命令。

### 设置检测决策表

| 指示文件 | 生态系统 | 设置命令 |
|---|---|---|
| `pnpm-lock.yaml` | Node.js (pnpm) | `pnpm install` |
| `yarn.lock` | Node.js (yarn) | `yarn install` |
| `package-lock.json` | Node.js (npm) | `npm install` |
| `package.json`（无 lock 文件） | Node.js (npm) | `npm install` |
| `pyproject.toml` + `tool.poetry` | Python (poetry) | `poetry install` |
| `pyproject.toml`（无 poetry） | Python (pip) | `pip install -e .` |
| `setup.py` | Python (pip) | `pip install -e .` |
| `requirements.txt` | Python (pip) | `pip install -r requirements.txt` |
| `go.mod` | Go | `go mod download` |
| `Cargo.toml` | Rust | `cargo build` |
| `Gemfile` | Ruby | `bundle install` |
| `composer.json` | PHP | `composer install` |

### 多生态系统

如果项目使用多个生态系统（例如 Go 后端搭配 Node.js 前端），请在相应的子目录中为每个检测到的生态系统运行设置命令。

### 环境配置文件

如果项目包含 `.env.example` 或 `.env.template`：

```bash
# 如果 worktree 中不存在 .env，则复制环境模板
cp .env.example .env  # 然后提示用户更新配置值
```

## 第五阶段：干净的基线测试验证

[硬性关卡] 在基线测试通过或已知失败原因之前，切勿进行任何工作。

在开始任何工作之前，运行项目的测试套件以建立干净的基线：

```bash
# 使用项目的测试命令
# Node.js: npm test / yarn test / pnpm test
# Python: pytest / python -m pytest
# Go: go test ./...
# Rust: cargo test
```

目的：
- 确认 worktree 设置正确
- 确保在更改前所有测试均能通过
- 此后的任何测试失败均由你的更改引起，而非预先存在的问题

如果基线测试失败：
- 向用户报告失败情况
- 在理解基线状况之前，切勿继续工作
- 基准分支可能存在需要优先修复的失败测试

## 第六阶段：位置报告

始终向用户清晰报告 worktree 的位置：

```
Worktree 已就绪：
  路径:    /Users/dev/worktrees/myproject/feature-auth
  分支:  feature/auth-refactor
  基准:    main
  设置:   npm install (已完成)
  测试:   24 通过, 0 失败
```

## 清理模式

### 合并或完成工作后

```bash
# 移除 worktree
git worktree remove <path>

# 如果文件残留（不干净的 worktree），强制移除
git worktree remove --force <path>

# 清理陈旧的 worktree 引用
git worktree prune
```

### 列出所有 Worktree

```bash
git worktree list
```

### 处理被锁定的 Worktree

如果 worktree 被锁定（以防止意外移除）：

```bash
# 移除前先解锁
git worktree unlock <path>
git worktree remove <path>
```

## 反模式 / 常见错误

| 反模式 | 为何错误 | 正确做法 |
|---|---|---|
| 为同一分支创建重复的 worktree | Git 不允许；浪费时间 | 先检查 `git worktree list` |
| 将 worktree 放在仓库内且未配置 `.gitignore` | worktree 文件会显示为未跟踪状态 | 将路径添加到 `.gitignore` |
| 在 worktree 中跳过依赖安装 | 因缺少依赖导致构建/测试失败 | 始终运行项目设置 |
| 跳过运行基线测试 | 无法区分预先存在的新故障 | 在开始工作前运行测试 |
| 假设 worktree 具有相同的环境变量 | `.env` 文件在 worktree 间不共享 | 复制并配置 `.env` |
| 合并后遗留陈旧的 worktree | 浪费磁盘空间，使 `git worktree list` 混乱 | 分支完成后移除 worktree |
| 强制移除包含未提交工作的 worktree | 永久丢失数据 | 先提交或暂存更改 |

## 集成点

| 技能                               | 集成方式                              |
| -------------------------------- | --------------------------------- |
| `finishing-a-development-branch` | 在 worktree 中完成工作后，使用此技能进行合并或创建 PR |
| `dispatching-parallel-agents`    | 在独立的 worktree 中运行 Agent 以实现真正隔离   |
| `verification-before-completion` | 在离开 worktree 前验证工作成果              |
| `self-learning`                  | 检查 CLAUDE.md 获取 worktree 目录偏好     |
| `planning`                       | 创建 worktree 通常是执行计划的第一步           |

## 技能类型

**严格模式** — 必须严格遵循此流程。每个阶段必须按顺序完成。切勿跳过安全检查。切勿跳过基线测试验证。在未确认目录之前，切勿创建 worktree。