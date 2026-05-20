# 性能预算

定义 Web 应用程序大小和时间预算的参考文档。

## 大小预算

### JavaScript

| 指标 | 预算 | 说明 |
|--------|--------|-------|
| 总 JS（压缩后） | < 300 KB | 所有打包文件合计，经 gzip 压缩 |
| 主打包文件 | < 150 KB | 入口文件，每个页面都会加载 |
| 每路由代码块 | < 50 KB | 按路由懒加载 |
| 第三方 JS | < 100 KB | 分析工具、小部件、SDK |

### CSS

| 指标 | 预算 |
|--------|--------|
| 总 CSS（压缩后） | < 100 KB |
| 关键 CSS（内联） | < 14 KB |
| 每组件 CSS | < 5 KB |

### 图片

| 指标 | 预算 |
|--------|--------|
| 每页图片总量 | < 1 MB |
| 首屏/LCP 图片 | < 200 KB |
| 缩略图 | 每张 < 30 KB |
| 图标（SVG） | 每张 < 5 KB |

### 字体

| 指标 | 预算 |
|--------|--------|
| 字体文件总量 | < 100 KB |
| 单个字体文件（WOFF2） | < 50 KB |
| 字体文件数量 | <= 4 |

使用 `font-display: swap` 或 `optional` 防止渲染阻塞。
对字体进行子集化处理，仅包含目标语言所需的字符。

## 时间预算

| 指标 | 预算 | 测量方式 |
|--------|--------|-------------|
| 可交互时间（TTI） | < 3s | Lighthouse（移动网络 4G） |
| 最大内容绘制（LCP） | < 2.5s | Web Vitals |
| 首次内容绘制（FCP） | < 1.8s | Lighthouse |
| 总阻塞时间（TBT） | < 200ms | Lighthouse |
| 累积布局偏移（CLS） | < 0.1 | Web Vitals |
| 下次绘制交互时间（INP） | < 200ms | Web Vitals |
| 服务器响应时间（TTFB） | < 600ms | Web Vitals |

### API 响应时间

| 端点类型 | 预算 |
|---------------|--------|
| 简单读取（按 ID） | < 50ms |
| 列表/搜索 | < 200ms |
| 写入（创建/更新） | < 500ms |
| 复杂聚合查询 | < 1s |
| 报表生成 | < 5s（或异步处理） |

## 在 CI 中执行预算检查

### Lighthouse CI

```yaml
# lighthouserc.js
module.exports = {
  ci: {
    assert: {
      assertions: {
        'categories:performance': ['error', { minScore: 0.9 }],
        'total-byte-weight': ['error', { maxNumericValue: 500000 }],
        'largest-contentful-paint': ['error', { maxNumericValue: 2500 }],
        'interactive': ['error', { maxNumericValue: 3000 }],
        'cumulative-layout-shift': ['error', { maxNumericValue: 0.1 }],
      },
    },
  },
};
```

```yaml
# GitHub Actions
- name: Lighthouse CI
  run: |
    npm install -g @lhci/cli
    lhci autorun
```

### bundlesize

```json
// package.json
{
  "bundlesize": [
    { "path": "dist/main.*.js", "maxSize": "150 kB" },
    { "path": "dist/vendor.*.js", "maxSize": "100 kB" },
    { "path": "dist/*.css", "maxSize": "50 kB" }
  ]
}
```

```yaml
# CI 步骤
- name: Check bundle size
  run: npx bundlesize
```

### size-limit

```json
// package.json
{
  "size-limit": [
    { "path": "dist/index.js", "limit": "150 KB" },
    { "path": "dist/index.css", "limit": "50 KB" }
  ]
}
```

```yaml
# CI 步骤
- name: Check size limit
  run: npx size-limit
```

### Webpack 性能提示

```javascript
// webpack.config.js
module.exports = {
  performance: {
    maxAssetSize: 250000,      // 每个资源文件 250 KB
    maxEntrypointSize: 300000,  // 每个入口文件 300 KB
    hints: 'error',            // 超出限制则构建失败
  },
};
```

## 工具汇总

| 工具 | 测量内容 | 集成方式 |
|------|-----------------|-------------|
| **Lighthouse CI** | 性能评分、Web Vitals、资源大小 | GitHub Actions、GitLab CI |
| **bundlesize** | 单个打包文件大小 | GitHub 状态检查 |
| **size-limit** | 总包大小、执行时间 | GitHub Actions、PR 评论 |
| **Webpack performance** | 资源和入口文件大小 | 构建步骤（超出则构建失败） |
| **Import Cost**（VS Code） | 单个导入语句的大小 | 编辑器实时反馈 |
| **Bundle Analyzer** | 打包文件可视化树状图 | 手动分析 |

## 生产环境监控

CI 预算检查可在部署前捕捉回归问题，而生产环境监控则用于发现真实用户遇到的问题。

### 真实用户监控（RUM）

```javascript
// 将 Web Vitals 上报至分析系统
import { onLCP, onINP, onCLS } from 'web-vitals';

onLCP(sendToAnalytics);
onINP(sendToAnalytics);
onCLS(sendToAnalytics);
```

### 告警阈值

当 p75 指标超出预算时设置告警：

| 指标 | 告警阈值 |
|--------|----------------|
| LCP p75 | > 3s |
| INP p75 | > 300ms |
| CLS p75 | > 0.15 |
| 错误率 | > 1% |
| API p95 响应时间 | > 预算值的 2 倍 |

持续跟踪指标趋势。缓慢的指标劣化比突然的峰值更难察觉，但造成的损害同样严重。