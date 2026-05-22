---
name: artifacts-builder
description: >
  当用户需要独立的 HTML/CSS/JS 构件时使用——交互式演示、原型、单文件应用或在浏览器中独立运行的可视化工具。触发条件：用户提到"构件"、"演示"、"原型"、"单文件应用"、"HTML 工具"、"交互式小部件"、"独立页面"，或构建无需构建步骤即可在浏览器中运行的内容。
---

# 构件构建器

## 概述

生成自包含、生产级别的 HTML/CSS/JS 构件，可在任何现代浏览器中无需构建步骤即可运行。每个构件均为单文件（或最小文件集），包含交互式演示、原型、数据可视化或实用工具所需的全部内容。强调渐进增强、响应式设计和简洁代码。

## 阶段 1：范围定义

1. 明确构件用途（演示、原型、工具、可视化）
2. 确定交互级别（静态、交互式、数据驱动）
3. 识别所需依赖（无、CDN 加载、内嵌）
4. 定义响应式需求（移动端、桌面端、两者兼顾）
5. 设定约束条件（文件大小、浏览器支持、离线能力）

**暂停 — 在进行架构决策前，与用户确认范围和约束条件。**

### 构件类型决策表

| 用途         | 复杂度  | 依赖项                  | 示例                      |
| ------------ | ------- | ----------------------- | ------------------------- |
| 静态演示     | 低      | 无                      | 产品模型、落地页          |
| 交互式小部件 | 中      | 无或 Alpine.js          | 计算器、表单构建器        |
| 数据可视化   | 中 - 高 | D3.js 或 Chart.js       | 仪表盘、图表探索器        |
| 原型         | 中      | Alpine.js 或 Petite-Vue | 可点击的 UI 原型          |
| 实用工具     | 中 - 高 | 视情况而定              | JSON 格式化器、颜色选择器 |
| 生成式艺术   | 中      | 无                      | Canvas 动画、图案生成器   |
| 演示文稿     | 中      | 无或 Mermaid            | 幻灯片、图表查看器        |

## 阶段 2：架构设计

1. 选择单文件或多文件方案
2. 选择 CDN 依赖项（如有）
3. 规划文件内的组件结构
4. 定义状态管理方法
5. 规划渐进增强层级

**暂停 — 提交架构和依赖项选择供审批。**

### 架构决策表

| 约束条件               | 单文件       | 多文件               |
| ---------------------- | ------------ | -------------------- |
| 便于分享（邮件、粘贴） | 是           | 否                   |
| 文件大小 < 100KB       | 是           | 均可                 |
| 多页面/多视图          | 可能（SPA）  | 更佳                 |
| 团队协作               | 困难         | 更佳                 |
| 离线使用               | 是（自包含） | 需要打包             |
| SEO 需求               | 不适用       | 不适用（构件为工具） |

### 依赖项决策表

| 需求             | 推荐方案          | CDN 链接                          | 大小     |
| ---------------- | ----------------- | --------------------------------- | -------- |
| 轻量级响应式     | Alpine.js         | `cdn.jsdelivr.net/npm/alpinejs@3` | ~15KB    |
| 最小化 Vue 风格  | Petite-Vue        | `unpkg.com/petite-vue`            | ~6KB     |
| 图表             | Chart.js          | `cdn.jsdelivr.net/npm/chart.js@4` | ~65KB    |
| 数据可视化       | D3.js             | `cdn.jsdelivr.net/npm/d3@7`       | ~90KB    |
| 图表/流程图      | Mermaid           | `cdn.jsdelivr.net/npm/mermaid@10` | ~120KB   |
| CSS 框架（原型） | Tailwind Play CDN | `cdn.tailwindcss.com`             | 运行时   |
| 图标             | Lucide            | `unpkg.com/lucide@latest`         | 按需加载 |
| 无需依赖         | 原生 JS           | 无                                | 0KB      |

### CDN 使用规则

| 规则                              | 理由                                   |
| --------------------------------- | -------------------------------------- |
| 锁定主版本（`@3`、`@7`）          | 防止破坏性变更                         |
| 最多 3 个 CDN 依赖                | 保持构件轻量                           |
| 添加 `integrity` 和 `crossorigin` | 防范 CDN 被篡改的安全风险              |
| 提供优雅降级方案                  | CDN 失效时仍可工作                     |
| 优先选择更小的替代方案            | Alpine 优于 React，Petite-Vue 优于 Vue |

## 阶段 3：实现

1. 构建语义化 HTML 结构
2. 添加 CSS（内联 `<style>` 或嵌入）
3. 实现 JavaScript 功能
4. 添加错误处理和回退方案
5. 跨视口和浏览器测试

**暂停 — 交付给用户前验证构件是否正常工作。**

### 模板结构

```html
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>[构件标题]</title>
    <style>
      /* 重置 */
      *,
      *::before,
      *::after {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
      }

      /* 设计令牌 */
      :root {
        --color-bg: #ffffff;
        --color-text: #1a1a2e;
        --color-primary: #3b82f6;
        --color-border: #e2e8f0;
        --radius: 0.5rem;
        --space: 1rem;
        --font: system-ui, -apple-system, sans-serif;
      }

      @media (prefers-color-scheme: dark) {
        :root {
          --color-bg: #0f172a;
          --color-text: #e2e8f0;
          --color-primary: #60a5fa;
          --color-border: #334155;
        }
      }

      /* 基础样式 */
      body {
        font-family: var(--font);
        background: var(--color-bg);
        color: var(--color-text);
        line-height: 1.6;
      }

      /* 组件样式 */
      /* ... */
    </style>
  </head>
  <body>
    <!-- 语义化 HTML 内容 -->

    <script>
      // 应用逻辑
      (function () {
        'use strict';
        // ...
      })();
    </script>
  </body>
</html>
```

### 响应式设计模式

#### 基于容器的布局

```css
.container {
  width: min(100% - 2rem, 1200px);
  margin-inline: auto;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(300px, 100%), 1fr));
  gap: var(--space);
}
```

#### 移动优先的媒体查询

```css
/* 基础：移动端 */
.layout {
  display: flex;
  flex-direction: column;
}

/* 平板及以上 */
@media (min-width: 768px) {
  .layout {
    flex-direction: row;
  }
  .sidebar {
    width: 280px;
    flex-shrink: 0;
  }
}
```

### 渐进增强

| 层级       | 目的               | 要求                    |
| ---------- | ------------------ | ----------------------- |
| HTML       | 内容可访问且有意义 | 无 CSS 或 JS 时仍可工作 |
| CSS        | 视觉呈现和布局     | 无 JS 时仍可工作        |
| JavaScript | 增强交互性         | 添加动态行为            |

#### 特性检测

```javascript
// 使用现代 API 前先检测
if ('IntersectionObserver' in window) {
  // 使用懒加载
} else {
  // 立即加载所有图片
}

if (CSS.supports('backdrop-filter', 'blur(10px)')) {
  element.classList.add('glass-effect');
}
```

### 状态管理（无框架）

#### 简单状态模式

```javascript
function createStore(initialState) {
  let state = { ...initialState };
  const listeners = new Set();

  return {
    getState: () => ({ ...state }),
    setState(updates) {
      state = { ...state, ...updates };
      listeners.forEach((fn) => fn(state));
    },
    subscribe(fn) {
      listeners.add(fn);
      return () => listeners.delete(fn);
    },
  };
}
```

#### 基于 URL 的状态（用于可分享的构件）

```javascript
function syncStateWithURL(store) {
  const params = new URLSearchParams(location.search);
  for (const [key, value] of params) {
    store.setState({ [key]: JSON.parse(value) });
  }
  store.subscribe((state) => {
    const params = new URLSearchParams();
    Object.entries(state).forEach(([k, v]) => params.set(k, JSON.stringify(v)));
    history.replaceState(null, '', `?${params}`);
  });
}
```

### 导出格式

| 格式            | 使用场景   | 方法                           |
| --------------- | ---------- | ------------------------------ |
| 单 HTML 文件    | 分享、嵌入 | 自包含 `<style>` 和 `<script>` |
| HTML + 资源文件 | 复杂构件   | 独立的 CSS/JS 文件             |
| Data URL        | 内联嵌入   | `data:text/html;base64,...`    |
| 截图/PNG        | 文档说明   | `html2canvas` 或浏览器截图     |
| PDF             | 打印/报告  | `window.print()` 配合打印样式  |

## 质量检查清单

- [ ] 有效的 HTML5（`<!DOCTYPE html>`，`lang` 属性）
- [ ] 响应式 viewport meta 标签
- [ ] 无 JavaScript 时仍可工作（内容可见）
- [ ] 深色模式支持（`prefers-color-scheme`）
- [ ] 支持键盘导航
- [ ] 无控制台错误
- [ ] 文件大小低于 100KB（不含图片）
- [ ] 跨浏览器测试（Chrome、Firefox、Safari）
- [ ] 如适用，包含打印样式
- [ ] 恰当使用语义化 HTML 元素

## 反模式 / 常见错误

| 反模式                               | 错误原因                     | 替代方案                          |
| ------------------------------------ | ---------------------------- | --------------------------------- |
| 在单文件构件中使用 React/Vue/Angular | 简单交互的开销过大           | 使用 Alpine.js 或原生 JS          |
| 为简单 UI 从 CDN 加载重型框架        | 加载缓慢，浪费带宽           | 依赖项体量应与需求匹配            |
| 使用内联样式而非 CSS 自定义属性      | 无法主题化，无法支持深色模式 | 使用 CSS 自定义属性（令牌）       |
| 用户输入无错误处理                   | 非法输入导致崩溃             | 验证输入并提供反馈                |
| 固定像素尺寸                         | 在移动设备、平板上显示异常   | 使用响应式单位（%、rem、vw）      |
| 缺少 `<meta viewport>`               | 移动端以桌面缩放比例渲染     | 始终包含 viewport meta 标签       |
| `<head>` 中使用阻塞式 `<script>`     | 延迟页面渲染                 | 使用 `defer` 属性或置于 body 末尾 |
| 脚本无 IIFE 包装                     | 污染全局作用域               | 用 `(function() { ... })()` 包装  |
| 颜色硬编码而无令牌                   | 无法切换主题                 | 使用 CSS 自定义属性               |

## 反自我合理化防护

- 切勿跳过技术选型阶段直接开始构建——先确定使用原生 HTML/CSS 还是框架。
- 切勿跳过跨浏览器测试——至少在 2 个浏览器中验证。
- 切勿信任用户输入而不做验证——独立 artifacts 仍然需要输入消毒。
- 切勿为简单静态页面引入过于复杂的框架——保持轻量。

## 集成点

| 技能               | 集成方式                   |
| ------------------ | -------------------------- |
| `ui-ux-pro-max`    | 样式选择和 UX 指南         |
| `ui-design-system` | 用于一致主题的设计令牌     |
| `canvas-design`    | 构件内的 Canvas/SVG 可视化 |
| `senior-frontend`  | 复杂组件模式               |
| `mobile-design`    | 移动端响应式构件设计       |
| `planning`         | 构件范围在规划阶段定义     |

## 技能类型

**灵活** — 根据构件需求调整架构、依赖项和复杂度。简单演示应尽可能保持最小化；复杂工具可使用轻量级框架和多个 CDN 依赖项。
