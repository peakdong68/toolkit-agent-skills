---
名称: mobile-design
描述: >
  当用户需要 React Native、Flutter 或 SwiftUI 的移动应用设计与开发模式时使用本技能 — 包括平台 HIG 合规性、手势操作和 offline-first 架构。
  触发条件: 用户提到 "mobile"、"iOS"、"Android"、"React Native"、"Flutter"、"SwiftUI"、"app design"、
  "mobile navigation"、"touch targets"、"offline-first"。
---

# 移动端设计

## 概述

设计并构建在每个平台上都具有原生体验的移动应用。本技能涵盖 React Native、Flutter 和 SwiftUI，并深度掌握平台特定的 Human Interface Guidelines（Apple HIG）和 Material Design、手势处理、响应式布局、offline-first 模式以及应用商店上架要求。

## 第一阶段：平台分析

1. 确定目标平台（iOS、Android 或两者）
2. 选择框架（React Native、Flutter、SwiftUI 或跨平台方案）
3. 审查平台特定的设计规范
4. 定义导航架构
5. 梳理离线需求

**停止 — 在设计前给出平台和框架的推荐及理由。**

### 框架选择决策表

| 需求 | React Native | Flutter | SwiftUI | Kotlin/Compose |
|---|---|---|---|---|
| 仅 iOS | 可行 | 可行 | 最佳 | 不可行 |
| 仅 Android | 可行 | 可行 | 不可行 | 最佳 |
| 跨平台 | 良好 | 最佳 | 不可行 | 不可行 |
| 原生性能关键 | 尚可 | 良好 | 最佳 | 最佳 |
| 现有 React Web 团队 | 最佳 | 学习曲线 | 学习曲线 | 学习曲线 |
| 复杂动画 | 良好 | 最佳 | 良好 | 良好 |
| 快速原型 | 良好 | 良好 | 最佳（iOS） | 尚可 |
| 大型现有代码库（JS） | 最佳 | 重写 | 重写 | 重写 |

## 第二阶段：设计实现

1. 构建包含平台变体的组件库
2. 实现导航（tab bar、stack、drawer）
3. 处理安全区域和刘海屏
4. 添加手势识别器
5. 实现手机/平板响应式布局

**停止 — 提交导航架构和组件清单以供审查。**

### 平台特定的 HIG 合规性

#### Apple Human Interface Guidelines

| 领域 | 规范 |
|---|---|
| 导航 | UINavigationController（push/pop），底部 tab bar（最多 5 个） |
| 字体 | SF Pro / SF Pro Rounded，支持 Dynamic Type（全部 11 种尺寸） |
| 安全区域 | 遵循 `safeAreaInsets` — 切勿延伸到刘海/Home Indicator 下方 |
| 手势 | 边缘右滑返回，长按显示上下文菜单 |
| 触感反馈 | UIFeedbackGenerator（impact、selection、notification） |
| 颜色 | 语义系统颜色（`label`、`secondaryLabel`、`systemBackground`） |
| 模态框 | Sheets（`.sheet`、`.fullScreenCover`），支持下拉关闭 |
| 列表 | 设置使用 Grouped inset，内容 feed 使用 Plain |
| 图标 | SF Symbols 库（5000+ 图标，支持可变粗细和尺寸） |

#### Material Design（Android）

| 领域 | 规范 |
|---|---|
| 导航 | 底部导航栏、导航抽屉、顶部应用栏 |
| 字体 | Roboto / 产品字体，Material 字体刻度 |
| 全屏沉浸 | 绘制到系统栏后方，处理 window insets |
| 手势 | 预测性返回手势（Android 14+），滑动关闭 |
| 触感反馈 | HapticFeedbackConstants（点击、长按、键盘） |
| 颜色 | Material You 动态颜色（从壁纸提取），色调调色板 |
| 组件 | FAB、snackbar、bottom sheet、chips |
| 动效 | 共享元素转场、容器变换 |

### 跨平台模式决策表

| 功能 | iOS 模式 | Android 模式 |
|---|---|---|
| 返回导航 | 从左边缘滑动 | 系统返回按钮 |
| 主要操作 | 右侧导航栏按钮 | FAB |
| 警告框 | UIAlertController | MaterialAlertDialog |
| 加载中 | UIActivityIndicator | CircularProgressIndicator |
| 分段选择 | UISegmentedControl | Tabs / Chips |
| 日期选择器 | 滚轮选择器 | 日历选择器 |
| 下拉刷新 | 原生支持 | SwipeRefreshLayout |
| 上下文菜单 | 长按 + 触感反馈 | 长按 + 弹出窗 |

### 安全区域处理

#### React Native

```jsx
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';

function Screen() {
  const insets = useSafeAreaInsets();
  return (
    <View style={{ flex: 1, paddingTop: insets.top, paddingBottom: insets.bottom }}>
      {/* Content */}
    </View>
  );
}
```

#### Flutter

```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: // Content
    ),
  );
}
```

#### SwiftUI

```swift
var body: some View {
  VStack {
    // Content automatically respects safe areas
  }
  .ignoresSafeArea(.keyboard) // Only ignore keyboard if needed
}
```

### 手势导航模式

| 手势 | 用途 | 最小目标区域 |
|---|---|---|
| 点按 | 主要操作 | 44x44pt |
| 长按 | 上下文菜单 / 次要操作 | 44x44pt |
| 横向滑动 | 导航、关闭、显示操作 | 整行 |
| 纵向滑动 | 滚动、下拉刷新、关闭 sheet | 整个区域 |
| 捏合 | 缩放图片/地图 | 内容区域 |
| 拖拽/平移 | 重新排序、移动元素 | 拖拽手柄 |

### 触摸目标规则

| 规则 | 值 |
|---|---|
| 最小尺寸（iOS） | 44x44pt |
| 最小尺寸（Android） | 48x48dp |
| 最小间距 | 目标之间 8pt |
| 视觉 vs 触摸 | 视觉可以更小；使用 padding 扩展触摸区域 |
| 主要操作 | 屏幕底部 1/3 区域（拇指热区） |

## 第三阶段：平台精细化

1. 平台特定的动画和转场
2. 集成触感反馈
3. 应用图标和启动屏幕
4. 暗黑模式和 Dynamic Type 支持
5. 应用商店元数据和截图

**停止 — 在宣布完成前在真机上测试。**

### 响应式布局决策表

| 设备形态 | 布局 | 导航 |
|---|---|---|
| 手机竖屏 | 单列 | 底部 tabs |
| 手机横屏 | 单列或分屏 | 侧边 tabs |
| 平板竖屏 | 双列 | 侧边栏 |
| 平板横屏 | 三列 | 持久侧边栏 |

#### React Native 响应式

```javascript
import { useWindowDimensions } from 'react-native';

function useResponsive() {
  const { width } = useWindowDimensions();
  return {
    isPhone: width < 768,
    isTablet: width >= 768 && width < 1024,
    isDesktop: width >= 1024,
    columns: width < 768 ? 1 : width < 1024 ? 2 : 3,
  };
}
```

#### Flutter 响应式

```dart
class ResponsiveLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) return MobileLayout();
        if (constraints.maxWidth < 1200) return TabletLayout();
        return DesktopLayout();
      },
    );
  }
}
```

### Offline-First 架构

| 层级 | 模式 | 实现 |
|---|---|---|
| 数据 | 本地优先 | SQLite/Realm 作为主存储，服务器作为同步目标 |
| 更新 | 乐观更新 | 本地立即应用，后台同步 |
| 冲突 | 解决策略 | 后写胜出或字段级合并 |
| 队列 | 持久化操作 | 存储待处理操作，连接恢复后重试 |
| 缓存 | stale-while-revalidate | 先返回缓存，后台刷新 |

#### 实现检查清单

- [ ] 网络状态检测和 UI 指示器
- [ ] 所有关键数据的本地数据库
- [ ] 待写入操作的操作队列
- [ ] 指数退避重试逻辑
- [ ] 冲突检测和解决策略
- [ ] 缓存失效策略
- [ ] UI 中的同步状态指示器
- [ ] 仅网络功能的优雅降级

### 应用商店指南摘要

| 要求 | Apple App Store | Google Play Store |
|---|---|---|
| 截图 | 必须提供 6.7" 和 5.5"，12.9" iPad | 每设备最少 2 张，最多 8 张 |
| 应用图标 | 1024x1024px，无透明度，无圆角 | 512x512px，推荐自适应图标 |
| 隐私 | 必需提供隐私标签 | 必需提供数据安全部分 |
| 审核时间 | 通常 24-48 小时 | 数小时到数天 |
| 常见拒绝原因 | 崩溃、占位内容 | 政策违规、崩溃 |

### 性能目标

| 指标 | 目标 |
|---|---|
| 冷启动 | < 2 秒 |
| 屏幕转场 | < 300ms |
| 触摸响应 | < 100ms |
| 滚动帧率 | 60fps（无掉帧） |
| 内存占用 | < 200MB 基准 |
| 应用大小 | < 50MB 下载大小 |

## 反模式 / 常见错误

| 反模式 | 错误原因 | 正确做法 |
|---|---|---|
| 在移动端使用 Web 模式（悬停状态） | 触摸设备没有悬停 | 使用按下/点按状态 |
| 触摸目标过小（< 44pt） | 令人沮丧，无障碍失败 | 最小 44x44pt 触摸区域 |
| 在 Android 上使用 iOS 风格按钮 | 感觉陌生，让用户困惑 | 使用平台原生组件 |
| 为单一屏幕尺寸做固定布局 | 在平板和折叠屏上损坏 | 使用断点的响应式布局 |
| 在主线程执行 I/O 操作 | UI 卡顿，ANR 对话框 | 异步 I/O，后台线程 |
| 不处理键盘出现 | 内容被键盘遮挡 | 键盘显示时调整布局 |
| 假设始终有网络连接 | 离线时应用崩溃或卡死 | Offline-first 架构 |
| 使用像素值而非 dp/pt | 不同屏幕上尺寸不同 | 使用密度无关单位 |
| 跳过触感反馈 | 应用感觉廉价且无响应 | 为关键交互添加 haptics |

## 文档查询（Context7）

使用 `mcp__context7__resolve-library-id` 然后 `mcp__context7__query-docs` 获取最新文档。返回的文档将覆盖记忆中的知识。
- `react-native` — 查询组件 API、导航或平台特定模块
- `flutter` — 查询 widget 目录、状态管理或平台通道

---

## 集成点

| 技能 | 集成方式 |
|---|---|
| `ui-ux-pro-max` | 调色板、字体、UX 指南 |
| `ui-design-system` | 适配移动端的设计令牌 |
| `canvas-design` | 移动端数据可视化和图表 |
| `ux-researcher-designer` | 移动端可用性测试 |
| `senior-frontend` | React Native 组件实现 |
| `deployment` | 应用商店上架流水线 |
| `performance-optimization` | 移动端性能分析 |

## 技能类型

**灵活** — 根据所选框架和目标平台调整模式。针对单一平台时应遵循平台特定指南；跨平台应用可以有思考地融合各方惯例。