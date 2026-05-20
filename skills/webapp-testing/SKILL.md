---
name: webapp-testing
description: "当用户需要基于 Playwright 的 Web 应用程序测试时使用——包括截图、浏览器日志分析、交互验证、视觉回归测试、无障碍访问审计和网络请求模拟。触发场景：E2E 测试搭建、视觉回归测试、无障碍访问审计、Playwright 配置、页面对象模型创建、CI 测试流水线。"
---

# Web 应用程序测试

## 概述

使用 Playwright 作为主要工具进行全面的 Web 应用程序测试。本技能涵盖端到端测试工作流，包括用于视觉验证的截图捕获、浏览器控制台日志分析、用户交互模拟、视觉回归测试、使用 axe-core 进行无障碍访问审计、网络请求模拟以及移动视口测试。

**开始时声明：** "我正在使用 webapp-testing 技能进行基于 Playwright 的 Web 应用程序测试。"

---

## 第一阶段：测试规划

**目标：** 确定测试内容并搭建基础设施。

### 操作

1. 识别需要测试的关键用户流程
2. 定义测试环境和视口
3. 设置测试夹具和数据
4. 配置 Playwright 项目设置
5. 建立视觉基线截图

### 用户流程优先级决策表

| 流程类型 | 优先级 | 测试深度 |
|-----------|----------|-----------|
| 身份验证（登录/登出/注册） | 关键 | 完整正常路径 + 错误路径 |
| 核心业务工作流程（购买、提交） | 关键 | 完整正常路径 + 错误路径 + 边界情况 |
| 导航和路由 | 高 | 所有主要路由 |
| 搜索和过滤 | 高 | 常见查询 + 空状态 |
| 设置和个人资料 | 中 | 正常路径 |
| 管理/后台 | 中 | 仅关键操作 |

### 停止 — 在完成以下事项前，请勿进入第二阶段：
- [ ] 已识别并优先排序关键用户流程
- [ ] 已定义测试环境和视口
- [ ] Playwright 配置已就绪
- [ ] 已定义测试数据策略

---

## 第二阶段：测试实现

**目标：** 使用页面对象模型和可访问定位器编写测试。

### 操作

1. 为关键页面编写页面对象模型
2. 实现端到端测试场景
3. 添加视觉回归快照
4. 集成无障碍访问检查
5. 配置网络请求模拟以实现隔离测试

### Playwright 配置

```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
  ],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'mobile-chrome', use: { ...devices['Pixel 5'] } },
    { name: 'mobile-safari', use: { ...devices['iPhone 13'] } },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### 页面对象模型

```typescript
class LoginPage {
  constructor(private page: Page) {}

  readonly emailInput = this.page.getByLabel('Email');
  readonly passwordInput = this.page.getByLabel('Password');
  readonly submitButton = this.page.getByRole('button', { name: 'Sign in' });
  readonly errorMessage = this.page.getByRole('alert');

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }
}
```

### 定位器选择决策表

| 定位器类型 | 优先级 | 使用场景 |
|-------------|----------|-------------|
| `getByRole` | 首选 | 任何具有 ARIA 角色的元素（按钮、链接、标题） |
| `getByLabel` | 次选 | 带有标签的表单字段 |
| `getByPlaceholder` | 第三选择 | 没有可见标签的字段 |
| `getByText` | 第四选择 | 非交互式可见文本 |
| `getByTestId` | 最后手段 | 当没有可用的可访问定位器时 |
| CSS 选择器 / XPath | 永不使用 | 会因样式更改而失效 |

### 停止 — 在完成以下事项前，请勿进入第三阶段：
- [ ] 关键页面已存在页面对象模型
- [ ] 测试仅使用可访问定位器
- [ ] 已建立视觉基线
- [ ] 已集成无障碍访问检查
- [ ] 已为隔离测试配置网络请求模拟

---

## 第三阶段：CI 集成

**目标：** 在 CI 中配置可靠、快速的测试执行。

### 操作

1. 配置无头浏览器执行
2. 设置截图产物收集
3. 配置重试和波动检测
4. 添加报告功能（HTML 报告、JUnit XML）
5. 设置视觉差异审查流程

### CI 配置检查清单

- [ ] 测试在 CI 中以无头模式运行
- [ ] 启用重试（CI 环境下重试 2 次）
- [ ] 失败时收集截图和视频产物
- [ ] 输出 JUnit XML 以供 CI 集成
- [ ] 生成 HTML 报告供人工审查
- [ ] 合并前审查视觉差异快照

### 停止 — 当满足以下条件时，CI 集成完成：
- [ ] 测试在 CI 流水线中可靠运行
- [ ] 失败时能收集产物
- [ ] 波动测试已被识别并修复（而非跳过）

---

## 截图捕获模式

### 全页截图

```typescript
test('homepage renders correctly', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveScreenshot('homepage.png', {
    fullPage: true,
    maxDiffPixelRatio: 0.01,
  });
});
```

### 元素级截图

```typescript
test('navigation bar matches design', async ({ page }) => {
  await page.goto('/');
  const nav = page.getByRole('navigation');
  await expect(nav).toHaveScreenshot('navbar.png');
});
```

### 动态内容遮罩

```typescript
test('dashboard layout', async ({ page }) => {
  await page.goto('/dashboard');
  await expect(page).toHaveScreenshot('dashboard.png', {
    mask: [
      page.locator('[data-testid="timestamp"]'),
      page.locator('[data-testid="user-avatar"]'),
      page.locator('.chart-container'),
    ],
    animations: 'disabled',
  });
});
```

---

## 浏览器日志分析

```typescript
test('no console errors on page load', async ({ page }) => {
  const consoleErrors: string[] = [];

  page.on('console', msg => {
    if (msg.type() === 'error') consoleErrors.push(msg.text());
  });
  page.on('pageerror', error => {
    consoleErrors.push(error.message);
  });

  await page.goto('/');
  await page.waitForLoadState('networkidle');
  expect(consoleErrors).toEqual([]);
});
```

---

## 使用 axe-core 进行无障碍访问测试

```typescript
import AxeBuilder from '@axe-core/playwright';

test('page has no accessibility violations', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page })
    .withTags(['wcag2a', 'wcag2aa', 'wcag21aa'])
    .exclude('.third-party-widget')
    .analyze();
  expect(results.violations).toEqual([]);
});
```

---

## 网络请求模拟

```typescript
test('displays users from API', async ({ page }) => {
  await page.route('**/api/users', async route => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify([{ id: 1, name: 'Alice' }, { id: 2, name: 'Bob' }]),
    });
  });
  await page.goto('/users');
  await expect(page.getByText('Alice')).toBeVisible();
});

test('handles API errors gracefully', async ({ page }) => {
  await page.route('**/api/users', route =>
    route.fulfill({ status: 500, body: 'Internal Server Error' })
  );
  await page.goto('/users');
  await expect(page.getByText('Something went wrong')).toBeVisible();
});
```

---

## 移动视口测试

```typescript
test.describe('mobile responsive', () => {
  test.use({ viewport: { width: 375, height: 667 } });

  test('hamburger menu works', async ({ page }) => {
    await page.goto('/');
    await expect(page.getByRole('navigation')).not.toBeVisible();
    await page.getByRole('button', { name: 'Menu' }).click();
    await expect(page.getByRole('navigation')).toBeVisible();
  });
});
```

---

## 测试组织

```
tests/
  e2e/
    auth/
      login.spec.ts
      register.spec.ts
    checkout/
      cart.spec.ts
      payment.spec.ts
    fixtures/
      test-data.ts
      auth.setup.ts
    pages/
      login.page.ts
      dashboard.page.ts
    utils/
      helpers.ts
```

---

## 反模式 / 常见错误

| 反模式 | 错误原因 | 正确做法 |
|-------------|----------------|-----------------|
| CSS 选择器或 XPath | 会因样式更改而失效 | 使用可访问定位器（role、label、text） |
| `page.waitForTimeout()` | 任意延迟，导致测试波动 | 使用 `expect().toBeVisible()` 或类似断言 |
| 详细测试第三方组件 | 不是你要测试的代码 | 测试你的集成，而非其内部实现 |
| 硬编码测试数据 | 在不同环境中会失效 | 使用夹具和工厂函数 |
| 测试依赖执行顺序 | 脆弱，难以调试 | 每个测试必须独立 |
| 忽略波动测试 | 侵蚀对测试套件信任 | 修复根本原因或隔离处理 |
| 截图未遮罩动态内容 | 总是不同，总是失败 | 遮罩时间戳、头像、图表等 |
| 无无障碍访问检查 | 遗漏关键质量关卡 | 每个页面都运行 axe-core |

---

## 集成点

| 技能 | 关系 |
|-------|-------------|
| `senior-frontend` | E2E 测试用于测试前端组件 |
| `testing-strategy` | E2E 测试位于测试金字塔顶端 |
| `acceptance-testing` | 用户流程测试可作为验收测试 |
| `performance-optimization` | 性能预算可在 E2E 中验证 |
| `code-review` | 审查时检查测试是否使用可访问定位器 |
| `security-review` | 在 E2E 中测试安全头和认证流程 |

---

## 质量检查清单

- [ ] 所有关键用户流程已覆盖
- [ ] 测试使用可访问定位器（role、label、text）
- [ ] 隔离测试使用网络请求模拟
- [ ] 视觉回归基线已审查并批准
- [ ] 所有页面已进行无障碍访问扫描
- [ ] 响应式功能已进行移动视口测试
- [ ] 无 `waitForTimeout`（使用正确断言）
- [ ] CI 流水线已配置重试机制
- [ ] 失败时收集截图产物
- [ ] 波动测试已被识别并修复（而非跳过）

---

## 技能类型

**灵活** — 根据项目的关键路径调整测试深度。强烈推荐使用页面对象模型模式和可访问定位器。每个页面必须进行无障碍访问检查。视觉回归基线必须在合并前审查。