---
name: ui-design-system
description: >
  当用户需要构建或维护设计令牌（design tokens）、组件库、主题系统，
  或带有响应式模式的 Tailwind CSS v4 配置时使用此技能。触发词：用户提到“design system”、
  “design tokens”、“component library”、“theme”、“Tailwind config”、“dark mode tokens”、
  “color system”、构建可复用 UI 组件。
---

# UI 设计系统

## 概述

采用以令牌（token）为核心的架构，构建并维护可扩展的设计系统。本技能涵盖从原始设计令牌到语义映射，再到主题化组件库的完整流程，并深入精通 Tailwind CSS v4、CSS 自定义属性及响应式设计模式。

## 阶段一：令牌基础

1. 审计现有设计资产（颜色、字体、间距、阴影）
2. 定义原始令牌（不带语义的原始值）
3. 创建语义令牌层（将原始值映射到具体用途）
4. 构建组件令牌层（将语义映射到组件局部）

**暂停 — 在构建组件前，向用户展示令牌层级以供审核。**

### 令牌层级决策表

| 层级 | 用途 | 命名规范 | 示例 |
|---|---|---|---|
| 原始层 (Primitive) | 原始值，单一事实来源 | `--color-blue-500`, `--space-4` | `oklch(0.55 0.18 250)` |
| 语义层 (Semantic) | 映射到用途/意图 | `--action-primary`, `--text-secondary` | `var(--color-blue-600)` |
| 组件层 (Component) | 限定于特定组件的作用域 | `--button-height-md`, `--card-radius` | `var(--space-4)` |

### 何时创建各层级

| 场景 | 所需层级 |
|---|---|
| 全新项目 | 全部三层（原始 + 语义 + 组件） |
| 为现有项目添加暗色模式 | 语义层 + 组件层（重新映射原始值） |
| 更新品牌色 | 仅原始层（语义/组件层自动更新） |
| 添加新组件 | 仅组件层（引用现有语义） |
| 使用 `@theme` 的 Tailwind 项目 | 通过 `@theme` 定义原始层，通过 CSS 变量定义语义层 |

## 阶段二：令牌实现

### 层级一：原始令牌

具有系统化命名的原始值。所有数值的单一事实来源。

```css
/* 颜色 — 使用 OKLCH 实现感知均匀性 */
--color-blue-50: oklch(0.97 0.01 250);
--color-blue-100: oklch(0.93 0.03 250);
--color-blue-500: oklch(0.55 0.18 250);
--color-blue-900: oklch(0.25 0.10 250);

/* 间距 — 以 4px 为基础单位 */
--space-1: 0.25rem;   /* 4px */
--space-2: 0.5rem;    /* 8px */
--space-3: 0.75rem;   /* 12px */
--space-4: 1rem;      /* 16px */
--space-6: 1.5rem;    /* 24px */
--space-8: 2rem;      /* 32px */
--space-12: 3rem;     /* 48px */
--space-16: 4rem;     /* 64px */

/* 排版/字体 */
--font-sans: 'Inter', system-ui, sans-serif;
--font-mono: 'Geist Mono', monospace;
--font-size-xs: 0.75rem;
--font-size-sm: 0.875rem;
--font-size-base: 1rem;
--font-size-lg: 1.125rem;
--font-size-xl: 1.25rem;
--font-size-2xl: 1.5rem;
--font-size-3xl: 1.875rem;
--font-size-4xl: 2.25rem;

/* 行高 */
--leading-tight: 1.25;
--leading-normal: 1.5;
--leading-relaxed: 1.75;

/* 圆角 */
--radius-sm: 0.25rem;
--radius-md: 0.375rem;
--radius-lg: 0.5rem;
--radius-xl: 0.75rem;
--radius-2xl: 1rem;
--radius-full: 9999px;

/* 阴影 */
--shadow-sm: 0 1px 2px 0 oklch(0 0 0 / 0.05);
--shadow-md: 0 4px 6px -1px oklch(0 0 0 / 0.1);
--shadow-lg: 0 10px 15px -3px oklch(0 0 0 / 0.1);
```

### 层级二：语义令牌

将原始值映射到具体用途。组件将引用这些令牌。

```css
/* 背景/表面 */
--surface-primary: var(--color-white);
--surface-secondary: var(--color-gray-50);
--surface-elevated: var(--color-white);
--surface-overlay: oklch(0 0 0 / 0.5);

/* 文本 */
--text-primary: var(--color-gray-900);
--text-secondary: var(--color-gray-600);
--text-tertiary: var(--color-gray-400);
--text-inverse: var(--color-white);
--text-link: var(--color-blue-600);

/* 操作/交互 */
--action-primary: var(--color-blue-600);
--action-primary-hover: var(--color-blue-700);
--action-secondary: var(--color-gray-100);
--action-danger: var(--color-red-600);

/* 边框 */
--border-default: var(--color-gray-200);
--border-strong: var(--color-gray-300);
--border-focus: var(--color-blue-500);

/* 状态 */
--status-success: var(--color-green-600);
--status-warning: var(--color-amber-500);
--status-error: var(--color-red-600);
--status-info: var(--color-blue-600);
```

### 层级三：组件令牌

限定于特定组件的作用域。

```css
/* 按钮 */
--button-height-sm: 2rem;
--button-height-md: 2.5rem;
--button-height-lg: 3rem;
--button-padding-x: var(--space-4);
--button-radius: var(--radius-md);
--button-font-weight: 500;

/* 输入框 */
--input-height: 2.5rem;
--input-padding-x: var(--space-3);
--input-border: var(--border-default);
--input-border-focus: var(--border-focus);
--input-radius: var(--radius-md);

/* 卡片 */
--card-padding: var(--space-6);
--card-radius: var(--radius-xl);
--card-shadow: var(--shadow-sm);
--card-border: var(--border-default);
```

## 阶段三：组件架构

1. 识别原子组件（按钮、输入框、徽章、头像）
2. 定义分子组件（表单字段、搜索栏、卡片）
3. 构建组织体/生物体级组件（头部导航、侧边栏、数据表格）
4. 建立组合模式（布局、页面模板）

**暂停 — 在构建变体前，向用户展示组件清单以供审核。**

### 组件复杂度决策表

| 级别 | 组件示例 | 组合方式 |
|---|---|---|
| 原子 (Atom) | 按钮、输入框、徽章、头像、图标 | 单一元素，无子节点 |
| 分子 (Molecule) | 表单字段、搜索栏、卡片、提示框 | 由 2-3 个原子组合而成 |
| 组织体 (Organism) | 头部导航、侧边栏、数据表格、模态框 | 由多个分子组合而成 |
| 模板 (Template) | 仪表盘布局、认证页面布局 | 页面级组合 |

### 变体模式（使用 CVA 或 Tailwind Variants）

```typescript
const buttonVariants = cva("inline-flex items-center justify-center rounded-md font-medium", {
  variants: {
    variant: {
      primary: "bg-action-primary text-white hover:bg-action-primary-hover",
      secondary: "bg-action-secondary text-text-primary hover:bg-gray-200",
      ghost: "hover:bg-action-secondary",
      danger: "bg-action-danger text-white hover:bg-red-700",
    },
    size: {
      sm: "h-8 px-3 text-sm",
      md: "h-10 px-4 text-sm",
      lg: "h-12 px-6 text-base",
    },
  },
  defaultVariants: {
    variant: "primary",
    size: "md",
  },
});
```

### 组合模式

- 复合组件，用于复杂 UI（标签页、手风琴/折叠面板、组合框）
- 基于插槽（Slot）的组合，用于灵活布局
- 渲染属性（Render Props），实现最大程度的自定义
- 转发引用（Forward Refs），用于访问 DOM

## 阶段四：主题化与响应式

1. 通过令牌替换实现浅色/暗色主题
2. 结合容器查询定义断点系统
3. 构建响应式组件变体
4. 跨视口和配色方案进行测试

**暂停 — 在标记完成前，验证主题切换是否正常工作。**

### Tailwind CSS v4 配置

```css
/* app.css — Tailwind v4 使用基于 CSS 的配置 */
@import "tailwindcss";

@theme {
  --color-primary-50: oklch(0.97 0.01 250);
  --color-primary-500: oklch(0.55 0.18 250);
  --color-primary-600: oklch(0.48 0.18 250);
  --color-primary-700: oklch(0.40 0.18 250);

  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'Geist Mono', monospace;

  --breakpoint-sm: 40rem;
  --breakpoint-md: 48rem;
  --breakpoint-lg: 64rem;
  --breakpoint-xl: 80rem;
}
```

### 暗色 / 浅色主题

```css
:root {
  color-scheme: light dark;
  --surface-primary: var(--color-white);
  --text-primary: var(--color-gray-900);
}

@media (prefers-color-scheme: dark) {
  :root {
    --surface-primary: var(--color-gray-950);
    --text-primary: var(--color-gray-50);
    --surface-elevated: var(--color-gray-900);
  }
}

/* 用于手动切换的类覆盖机制 */
[data-theme="dark"] {
  --surface-primary: var(--color-gray-950);
  --text-primary: var(--color-gray-50);
}
```

### 响应式设计模式

#### 断点系统

```
移动端优先策略：
默认    -> 0px+     （移动端）
sm      -> 640px+   （大屏手机/小平板）
md      -> 768px+   （平板）
lg      -> 1024px+  （笔记本）
xl      -> 1280px+  （桌面端）
2xl     -> 1536px+  （大屏桌面）
```

#### 容器查询（组件首选）

```css
.card-container {
  container-type: inline-size;
  container-name: card;
}

@container card (min-width: 400px) {
  .card-content {
    flex-direction: row;
  }
}
```

#### 响应式模式决策表

| 模式 | 移动端行为 | 桌面端行为 |
|---|---|---|
| 堆叠转横向 | 垂直列布局 | 水平行布局 |
| 侧边栏收起 | 抽屉式覆盖层 | 常驻侧边栏 |
| 表格转卡片 | 卡片列表 | 完整数据表格 |
| 隐藏/显示 | 次要内容隐藏 | 所有内容可见 |
| 重排 | 优先内容置前 | 标准顺序 |

## 验证清单

- [ ] 已为所有原始值定义原始令牌
- [ ] 语义令牌已将原始值映射到具体用途
- [ ] 组件令牌仅引用语义令牌
- [ ] 暗色主题已正确完成令牌重新映射
- [ ] 已定义断点系统（移动端优先）
- [ ] 已使用容器查询实现组件级响应式
- [ ] 字体比例遵循一致的缩放比率
- [ ] 间距比例使用 4px/8px 为基础单位
- [ ] 焦点状态清晰可见且符合无障碍标准
- [ ] 颜色对比度符合 WCAG AA 标准（4.5:1）

## 反模式 / 常见错误

| 反模式 | 错误原因 | 正确做法 |
|---|---|---|
| 在组件中硬编码十六进制颜色值 | 无法支持主题切换，无法适配暗色模式 | 使用语义令牌 |
| 通过反转颜色来创建暗色模式 | 视觉效果差，对比度错误 | 将令牌重新映射为适合暗色的值 |
| 使用 `!important` 覆盖系统样式 | 导致特异性冲突，难以维护 | 修正层叠顺序或使用 data 属性 |
| 混用间距单位（px, rem, em） | 布局不一致，缩放出现问题 | 统一使用 rem，并引用令牌 |
| 创建一次性组件而非扩展现有组件 | 导致设计系统碎片化 | 通过变体扩展现有组件 |
| 跳过语义层 | 与原始值强耦合 | 始终遵循 原始值 -> 语义 -> 组件 的映射路径 |
| 在组件中直接使用原始令牌 | 无法在不重写代码的情况下更换主题 | 组件应仅引用语义令牌 |
| 组件未使用容器查询 | 组件在不同上下文中易崩溃/错位 | 对自适应组件使用容器查询 |

## 反自我合理化防护

- 切勿跳过语义化 token 层——组件 token 必须先映射到语义 token。
- 切勿在组件中硬编码颜色值——始终引用设计 token。
- 切勿为相似需求创建一次性组件——优先扩展现有组件。
- 切勿混用不同的间距单位——统一使用 rem 或设计系统的间距尺度。
- 切勿使用 `!important` 覆盖样式——修复根源问题，而非覆盖症状。

## 集成点

| 技能 | 集成方式 |
|---|---|
| `ui-ux-pro-max` | 提供样式、调色板及 UX 指南 |
| `senior-frontend` | 在 React/Next.js 中实现设计系统 |
| `canvas-design` | 数据可视化令牌与图表主题化 |
| `mobile-design` | 移动端专属令牌适配 |
| `artifacts-builder` | 设计系统预览产物构建 |
| `planning` | 设计系统需像其他功能一样进行规划 |

## 技能类型

**灵活型（FLEXIBLE）** — 根据项目现有的规范与工具链，调整令牌命名、组件结构及主题化方案。强烈建议采用三层令牌层级（原始 -> 语义 -> 组件），但对于小型项目可适当简化。