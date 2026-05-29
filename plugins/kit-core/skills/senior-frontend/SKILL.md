---
name: senior-frontend
description: "当用户需要生产级的 React/Next.js/TypeScript 开发，且要求严格的组件架构、状态管理、性能优化以及 >85% 的测试覆盖率时使用。触发条件：React 组件开发、Next.js 页面创建、状态管理设计、前端性能审计、组件库搭建。"
---

# 高级前端工程师

## 概述

遵循结构化的三阶段工作流（上下文探索、开发、交付）交付生产级前端代码。本技能强制执行严格的质量标准，包括原子设计组件架构、全面的状态管理模式、SSR/SSG/ISR 优化，以及使用 Vitest、React Testing Library 和 Playwright 进行强制性的 >85% 测试覆盖率。

**开始声明：** “我正在使用 senior-frontend 技能进行生产级 React/TypeScript 开发。”

---

## 第一阶段：上下文探索

**目标：** 在编写任何代码之前，充分理解现有代码库。

### 行动步骤

1. 分析现有代码库结构和规范
2. 确认技术栈版本（React 18/19、Next.js 14/15、TypeScript 版本）
3. 审查现有组件库和设计系统
4. 检查当前已采用的状态管理方案
5. 了解构建工具链和 CI 流水线
6. 梳理现有测试基础设施和覆盖率情况

### 停止点 — 在满足以下条件前，请勿进入第二阶段：
- [ ] 已确认技术栈版本
- [ ] 已记录现有模式和规范
- [ ] 已梳理测试基础设施
- [ ] 已确认状态管理方案

---

## 第二阶段：开发

**目标：** 严格遵循 TypeScript、原子设计和 TDD（测试驱动开发）进行实现。

### 行动步骤

1. 遵循原子设计原则设计组件架构
2. 使用 TypeScript 严格模式进行开发
3. 编写测试代码并与实现同步进行（适当时采用 TDD）
4. 针对性能进行优化（包体积、渲染、加载）
5. 确保符合无障碍（Accessibility）标准

### 组件架构决策表（原子设计）

| 层级 | 描述 | 业务逻辑 | 示例 |
|-------|------------|---------------|---------|
| **原子** | 最小的构建单元 | 无 | Button, Input, Icon, Badge |
| **分子** | 由原子组合而成 | 极少 | FormField, SearchBar, Card |
| **有机体** | 包含业务逻辑的复杂组件 | 有 | DataTable, NavigationBar, CommentThread |
| **模板** | 不包含数据的页面结构 | 仅布局 | DashboardLayout, AuthLayout |
| **页面** | 连接数据的模板 | 数据获取 | UsersPage, SettingsPage |

### 原子组件示例

```typescript
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
}

export function Button({ variant = 'primary', size = 'md', isLoading, children, ...props }: ButtonProps) {
  return (
    <button className={cn(buttonVariants({ variant, size }))} disabled={isLoading || props.disabled} {...props}>
      {isLoading ? <Spinner size={size} /> : children}
    </button>
  );
}
```

### 状态管理决策表

| 状态类型 | 解决方案 | 适用场景 |
|------------|----------|-------------|
| 服务端状态 | React Query / TanStack Query | API 数据、缓存、同步 |
| 表单状态 | React Hook Form + Zod | 表单验证、提交 |
| 全局 UI 状态 | Zustand | 主题、侧边栏开关、模态框 |
| 局部 UI 状态 | useState / useReducer | 组件专属状态 |
| URL 状态 | nuqs / useSearchParams | 筛选条件、分页、标签页 |
| 复杂局部状态 | useReducer | 多个相关联的状态转换 |
| 共享上下文 | React Context | 主题、语言环境、认证（低频更新） |

### SSR / SSG / ISR 决策表（Next.js App Router）

| 模式 | 适用场景 | 缓存策略 |
|---------|----------|---------------|
| 静态生成 (SSG) | 内容极少变更 | 构建时 |
| 增量静态再生 (ISR) | 内容周期性变更 | 重新验证间隔 |
| 服务端渲染 (SSR) | 内容随每次请求变更 | 不缓存 |
| 客户端渲染 | 用户专属、交互式内容 | 浏览器 |

### 服务端与客户端组件决策

| 需求 | 组件类型 |
|------|---------------|
| 直接获取数据 | 服务端（默认） |
| 事件处理器（onClick, onChange） | 客户端 (`'use client'`) |
| useState / useReducer | 客户端 |
| useEffect / useLayoutEffect | 客户端 |
| 浏览器 API（window, localStorage） | 客户端 |
| 使用客户端特性的第三方库 | 客户端 |
| 无需交互 | 服务端（默认） |

### 停止点 — 在满足以下条件前，请勿进入第三阶段：
- [ ] 组件遵循原子设计层级
- [ ] 已启用 TypeScript 严格模式，无 `any` 类型
- [ ] 所有组件均已编写测试
- [ ] 无障碍性已通过验证（axe-core）

---

## 第三阶段：交付

**目标：** 验证质量门禁并准备代码审查。

### 行动步骤

1. 验证测试覆盖率是否达到 >85% 阈值
2. 运行完整的 Lint 和类型检查
3. 使用 JSDoc/TSDoc 为复杂组件编写文档
4. 为 UI 组件创建 Storybook 故事
5. 性能审计（Lighthouse、包体积分析）

### 性能检查清单

- [ ] 压缩后初始加载包体积 < 200KB
- [ ] 最大内容绘制 (LCP) < 2.5s
- [ ] 首次输入延迟 (FID) < 100ms
- [ ] 累积布局偏移 (CLS) < 0.1
- [ ] 图片：使用 next/image 并配置正确的尺寸和格式
- [ ] 字体：使用 next/font 并配置 display: swap
- [ ] 无布局抖动（批量处理 DOM 读写）
- [ ] 超过 100 项的列表使用虚拟滚动

### 覆盖率阈值

```json
{
  "coverageThreshold": {
    "global": {
      "branches": 85,
      "functions": 85,
      "lines": 85,
      "statements": 85
    }
  }
}
```

### 停止点 — 满足以下条件即视为交付完成：
- [ ] 已验证测试覆盖率 >85%
- [ ] Lint 和类型检查通过且零错误
- [ ] 性能审计已完成
- [ ] 复杂组件已编写文档

---

## 测试要求

### 单元测试（Vitest + React Testing Library）

```typescript
describe('Button', () => {
  it('renders children', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: 'Click me' })).toBeInTheDocument();
  });

  it('shows loading state', () => {
    render(<Button isLoading>Click me</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });

  it('calls onClick when clicked', async () => {
    const onClick = vi.fn();
    render(<Button onClick={onClick}>Click me</Button>);
    await userEvent.click(screen.getByRole('button'));
    expect(onClick).toHaveBeenCalledOnce();
  });
});
```

### 集成测试

- 组件组合（表单提交流程）
- 使用 MSW (Mock Service Worker) 模拟数据获取
- 路由与导航
- 错误边界与降级方案

### 端到端测试（Playwright）

```typescript
test('user can complete checkout', async ({ page }) => {
  await page.goto('/products');
  await page.getByRole('button', { name: 'Add to cart' }).first().click();
  await page.getByRole('link', { name: 'Cart' }).click();
  await expect(page.getByText('1 item')).toBeVisible();
  await page.getByRole('button', { name: 'Checkout' }).click();
});
```

---

## React Query 模式

```typescript
function useUsers(filters: UserFilters) {
  return useQuery({
    queryKey: ['users', filters],
    queryFn: () => fetchUsers(filters),
    staleTime: 5 * 60 * 1000,
    placeholderData: keepPreviousData,
  });
}

function useUpdateUser() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: updateUser,
    onMutate: async (newUser) => {
      await queryClient.cancelQueries({ queryKey: ['users'] });
      const previous = queryClient.getQueryData(['users']);
      queryClient.setQueryData(['users'], (old) =>
        old.map(u => u.id === newUser.id ? { ...u, ...newUser } : u)
      );
      return { previous };
    },
    onError: (err, newUser, context) => {
      queryClient.setQueryData(['users'], context.previous);
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

---

## 记忆化决策表

| 技术 | 适用场景 | 不适用场景 |
|-----------|----------|----------------|
| `useMemo` | 昂贵计算、依赖项引用相等性检查 | 简单计算、原始值 |
| `useCallback` | 传递给记忆化子组件的函数 | 未作为 props 传递的函数 |
| `React.memo` | 组件经常使用相同 props 重新渲染 | Props 在每次渲染时都发生变化 |
| 无（不记忆化） | 默认选项 — 不要盲目记忆化 | 务必先进行性能分析 |

---

## 反模式 / 常见错误

| 反模式 | 错误原因 | 正确做法 |
|-------------|----------------|-----------------|
| 使用 `useEffect` 获取数据 | 竞态条件、无缓存、无去重 | 使用 React Query 或服务端组件 |
| Props 穿透超过 2 层 | 强耦合、维护负担重 | 使用组合模式、Context 或 Zustand |
| 组件内包含业务逻辑 | 难以测试、无法复用 | 提取到 Hooks 或工具函数中 |
| 使用 Barrel Exports (index.ts) | 破坏 Tree-shaking、构建变慢 | 直接导入 |
| 测试实现细节 | 测试脆弱，重构时易失败 | 测试行为：用户操作与结果 |
| 任何地方使用 `any` 类型 | 违背 TypeScript 初衷 | 使用 `unknown` + 类型守卫 |
| 非动态值使用内联样式 | 不一致、难以维护 | CSS Modules、Tailwind 或 styled-components |
| 对所有内容进行记忆化 | 增加复杂度，往往反而更慢 | 先分析性能，后决定是否记忆化 |

---

## 文档查询（Context7）

使用 `mcp__context7__resolve-library-id` 后接 `mcp__context7__query-docs` 获取最新文档。返回的文档将覆盖已记忆的知识。
- `react` — 当不确定 Hooks API、组件生命周期或 React 19+ 特性时
- `next.js` — 涉及 App Router、服务端组件或 Next.js 专属 API 时
- `typescript` — 涉及高级类型模式或编译器选项时
- `tailwindcss` — 涉及工具类、配置或插件 API 时
- `vitest` — 涉及测试运行器 API、匹配器或模拟工具时

---

## 集成点

| 技能 | 关系 |
|-------|-------------|
| `testing-strategy` | 该策略定义前端测试框架 |
| `test-driven-development` | 组件通过 TDD 循环构建 |
| `react-best-practices` | 详细的 React 模式是对本技能的补充 |
| `performance-optimization` | 前端性能遵循该优化方法论 |
| `code-review` | 代码审查用于验证组件架构和测试覆盖率 |
| `clean-code` | 代码质量原则适用于组件代码 |
| `webapp-testing` | Playwright E2E 测试使用本技能的页面结构 |
| `acceptance-testing` | UI 验收标准驱动组件测试 |

---

## 核心原则

- 启用 TypeScript 严格模式，禁止使用 `any`（改用 `unknown` + 类型守卫）
- 优先使用组合而非继承
- 将测试、样式和故事文件与组件放在一起（就近存放）
- 默认使用服务端组件；仅在必要时使用客户端组件
- 在路由和功能边界处设置错误边界
- 无障碍性不是可选项（必须使用 axe-core 测试）

---

## 技能类型

**FLEXIBLE（灵活）** — 根据现有项目约定调整组件架构和状态管理。强烈推荐三阶段工作流。测试覆盖率必须瞄准 >85%。TypeScript 严格模式是不可妥协的硬性要求。