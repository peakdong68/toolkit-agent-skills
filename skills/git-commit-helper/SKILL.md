---
name: git-commit-helper
description: >
  当用户需要约定式提交（conventional commits）、语义化版本控制、更新日志生成
  或提交信息质量改进方面的帮助时使用。触发条件：用户提及“commit”、“version bump”、“changelog”、
  “commit message”、暂存更改准备提交、或准备发布版本。
---

# Git 提交助手

## 概述

强制推行约定式提交规范，指导语义化版本决策，生成更新日志，并确保提交信息的质量。本技能提供了一种结构化的版本控制沟通方法，以支持自动化工具并维护清晰的项目历史记录。

## 阶段一：分析更改

分析已暂存的差异（diff），以了解具体更改内容：

```bash
git diff --cached --stat
git diff --cached
```

1. 识别受影响的文件和模块
2. 确定更改的性质（新功能、缺陷修复、重构等）
3. 检查更改是否包含破坏性变更（API 变更、功能移除、契约更改）

**暂停 — 在完全理解更改范围之前，切勿撰写提交信息。**

## 阶段二：分类与撰写

### 提交类型决策表

| 类型       | 使用场景                       | 版本升级 | 示例                                               |
| ---------- | ------------------------------ | -------- | -------------------------------------------------- |
| `feat`     | 面向用户的新功能               | MINOR    | `feat(auth): add OAuth2 login flow`                |
| `fix`      | 面向用户的缺陷修复             | PATCH    | `fix(api): handle null response in user endpoint`  |
| `docs`     | 仅文档更改                     | 无       | `docs(readme): update installation steps`          |
| `style`    | 代码格式、缺少分号等           | 无       | `style(lint): fix trailing whitespace`             |
| `refactor` | 代码更改但不影响现有行为       | 无       | `refactor(utils): extract date formatting helpers` |
| `perf`     | 性能优化                       | PATCH    | `perf(query): add index for user lookup`           |
| `test`     | 添加或修正测试用例             | 无       | `test(auth): add login failure scenarios`          |
| `chore`    | 日常维护、依赖更新、工具链配置 | 无       | `chore(deps): update typescript to 5.4`            |
| `ci`       | CI/CD 配置更改                 | 无       | `ci(github): add Node 20 to test matrix`           |
| `build`    | 构建系统或外部依赖更改         | 无       | `build(webpack): optimize chunk splitting`         |

### 约定式提交格式

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### 作用域（Scope）指南

作用域应标明受影响的代码库区域：

| 作用域策略 | 示例                                  | 适用场景               |
| ---------- | ------------------------------------- | ---------------------- |
| 按模块     | `auth`, `billing`, `dashboard`, `api` | 按功能组织的代码库     |
| 按层级     | `db`, `ui`, `middleware`, `config`    | 按架构层级组织的代码库 |
| 按包       | `@app/core`, `@app/shared`            | Monorepo（多包仓库）   |
| 通用       | `deps`, `ci`, `lint`, `types`         | 跨领域/全局性更改      |

规则：

- 全小写，使用短横线连接（kebab-case）
- 在项目内保持一致
- 可选，但建议经常更改 10 个以上文件的项目使用
- 对于真正全局性的更改，可省略作用域

### 描述（Description）规则

- 使用祈使句：用“add”而非“added”或“adds”
- 首字母不大写
- 末尾不加句号
- 总长度（类型 + 作用域 + 描述）不超过 72 个字符
- 描述“改了什么”，而非“怎么改的”

## 阶段三：撰写提交信息

### 正文（Body）指南

```
feat(cart): add quantity update functionality

Users can now change item quantities directly in the cart
without removing and re-adding items. The quantity selector
supports values from 1 to 99 with real-time price updates.

Closes #234
```

- 每行限制在 72 个字符处换行
- 解释“为什么”要进行此更改（动机）
- 从宏观层面解释“改了什么”
- 使用空行将正文与描述和页脚分隔开

### 破坏性变更（Breaking Changes）

```
feat(api)!: change user endpoint response format

BREAKING CHANGE: The /api/users endpoint now returns a paginated
response object instead of a plain array. Clients must update
to read from the `data` field.

Migration guide:
- Before: const users = await fetch('/api/users').json()
- After:  const { data: users } = await fetch('/api/users').json()
```

标示破坏性变更的两种方式：

1. 在类型/作用域后添加 `!`：`feat(api)!: description`
2. 使用 `BREAKING CHANGE:` 页脚（用于提供迁移详情）

两者均会触发 MAJOR（主版本）升级。

**暂停 — 在提交前，请将拟定的提交信息呈现给用户以供审批。**

## 阶段四：评估版本影响

### 语义化版本控制（SemVer）：MAJOR.MINOR.PATCH

| 组成部分          | 触发条件                        | 示例           |
| ----------------- | ------------------------------- | -------------- |
| MAJOR（主版本）   | 破坏性变更（不兼容的 API 更改） | 1.0.0 -> 2.0.0 |
| MINOR（次版本）   | 新功能（向后兼容）              | 1.0.0 -> 1.1.0 |
| PATCH（补丁版本） | 缺陷修复（向后兼容）            | 1.0.0 -> 1.0.1 |

### 版本升级规则

```
自上次发布以来的提交：
  fix(auth): handle expired tokens       -> PATCH
  feat(search): add fuzzy matching       -> MINOR（覆盖 PATCH）
  fix(ui): correct button alignment      -> 已为 MINOR
  feat(api)!: change response format     -> MAJOR（覆盖 MINOR）

结果：升级主版本（遵循最高优先级原则）
```

### 预发布版本

```
1.0.0-alpha.1    -> 早期测试阶段
1.0.0-beta.1     -> 功能开发完成，进入测试
1.0.0-rc.1       -> 发布候选版本
1.0.0            -> 正式稳定版
```

### 初始开发阶段（0.x.y）

- 0.1.0：首个可用版本
- 0.x.y：API 尚未稳定；MINOR（次版本）更新可能包含破坏性变更
- 1.0.0：首个稳定版本；全面应用语义化版本规则

## 阶段五：生成更新日志（如适用）

### CHANGELOG.md 格式

```markdown
# Changelog

## [1.2.0] - 2025-03-15

### Added

- Fuzzy search matching for product catalog (#234)
- Bulk export functionality for reports (#245)

### Fixed

- Handle expired authentication tokens gracefully (#230)
- Correct button alignment on mobile viewports (#232)

### Changed

- Update TypeScript to 5.4 (#240)

## [1.1.0] - 2025-02-28

...
```

### 提交类型与更新日志章节映射

| 提交类型                                | 更新日志章节                                    |
| --------------------------------------- | ----------------------------------------------- |
| `feat`                                  | 新增功能 (Added)                                |
| `fix`                                   | 修复缺陷 (Fixed)                                |
| `perf`                                  | 性能优化 (Performance)                          |
| `refactor`                              | 变更 (Changed)                                  |
| `docs`                                  | 文档更新 (Documentation)                        |
| `BREAKING CHANGE`                       | 破坏性变更 (Breaking Changes，置于发布说明顶部) |
| `chore`, `ci`, `build`, `style`, `test` | 通常不予收录                                    |

### 自动化工具

| 工具                     | 适用场景                             |
| ------------------------ | ------------------------------------ |
| `conventional-changelog` | 根据 Git 历史记录生成更新日志        |
| `semantic-release`       | 全自动版本管理与发布                 |
| `changeset`              | 适用于 Monorepo 的手动变更集文件管理 |
| `release-please`         | Google 出品的发布自动化工具          |

## 提交信息质量检查清单

### 必须通过

- [ ] 使用约定式提交格式（`type(scope): description`）
- [ ] 类型属于允许的范围
- [ ] 描述使用祈使句
- [ ] 描述总长度不超过 72 个字符
- [ ] 描述末尾无句号
- [ ] 明确标记破坏性变更

### 建议通过

- [ ] 作用域准确标识受影响区域
- [ ] 正文解释“为什么”更改，而非仅说明“改了什么”（针对非简单更改）
- [ ] 引用问题/工单编号（如 `Closes #123`、`Refs #456`）
- [ ] 每次提交仅包含单一逻辑更改（原子提交）
- [ ] 主分支历史记录中无“WIP”或“临时”提交

## 提交拆分指南

### 拆分时机决策表

| 条件                          | 操作                         |
| ----------------------------- | ---------------------------- |
| 更改涉及不同模块/功能         | 拆分为多次独立提交           |
| 重构与新增功能混合            | 拆分：先提交重构，再提交功能 |
| 为现有代码添加测试 + 新增功能 | 拆分：先提交测试，再提交功能 |
| 配置更改与代码更改混合        | 拆分为多次独立提交           |
| 跨多个文件的单一逻辑更改      | 保留为一次提交               |

### 如何拆分

```bash
# 交互式暂存以实现部分提交
git add -p                    # 交互式暂存代码块
git add path/to/specific/file # 暂存特定文件

# 示例：拆分重构与功能
git add src/utils/date.ts
git commit -m "refactor(utils): extract date formatting helpers"

git add src/components/DatePicker.tsx src/components/DatePicker.test.tsx
git commit -m "feat(ui): add date range picker component"
```

## 反模式 / 常见错误

| 反模式                       | 错误原因                         | 正确做法                      |
| ---------------------------- | -------------------------------- | ----------------------------- |
| 为新功能使用 `fix` 类型      | 会误导版本自动升级工具           | 新功能应使用 `feat`           |
| 压缩有价值的提交历史         | 丢失开发过程的上下文信息         | 保留原子提交，仅压缩 WIP 提交 |
| 使用 `--no-verify` 跳过钩子  | 绕过了质量检查关卡               | 应当修复钩子失败的问题        |
| 修改已发布/推送的提交        | 会破坏其他开发者的历史记录       | 应创建新的提交进行修正        |
| 提交信息为空或仅为 "."       | 对未来维护者毫无参考价值         | 撰写描述性清晰的提交信息      |
| 将格式调整与逻辑更改混在一起 | 无法单独回滚其中一项             | 拆分为独立的提交              |
| “将 X 改为 Y”重复 Diff 内容  | 除 Diff 外未提供额外信息         | 描述“为什么”要进行此更改      |
| 单次提交涉及 20+ 个文件      | 无法有效审查或使用二分法定位问题 | 拆分为逻辑清晰的原子提交      |

## 集成点

| 技能                             | 集成方式                         |
| -------------------------------- | -------------------------------- |
| `finishing-a-development-branch` | 压缩后的提交信息遵循约定式格式   |
| `code-review`                    | 提交质量纳入审查清单             |
| `deployment`                     | 版本升级触发发布流水线           |
| `planning`                       | 提交作用域与规划任务粒度保持一致 |
| `verification-before-completion` | 提交前确认测试通过               |

## 技能类型

**灵活（FLEXIBLE）** — 强烈推荐使用约定式提交格式，但可根据现有项目规范进行调整。在使用约定式提交时，版本升级规则是确定性的。更新日志章节直接与提交类型映射。
