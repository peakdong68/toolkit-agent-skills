---
name: react-best-practices
description: "当用户需要 React 特定模式时使用——钩子（hooks）、组件组合、服务器组件、错误边界、渲染优化和测试策略。触发条件：钩子设计、组件组合、服务器组件与客户端组件决策、错误边界放置、上下文优化、渲染性能。"
---

# React 最佳实践

## 概述

应用现代 React 模式来构建可维护、高性能且可测试的应用程序。本技能涵盖 React 18/19 特性，包括服务器组件、钩子最佳实践、组件组合、错误边界、Suspense、上下文优化和渲染性能。它是对高级前端技能的 React 专项深度补充。

**开始时声明：** "我正在使用 react-best-practices 技能处理 React 特定模式。"

---

## 阶段 1：分析组件需求

**目标：** 在编码前理解组件的职责和数据需求。

### 操作

1. 识别组件的单一职责
2. 确定数据需求（服务器数据 vs 客户端数据）
3. 选择服务器组件（默认）或客户端组件
4. 识别状态管理需求
5. 规划错误和加载状态

### 服务器组件 vs 客户端组件决策表

| 需求 | 组件类型 | 原因 |
|------|---------------|--------|
| 直接数据获取（数据库、API） | 服务器组件（默认） | 无需客户端 JS，更快 |
| 事件处理函数（onClick、onChange） | 客户端组件（`'use client'`） | 需要浏览器交互性 |
| useState / useReducer | 客户端组件 | 状态需要客户端运行时 |
| useEffect / useLayoutEffect | 客户端组件 | 副作用需要客户端环境 |
| 浏览器 API（window、localStorage） | 客户端组件 | 服务器端无浏览器环境 |
| 使用客户端特性的第三方库 | 客户端组件 | 库需要客户端环境 |
| 无需交互性 | 服务器组件（默认） | 包体积更小，加载更快 |

### 停止 — 在完成以下事项前请勿进入阶段 2：
- [ ] 组件职责已定义（单一目的）
- [ ] 服务器组件与客户端组件决策已完成并附理由
- [ ] 数据需求已映射完成

---

## 阶段 2：采用适当模式实现

**目标：** 根据组件需求应用正确的 React 模式。

### 操作

1. 应用适当的组合模式
2. 正确实现钩子
3. 添加错误边界和 Suspense
4. 在性能分析显示需要时优化渲染
5. 编写验证行为的测试

### 停止 — 在完成以下事项前请勿进入阶段 3：
- [ ] 模式与组件实际需求匹配
- [ ] 无不必要的复杂性（避免过早优化）
- [ ] 测试覆盖用户可见行为

---

## 阶段 3：测试与验证

**目标：** 通过测试验证组件行为。

### 操作

1. 使用可访问性查询编写测试
2. 测试用户交互和结果
3. 测试错误和加载状态
4. 验证可访问性

### 查询优先级（React Testing Library）

| 优先级 | 查询方法 | 适用场景 |
|----------|-------|---------|
| 第 1 优先 | `getByRole` | 任何具有 ARIA 角色的元素 |
| 第 2 优先 | `getByLabelText` | 表单字段 |
| 第 3 优先 | `getByPlaceholderText` | 无标签的字段 |
| 第 4 优先 | `getByText` | 非交互元素 |
| 最后 | `getByTestId` | 其他方法均不适用时 |

### 停止 — 测试完成条件：
- [ ] 用户交互产生预期结果
- [ ] 错误状态已测试
- [ ] 可访问性检查通过

---

## 钩子最佳实践

### useState

```typescript
// 基于先前状态的函数式更新
setCount(prev => prev + 1);

// 昂贵初始值的惰性初始化
const [data, setData] = useState(() => computeExpensiveInitialValue());

// 关联状态分组
const [form, setForm] = useState({ name: '', email: '', role: 'user' });
```

### useEffect

#### 依赖数组规则

- 包含组件作用域中所有随时间变化的值
- effect 内部的函数应在 effect 内部定义或用 useCallback 包装
- 切勿虚假声明依赖项（ESLint: `react-hooks/exhaustive-deps`）

#### 清理模式

```typescript
useEffect(() => {
  const controller = new AbortController();
  async function fetchData() {
    try {
      const res = await fetch(url, { signal: controller.signal });
      const data = await res.json();
      setData(data);
    } catch (e) {
      if (e.name !== 'AbortError') setError(e);
    }
  }
  fetchData();
  return () => controller.abort();
}, [url]);
```

#### 何时不应使用 useEffect

| 替代 useEffect 用于... | 使用此方案 |
|----------------------------|----------|
| 数据获取 | React Query、SWR 或服务器组件 |
| 数据转换 | 在渲染期间计算 |
| 用户事件 | 事件处理函数 |
| 同步外部存储 | `useSyncExternalStore` |

### 自定义钩子规则

- 名称以 `use` 开头
- 封装可复用的有状态逻辑
- 每个关注点一个钩子
- 返回值超过 2 个时使用对象（而非数组）

```typescript
function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debouncedValue;
}
```

---

## 组件组合模式

### 复合组件

```typescript
function Tabs({ children, defaultValue }: TabsProps) {
  const [activeTab, setActiveTab] = useState(defaultValue);
  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div role="tablist">{children}</div>
    </TabsContext.Provider>
  );
}

Tabs.Tab = function Tab({ value, children }: TabProps) {
  const { activeTab, setActiveTab } = useTabsContext();
  return (
    <button role="tab" aria-selected={activeTab === value} onClick={() => setActiveTab(value)}>
      {children}
    </button>
  );
};

Tabs.Panel = function Panel({ value, children }: PanelProps) {
  const { activeTab } = useTabsContext();
  if (activeTab !== value) return null;
  return <div role="tabpanel">{children}</div>;
};
```

### 组合决策表

| 模式 | 适用场景 | 示例 |
|---------|----------|---------|
| 复合组件 | 共享隐式状态的关联组件 | Tabs、Accordion、Menu |
| 插槽（Children） | 复杂内容布局 | 含 Header/Body/Footer 的 Card |
| 渲染属性 | 子组件需要父组件数据以实现灵活渲染 | 带自定义渲染的 DataFetcher |
| 高阶组件 | 横切关注点（遗留方案） | withAuth、withTheme |
| 自定义钩子 | 无需 UI 的可复用有状态逻辑 | useDebounce、useLocalStorage |

### 插槽模式

```typescript
// 对于复杂内容，优先使用组合而非属性传递
// 不佳做法
<Card title="Hello" subtitle="World" icon={<Star />} actions={<Button>Edit</Button>} />

// 推荐做法
<Card>
  <Card.Header>
    <Card.Icon><Star /></Card.Icon>
    <Card.Title>Hello</Card.Title>
  </Card.Header>
  <Card.Actions>
    <Button>Edit</Button>
  </Card.Actions>
</Card>
```

---

## 错误边界

### 放置策略决策表

| 层级 | 目的 | 示例 |
|-------|---------|---------|
| 路由层级 | 捕获页面级崩溃 | Next.js 中的 `error.tsx` |
| 功能层级 | 隔离功能模块故障 | 包裹每个主要区块 |
| 数据层级 | 包裹异步数据组件 | 围绕 Suspense 边界 |
| 切勿在叶子节点层级 | 粒度过细，增加噪音 | 不要包裹单个按钮 |

---

## Suspense

```typescript
// 嵌套 Suspense 实现细粒度加载
<Suspense fallback={<PageSkeleton />}>
  <Header />
  <Suspense fallback={<SidebarSkeleton />}>
    <Sidebar />
  </Suspense>
  <Suspense fallback={<ContentSkeleton />}>
    <MainContent />
  </Suspense>
</Suspense>
```

---

## 上下文优化

### 问题：上下文导致不必要的重新渲染

### 解决方案决策表

| 技术 | 适用场景 | 示例 |
|-----------|----------|---------|
| 按更新频率拆分上下文 | 某些值频繁更新，某些很少更新 | ThemeContext（低频）vs UIStateContext（高频） |
| 记忆上下文值 | Provider 使用相同数据重新渲染时 | `useMemo(() => ({ state, dispatch }), [state])` |
| 使用选择器（Zustand/Jotai） | 需要细粒度订阅时 | `useStore(state => state.user.name)` |
| 状态提升 | 仅父组件需要重新渲染时 | 将数据作为属性传递给已记忆的子组件 |

---

## 渲染优化

### 记忆化决策表

| 技术 | 适用场景 | 切勿使用场景 |
|-----------|----------|----------------|
| `React.memo` | 频繁渲染且属性相同，且重新渲染开销大时 | 属性每次渲染都变化 |
| `useMemo` | 昂贵计算 OR 依赖项需要引用相等性时 | 简单计算 |
| `useCallback` | 为记忆的子组件提供稳定的函数引用时 | 函数未作为属性传递 |
| 无（默认） | 始终从此开始 | 过早优化 |

**规则：** 记忆化前先进行性能分析。过早记忆化是最常见的 React 反模式。

### 虚拟化

对于超过 100 项的列表：
```typescript
import { useVirtualizer } from '@tanstack/react-virtual';
```

---

## 服务器组件规则

- 不能使用钩子
- 不能使用浏览器 API
- 不能将函数作为属性传递给客户端组件
- 可以导入并渲染客户端组件
- 可以将可序列化数据传递给客户端组件

```typescript
// 服务器组件 — 直接获取数据
async function UserProfile({ userId }: { userId: string }) {
  const user = await db.user.findUnique({ where: { id: userId } });
  return (
    <div>
      <h1>{user.name}</h1>
      <UserActions userId={userId} /> {/* 客户端组件子元素 */}
    </div>
  );
}

// 客户端组件 — 处理交互性
'use client';
function UserActions({ userId }: { userId: string }) {
  const [isFollowing, setIsFollowing] = useState(false);
  return <Button onClick={() => toggleFollow(userId)}>Follow</Button>;
}
```

---

## 反模式 / 常见错误

| 反模式 | 错误原因 | 正确做法 |
|-------------|----------------|-----------------|
| 使用 `useEffect` 获取数据 | 竞态条件、无缓存、无去重 | React Query 或服务器组件 |
| 属性传递超过 2 层 | 耦合紧密、维护困难 | 组合、上下文或 Zustand |
| 存储派生状态 | 可计算的状态是不必要的状态 | 在渲染期间计算 |
| 使用 `useEffect` 同步属性中的状态 | 不必要的 effect、闭包过时 | 在渲染期间派生或使用 key 属性 |
| 单体组件（> 200 行） | 难以阅读、测试、维护 | 提取子组件 |
| 动态列表使用索引作为 key | 错误的协调、状态过时 | 稳定的唯一 ID |
| 直接操作 DOM | 绕过 React 协调机制 | 谨慎使用 refs，优先使用状态 |
| 直接测试状态值 | 实现细节、重构时易失效 | 测试用户可见结果 |
| 处处记忆化 | 增加复杂性，通常更慢 | 先分析性能，再优化 |

---

## 文档查阅（Context7）

使用 `mcp__context7__resolve-library-id` 然后 `mcp__context7__query-docs` 获取最新文档。返回的文档优先于记忆知识。
- `react` — 用于钩子、上下文、suspense、服务器组件或 React 19+ 变更
- `next.js` — 用于 App Router 模式、数据获取或服务器操作

---

## 集成点

| 技能 | 关系 |
|-------|-------------|
| `senior-frontend` | 前端技能使用本技能的 React 模式 |
| `testing-strategy` | React 测试遵循策略金字塔 |
| `clean-code` | 组件代码遵循整洁代码原则 |
| `performance-optimization` | React 渲染优化遵循测量方法论 |
| `webapp-testing` | E2E 测试验证 React 组件行为 |
| `code-review` | 代码审查检查 React 反模式 |
| `acceptance-testing` | UI 验收标准驱动组件测试 |

---

## 技能类型

**灵活（FLEXIBLE）** — 根据具体的 React 版本、项目结构和团队约定应用这些模式。原则保持一致，但实现细节可能有所不同。优化前务必先进行性能分析。