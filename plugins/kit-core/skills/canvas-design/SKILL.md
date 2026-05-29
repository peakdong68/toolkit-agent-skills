---
name: canvas-design
description: >
  当用户需要 HTML Canvas、SVG 图形、数据可视化、生成艺术或使用 D3.js 及类似库的交互式视觉元素时使用。触发条件：用户提到"canvas"、"SVG"、"chart"、
  "data visualization"、"D3"、"generative art"、"animation"、"interactive graphics"、屏幕绘图等。
---

# 画布设计

## 概述

使用 HTML Canvas 2D、SVG 和数据可视化库创建高性能、可访问且视觉吸引力强的图形。本技能涵盖从底层像素操作到使用 D3.js 进行高级图表组合的全部内容，包括生成艺术、交互式图形和动画。

## 第一阶段：需求分析

1. 确定输出类型（静态、动画、交互式、数据驱动）
2. 选择渲染技术（Canvas 2D、SVG、WebGL、混合方案）
3. 识别数据源和更新频率
4. 定义可视化的可访问性要求
5. 设定性能预算（帧率、元素数量）

**停止 — 在实现之前，先展示技术推荐方案及理由。**

### 技术选择决策表

| 需求              | Canvas 2D | SVG  | WebGL |
| ----------------- | --------- | ---- | ----- |
| < 1000 个元素     | 可能      | 是   | 否    |
| > 10,000 个元素   | 是        | 否   | 是    |
| 需要 DOM 事件处理 | 否        | 是   | 否    |
| 像素操作          | 是        | 否   | 是    |
| 文本密集型可视化  | 否        | 是   | 否    |
| 3D 渲染           | 否        | 否   | 是    |
| 打印质量          | 否        | 是   | 否    |
| 动画密集型        | 是        | 可能 | 是    |
| 可访问性关键      | 否        | 是   | 否    |
| SEO 相关内容      | 否        | 是   | 否    |

### 何时使用每种技术

| 使用场景                     | 推荐方案           | 原因                         |
| ---------------------------- | ------------------ | ---------------------------- |
| 仪表板图表（< 500 个数据点） | SVG + D3.js        | DOM 事件、可访问性、打印支持 |
| 实时数据流（1000+ 数据点）   | Canvas 2D          | 大规模性能表现               |
| 带工具提示的交互式地图       | SVG                | 悬停事件、可访问             |
| 粒子系统 / 生成艺术          | Canvas 2D          | 像素级控制、高性能           |
| 3D 数据可视化                | WebGL (Three.js)   | GPU 加速                     |
| 博客文章信息图               | SVG                | 可缩放、可访问、可打印       |
| 游戏或模拟                   | Canvas 2D 或 WebGL | 帧率、像素控制               |

## 第二阶段：实现

1. 设置响应式 canvas/SVG 容器
2. 实现渲染管线（清除、更新、绘制）
3. 添加交互处理器（悬停、点击、拖拽、缩放）
4. 优化渲染循环（requestAnimationFrame、脏矩形）
5. 添加可访问性层（ARIA、屏幕阅读器描述）

**停止 — 在添加美化效果之前，先验证渲染在目标帧率下能正常工作。**

### Canvas 2D API 模式

#### 响应式 Canvas 设置

```javascript
function createResponsiveCanvas(container) {
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  const dpr = window.devicePixelRatio || 1;

  function resize() {
    const rect = container.getBoundingClientRect();
    canvas.width = rect.width * dpr;
    canvas.height = rect.height * dpr;
    canvas.style.width = `${rect.width}px`;
    canvas.style.height = `${rect.height}px`;
    ctx.scale(dpr, dpr);
  }

  const observer = new ResizeObserver(resize);
  observer.observe(container);
  container.appendChild(canvas);
  resize();

  return { canvas, ctx, destroy: () => observer.disconnect() };
}
```

#### 动画循环模式

```javascript
function createAnimationLoop(drawFn) {
  let rafId = null;
  let lastTime = 0;

  function loop(timestamp) {
    const deltaTime = timestamp - lastTime;
    lastTime = timestamp;
    drawFn(deltaTime, timestamp);
    rafId = requestAnimationFrame(loop);
  }

  return {
    start: () => {
      rafId = requestAnimationFrame(loop);
    },
    stop: () => {
      cancelAnimationFrame(rafId);
      rafId = null;
    },
    isRunning: () => rafId !== null,
  };
}
```

#### 脏矩形优化

```javascript
class DirtyRectRenderer {
  constructor(ctx, width, height) {
    this.ctx = ctx;
    this.dirtyRects = [];
    this.objects = [];
  }

  markDirty(x, y, w, h) {
    this.dirtyRects.push({ x, y, w, h });
  }

  render() {
    for (const rect of this.dirtyRects) {
      this.ctx.clearRect(rect.x, rect.y, rect.w, rect.h);
      for (const obj of this.objects) {
        if (this.intersects(obj.bounds, rect)) {
          obj.draw(this.ctx);
        }
      }
    }
    this.dirtyRects = [];
  }
}
```

### SVG 模式

#### 程序化创建 SVG

```javascript
function createSVG(width, height, viewBox) {
  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  svg.setAttribute('width', '100%');
  svg.setAttribute('height', '100%');
  svg.setAttribute('viewBox', viewBox || `0 0 ${width} ${height}`);
  svg.setAttribute('role', 'img');
  return svg;
}
```

#### SVG 可访问性

```xml
<svg role="img" aria-labelledby="chart-title chart-desc">
  <title id="chart-title">月度收入图表</title>
  <desc id="chart-desc">显示 2025 年 1 月至 12 月收入的柱状图</desc>
  <!-- 图表内容 -->
</svg>
```

### D3.js 集成模式

#### 数据连接模式（D3 v7）

```javascript
function updateBars(svg, data) {
  const bars = svg.selectAll('.bar').data(data, (d) => d.id);

  bars.exit().transition().duration(300).attr('opacity', 0).remove();

  bars
    .enter()
    .append('rect')
    .attr('class', 'bar')
    .attr('opacity', 0)
    .merge(bars)
    .transition()
    .duration(500)
    .attr('x', (d) => xScale(d.label))
    .attr('y', (d) => yScale(d.value))
    .attr('width', xScale.bandwidth())
    .attr('height', (d) => height - yScale(d.value))
    .attr('opacity', 1);
}
```

#### 比例尺与坐标轴

```javascript
// 用于连续数据的线性比例尺
const yScale = d3
  .scaleLinear()
  .domain([0, d3.max(data, (d) => d.value)])
  .range([height, 0])
  .nice();

// 用于分类数据的带状比例尺
const xScale = d3
  .scaleBand()
  .domain(data.map((d) => d.label))
  .range([0, width])
  .padding(0.2);

// 颜色比例尺
const colorScale = d3.scaleOrdinal(d3.schemeTableau10);
```

#### 响应式 D3 图表

```javascript
function responsiveChart(container, renderFn) {
  const observer = new ResizeObserver((entries) => {
    const { width, height } = entries[0].contentRect;
    const margin = { top: 20, right: 20, bottom: 40, left: 50 };
    renderFn(container, {
      width: width - margin.left - margin.right,
      height: height - margin.top - margin.bottom,
      margin,
    });
  });
  observer.observe(container);
  return () => observer.disconnect();
}
```

## 第三阶段：美化

1. 添加过渡和缓动效果
2. 实现响应式缩放
3. 跨设备和浏览器测试
4. 为不支持的环境添加降级内容

**停止 — 验证可访问性和性能目标是否达成。**

### 生成艺术技术

| 技术                | 类别     | 使用场景         |
| ------------------- | -------- | ---------------- |
| Perlin/Simplex 噪声 | 基于噪声 | 有机形状、地形   |
| 分形布朗运动        | 基于噪声 | 类地形纹理       |
| 域扭曲              | 基于噪声 | 流体效果         |
| 粒子系统            | 模拟     | 火焰、水流、群体 |
| L-系统              | 算法     | 植物状结构       |
| 沃罗诺伊图          | 算法     | 类细胞分区       |
| 德劳内三角剖分      | 算法     | 网格生成         |
| 流场                | 算法     | 方向性图案       |

### 可视化的可访问性

| 要求           | 实现方式                                              |
| -------------- | ----------------------------------------------------- |
| 文本替代方案   | SVG 中的 `<title>` 和 `<desc>`，Canvas 上的 ARIA 标签 |
| 数据表降级方案 | 为屏幕阅读器提供包含相同数据的隐藏表格                |
| 键盘交互       | 可聚焦元素，方向键导航                                |
| 色盲友好       | 除颜色外使用形状/图案区分                             |
| 高对比度模式   | 检测并调整颜色                                        |
| 减少动画       | 使用 `prefers-reduced-motion` 简化或禁用动画          |

### 性能指南

| 技术   | 优化方案                                            |
| ------ | --------------------------------------------------- |
| Canvas | 批量绘制调用，最小化状态变更（fill/stroke/font）    |
| SVG    | 限制 < 1000 个 DOM 节点，对重复元素使用 `<use>`     |
| Worker | 使用 OffscreenCanvas 在 Web Worker 中渲染           |
| 事件   | 将 mousemove 处理器节流至 16ms（60fps）             |
| CSS    | 对 CSS 动画的 SVG 元素使用 `will-change: transform` |
| 清理   | 卸载时销毁观察者、动画帧                            |

## 反模式 / 常见错误

| 反模式                           | 错误原因               | 正确做法                                 |
| -------------------------------- | ---------------------- | ---------------------------------------- |
| 用 Canvas 处理文本密集型内容     | 文本渲染差、无可访问性 | 文本密集型可视化使用 SVG                 |
| 每帧重绘整个 Canvas              | 无变化时浪费 CPU       | 使用脏矩形优化                           |
| 创建新 SVG 元素而非更新          | 内存泄漏、性能差       | 使用 D3 数据连接模式                     |
| 忽略 devicePixelRatio            | Retina/HiDPI 屏幕模糊  | 按 `window.devicePixelRatio` 缩放 Canvas |
| Canvas 无降级内容                | 屏幕阅读器无法获取内容 | 添加 `aria-label` 和隐藏数据表           |
| 1000+ SVG 元素使用内联事件处理器 | 内存和性能开销大       | 在父元素上使用事件委托                   |
| 不清理动画帧                     | 卸载时内存泄漏         | 清理函数中使用 `cancelAnimationFrame`    |
| 用 D3 处理简单静态图表           | 过度设计               | 直接使用 SVG 或 Chart.js                 |

## 反自我合理化防护

- 切勿跳过视网膜显示屏的缩放处理——使用 devicePixelRatio。
- 切勿忘记清理动画帧——使用 cancelAnimationFrame 防止内存泄漏。
- 切勿使用 Canvas 处理大量文本内容——Canvas 不是文本布局引擎。
- 切勿在不需要时重绘整个画布——只重绘变更区域。

## 集成点

| 技能                       | 集成方式                      |
| -------------------------- | ----------------------------- |
| `ui-ux-pro-max`            | 图表类型选择和配色方案        |
| `ui-design-system`         | 图表主题的设计令牌            |
| `artifacts-builder`        | 自包含的可视化构件            |
| `senior-frontend`          | React/Vue/Svelte 中的组件集成 |
| `performance-optimization` | 帧率和渲染优化                |
| `mobile-design`            | 移动端图表的触摸交互          |

## 技能类型

**灵活** — 选择最适合使用场景的渲染技术和库。可访问性关键和交互式图表使用 SVG，性能关键和动画密集型视觉效果使用 Canvas，3D 和超大规模数据集使用 WebGL。
