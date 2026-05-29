---
name: performance-optimization
description: "在优化应用性能、减少加载时间、改进数据库查询、满足性能预算或诊断 Web 应用或 API 瓶颈时使用。触发条件：页面加载缓慢、Web Vitals 指标不佳、数据库超时、打包体积过大、用户反馈卡顿、准备扩容。"
---

# 性能优化

## 概述

使用数据驱动的方法系统地识别并解决性能瓶颈。本技能强制执行严格的「测量-识别-优化-验证」循环，防止过早优化和主观臆断。每次优化都必须产生可衡量的改进，否则应回滚。

**开始时声明：** "我正在使用 performance-optimization 技能来诊断和解决瓶颈问题。"

---

## 第一阶段：测量（建立基线）

**目标：** 在进行任何更改之前捕获真实指标。

### 操作

```bash
# Web: Lighthouse CI
npx lighthouse https://your-app.com --output=json --output-path=baseline.json

# API: 使用 k6 进行负载测试
k6 run --out json=baseline.json loadtest.js

# 数据库：慢查询日志
# PostgreSQL: SET log_min_duration_statement = 100;  -- 记录 > 100ms 的查询
```

记录这些数值。它们将作为衡量改进效果的基线。

### 停止 — 在满足以下条件前，不要进入第二阶段：
- [ ] 基线指标已捕获并保存
- [ ] 已定义具体的指标目标（例如：LCP < 2.5 秒）
- [ ] 测量方法已文档化（以便可重复执行）

---

## 第二阶段：识别（定位实际瓶颈）

**目标：** 使用性能分析工具找出时间消耗的位置。切勿猜测。

### 性能分析工具选择表

| 层级 | 工具 | 显示内容 |
|-------|------|--------------|
| 前端渲染 | React DevTools Profiler, Chrome Performance 面板 | 组件渲染耗时 |
| 网络 | Chrome Network 面板, WebPageTest | 请求瀑布流, TTFB |
| JavaScript | Chrome Performance 面板, `console.time()` | 函数执行时间 |
| Node.js 服务器 | `--prof` 标志, clinic.js, 0x | CPU 火焰图 |
| 数据库 | `EXPLAIN ANALYZE`, pg_stat_statements | 查询计划, 慢查询 |
| 内存 | Chrome Memory 面板, heapdump | 内存分配模式, 泄漏 |
| 打包体积 | webpack-bundle-analyzer, vite-bundle-visualizer | 模块大小 |

瓶颈几乎从不在你假设的位置。先测量。

### 停止 — 在满足以下条件前，不要进入第三阶段：
- [ ] 已使用适用于该层级的性能分析工具
- [ ] 已通过数据识别出具体瓶颈
- [ ] 该瓶颈占问题原因的显著比例

---

## 第三阶段：优化（修复已识别的瓶颈）

**目标：** 应用针对性修复。每次只更改一项内容。

### 优化决策表

| 瓶颈类型 | 优化方法 | 示例 |
|----------------|----------------------|---------|
| 打包体积过大 | 代码分割、树摇、动态导入 | `React.lazy(() => import('./HeavyComponent'))` |
| API 响应缓慢 | 缓存、查询优化、分页 | 添加 TTL 为 5 分钟的 Redis 缓存 |
| 数据库查询缓慢 | 添加索引、优化查询计划、物化视图 | `CREATE INDEX idx_user_email ON users(email)` |
| 过度重渲染 | 记忆化、虚拟化、状态重构 | `React.memo`, `useMemo` |
| 图片过大 | 压缩、懒加载、响应式图片 | `<img loading="lazy" srcset="...">` |
| TTFB 缓慢 | 服务端缓存、CDN、边缘渲染 | stale-while-revalidate 模式 |
| 内存泄漏 | 修复事件监听器清理、弱引用 | 正确的 `useEffect` 清理 |

### 停止 — 在满足以下条件前，不要进入第四阶段：
- [ ] 仅进行了一项更改
- [ ] 更改直接针对已识别的瓶颈
- [ ] 优化过程中未附带其他无关更改

---

## 第四阶段：验证（再次测量）

**目标：** 重新运行第一阶段完全相同的测量。

### 操作

1. 运行与第一阶段相同的性能分析/测量
2. 对比结果：
   - 指标是否改善？
   - 改善幅度是多少？
   - 其他指标是否有回退？
3. **如果改进无法量化衡量，请回滚该更改。**

无法衡量的优化不是真正的优化。

### 停止 — 验证完成条件：
- [ ] 使用与第一阶段相同的测量方法
- [ ] 改进已量化（例如："LCP 从 3.2 秒降低至 2.1 秒"）
- [ ] 其他指标无回退
- [ ] 如无改进：已回滚更改

---

## 缓存策略决策表

| 缓存类型 | 适用场景 | TTL 指导 | 失效策略 |
|------------|----------|--------------|-------------|
| **内存缓存（LRU）** | 单实例、热点数据、计算结果 | 秒到分钟 | 驱逐策略 |
| **Redis/Memcached** | 多实例、共享缓存、会话 | 分钟到小时 | 事件驱动或 TTL |
| **CDN** | 静态资源、公开页面、API 响应 | 小时到天 | 部署触发清除 |
| **浏览器缓存** | 重复访问、静态资源 | 天到月（带版本号） | 缓存破坏哈希 |

### Cache-Control 头部

```
# 不可变资源（带哈希的文件名）
Cache-Control: public, max-age=31536000, immutable

# API 响应（可缓存但需重新验证）
Cache-Control: public, max-age=0, must-revalidate
ETag: "abc123"

# 私有用户数据
Cache-Control: private, no-store

# stale-while-revalidate（快速响应 + 后台刷新）
Cache-Control: public, max-age=60, stale-while-revalidate=300
```

---

## 打包优化技巧

| 技巧 | 影响程度 | 实现方式 |
|-----------|--------|---------------|
| 路由级代码分割 | 高 | 每个路由使用 `React.lazy()` + `Suspense` |
| 树摇（Tree shaking） | 高 | 仅使用 ES 模块，`sideEffects: false` |
| 动态导入 | 中 | 用户操作时 `await import('heavy-lib')` |
| 图片优化 | 高 | next/image, WebP/AVIF, 响应式 srcset |
| 字体优化 | 中 | `next/font`, `font-display: swap`, 子集化 |
| 依赖替换 | 中 | 用 day.js 替代 moment.js，用 lodash-es 替代 lodash |

### 打包分析命令

```bash
# Webpack
npx webpack-bundle-analyzer stats.json

# Vite
npx vite-bundle-visualizer

# Next.js
ANALYZE=true next build
```

---

## 数据库查询调优

### 索引优化

```sql
-- 查找缺失的索引（PostgreSQL）
SELECT schemaname, tablename, seq_scan, idx_scan
FROM pg_stat_user_tables
WHERE seq_scan > idx_scan
ORDER BY seq_scan DESC;
```

### 索引规则

| 规则 | 说明 |
|------|------------|
| 为 WHERE、JOIN、ORDER BY 列创建索引 | 这些是数据库搜索的列 |
| 复合索引中等值列放在前面 | 选择性最高的过滤条件优先 |
| 复合索引中范围列放在最后 | 选择性较低，在等值条件之后应用 |
| 删除未使用的索引 | 它们会拖慢写入速度 |
| 对过滤查询使用部分索引 | 索引更小，查找更快 |

### 查询计划危险信号

| EXPLAIN ANALYZE 中的危险信号 | 含义 | 修复方案 |
|----------------------------|---------|-----|
| 大表上的 **Seq Scan** | 全表扫描 | 添加索引 |
| 多行数据的 **Nested Loop** | O(n*m) 复杂度连接 | 添加索引或重构查询 |
| 高内存消耗的 **Sort** | 内存中排序 | 添加与 ORDER BY 匹配的索引 |
| 实际行数 >> 估计行数 | 统计信息过时 | 执行 ANALYZE |
| 大型构建的 **Hash Join** | 内存密集型操作 | 确保连接列已建立索引 |

---

## Web Vitals 目标值

| 指标 | 良好 | 需改进 | 较差 |
|--------|------|------------|------|
| **LCP**（最大内容绘制） | < 2.5 秒 | 2.5-4 秒 | > 4 秒 |
| **INP**（交互到下一次绘制） | < 200 毫秒 | 200-500 毫秒 | > 500 毫秒 |
| **CLS**（累积布局偏移） | < 0.1 | 0.1-0.25 | > 0.25 |

### Web Vitals 优化表

| 指标 | 优化方案 | 实现方式 |
|--------|-------------|---------------|
| LCP | 预加载 LCP 资源 | `<link rel="preload">` 或 `fetchpriority="high"` |
| LCP | 内联关键 CSS | 提取首屏 CSS 内联 |
| LCP | 优化 TTFB | CDN、边缘渲染、服务端缓存 |
| INP | 拆分长任务 | `requestIdleCallback`, `scheduler.yield()` |
| INP | 防抖输入处理器 | 昂贵处理器添加 100-300 毫秒防抖 |
| INP | Web Workers | 将计算任务移出主线程 |
| CLS | 显式设置尺寸 | 为图片和视频设置 `width`/`height` |
| CLS | 为动态内容预留空间 | 为广告、嵌入内容设置占位符尺寸 |
| CLS | 使用 transform 动画 | 避免触发布局的属性 |

---

## 负载测试

### 测试类型

| 类型 | 用户数 | 持续时间 | 目的 |
|------|-------|----------|---------|
| 冒烟测试 | 1-2 | 1 分钟 | 验证测试是否正常工作 |
| 负载测试 | 预期流量 | 10-30 分钟 | 正常性能表现 |
| 压力测试 | 预期流量的 2-3 倍 | 10-30 分钟 | 寻找系统崩溃点 |
| 浸泡测试 | 正常负载 | 2-8 小时 | 发现内存泄漏 |

### 关键指标

- 响应时间百分位数（p50, p95, p99）— 而非平均值
- 负载下的错误率
- 吞吐量（每秒请求数）
- 资源利用率（CPU、内存、连接数）

---

## 反模式 / 常见错误

| 反模式 | 错误原因 | 正确做法 |
|-------------|----------------|-----------------|
| 未测量就优化 | 你不知道该修复什么 | 始终先测量 |
| 过早优化 | 在非瓶颈处浪费时间 | 通过性能分析定位实际瓶颈 |
| 全部记忆化 | 增加复杂度但无实证收益 | 先性能分析，再考虑记忆化 |
| 无失效策略的缓存 | 过期数据导致缺陷 | 添加缓存前先定义失效策略 |
| 优化平均值而非百分位数 | 平均值掩盖尾部延迟 | 跟踪 p95 和 p99 |
| 同时进行多项优化 | 无法归因改进效果 | 每次只改一项 |
| 保留无实测收益的优化 | 死代码和复杂度 | 如无实测改进则回滚 |
| 未检查查询模式就添加索引 | 未使用的索引拖慢写入 | 先检查慢查询日志 |

---

## 子代理分发机会

| 任务模式 | 分发至 | 适用时机 |
|---|---|---|
| 并发分析不同系统层级 | `Agent` 工具，`subagent_type="Explore"`（每层一个） | 独立分析前端、后端和数据库时 |
| 打包分析与树摇审查 | `Agent` 工具，`subagent_type="general-purpose"` | 前端打包体积成为关注点时 |
| 数据库查询优化分析 | `Agent` 工具分发 `database-architect` 代理 | 多表存在慢查询时 |

分发时请遵循 `dispatching-parallel-agents` 技能协议。

---

## 集成点

| 技能 | 关系说明 |
|-------|-------------|
| `senior-frontend` | 前端性能优化涉及打包和 Web Vitals 优化 |
| `senior-backend` | 后端性能优化涉及缓存和查询调优 |
| `testing-strategy` | 负载测试是测试金字塔的组成部分 |
| `code-review` | 代码审查检查性能回退 |
| `systematic-debugging` | 性能问题遵循相同的调查方法论 |
| `acceptance-testing` | 性能目标成为验收标准 |

---

## 技能类型

**灵活（FLEXIBLE）** — 根据项目上下文调整优化深度。每次优化都必须遵循「测量 - 识别 - 优化 - 验证」循环。任何未产生可衡量改进的更改都应回滚。