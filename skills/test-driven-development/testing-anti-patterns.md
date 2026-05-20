# 测试反模式

测试驱动开发技能的参考文档。这些是常见的会降低测试质量、增加维护负担并削弱对测试套件信心的模式。

---

## 1. 测试实现细节而非行为

**问题：** 测试验证的是某事物"如何"工作，而不是它"做什么"。这些测试只要进行重构就会失败，即使行为没有改变。

**症状：**
- 测试断言内部方法调用
- 测试检查私有状态或内部数据结构
- 测试验证操作顺序而非结果
- 重构生产代码会破坏测试，即使行为完全相同

**反模式示例：**
```
# 错误：测试实现
def test_sort_uses_quicksort():
    sorter = Sorter()
    sorter.sort(data)
    assert sorter._algorithm_used == "quicksort"

# 正确：测试行为
def test_sort_returns_elements_in_ascending_order():
    sorter = Sorter()
    result = sorter.sort([3, 1, 2])
    assert result == [1, 2, 3]
```

**修复方法：** 问自己"如果我改变实现但保持相同的输入和输出，这个测试还会通过吗？"如果答案是否定的，那么你正在测试实现细节。

---

## 2. 过度使用模拟（Mock）

**问题：** 使用了过多的模拟对象，导致测试不再验证真实行为。测试通过了，但真实系统可能已经损坏。

**症状：**
- 模拟设置代码比实际测试代码还多
- 模拟了本应被测试的对象
- 模拟返回模拟再返回模拟（模拟链）
- 测试通过但集成失败
- 更改任何接口都会破坏数十个模拟对象

**经验法则：**
- 在边界处模拟外部服务（API、数据库、文件系统）
- 不要模拟被测单元（Unit Under Test）
- 不要模拟值对象或简单数据结构
- 对于复杂依赖，优先使用假对象（内存实现）而非模拟对象

**修复方法：** 如果你的测试包含超过 3 个模拟对象，你的代码可能存在设计问题。重构以减少耦合，而不是添加更多模拟对象。

---

## 3. 脆弱的选择器

**问题：** 测试依赖于特定的 CSS 选择器、DOM 结构、XPath 或其他频繁变化的结构细节。

**症状：**
- 当 UI 布局改变但功能未变时测试失败
- 使用类似 `div > div:nth-child(3) > span.class-name` 的选择器
- CSS 类名重命名后测试失败
- 团队避免修改 UI，因为测试会失败

**修复方法：**
- 使用 `data-testid` 属性作为测试选择器
- 尽可能使用可访问的选择器（role、label 文本）
- 通过用户可见文本或语义含义进行选择
- 避免通过 CSS 类、标签嵌套或位置索引进行选择

---

## 4. 测试间依赖

**问题：** 测试依赖于其他测试先运行，或共享可变状态。

**症状：**
- 按顺序运行时测试通过，但单独运行时失败
- 单独运行时通过，但一起运行时失败
- 测试 A 设置的状态被测试 B 依赖
- 测试之间共享数据库或文件状态
- 测试并行运行时结果发生变化

**修复方法：**
- 每个测试必须设置自己的状态（Arrange 阶段）
- 每个测试必须清理自身状态（或使用每测试隔离）
- 使用 `beforeEach`/`setUp` 进行通用设置，而非共享测试状态
- 以随机顺序运行测试以发现隐藏依赖
- 永远不要依赖测试执行顺序

---

## 5. 缓慢的测试套件

**问题：** 测试套件运行时间过长，导致开发人员停止运行它，或仅在 CI 中运行，从而延迟反馈。

**症状：**
- 单元测试套件耗时超过 30 秒
- 开发人员跳过在本地运行测试
- "让 CI 来捕获问题"的心态
- 单元测试中包含真实的网络调用、文件 I/O 或数据库操作
- 测试中包含 sleep/wait 调用

**原因与修复方法：**

| 原因 | 修复方法 |
|-------|-----|
| 真实数据库调用 | 使用内存数据库或仓储假对象 |
| 真实网络调用 | 在边界处模拟 HTTP 客户端 |
| Sleep 语句 | 使用基于事件的等待或模拟计时器 |
| 昂贵的设置 | 懒初始化，共享不可变夹具 |
| 过多的集成测试 | 尽可能转换为单元测试 |
| 大型测试数据 | 使用最小数据集、构建器模式 |

**目标：** 单元测试套件应在 10 秒内完成。集成测试在 60 秒内完成。

---

## 6. 过度使用快照测试

**问题：** 将快照测试作为特定断言的懒惰替代品。快照捕获所有内容，使得不清楚哪些行为是重要的。

**症状：**
- 快照文件包含数百或数千行内容
- 开发人员不审查更改就直接更新快照
- 测试失败时习惯性运行 `--update-snapshots`
- 没人知道快照实际在测试什么
- 快照差异是噪声而非信号

**快照测试适用的场景：**
- 序列化格式（JSON API 响应、GraphQL 模式）
- 复杂但必须保持稳定的生成输出
- 视觉回归测试（配合适当的审查工具）

**快照测试不适用的场景：**
- 测试业务逻辑
- 测试单个组件行为
- 测试任何可以编写特定断言的内容

**修复方法：** 对于每个快照测试，问自己："如果这个快照发生变化，哪些具体行为会出错？"改为针对该行为编写定向断言。

---

## 7. 测试第三方代码

**问题：** 编写测试来验证你的依赖项是否正常工作。这是依赖项的责任，不是你的。

**症状：**
- 为标准库函数编写测试
- 测试验证 ORM 查询行为
- 测试检查 HTTP 客户端是否正确发送请求
- 测试验证框架路由是否正常工作

**应该测试什么：**
- 测试你使用依赖项的代码
- 测试你的包装器和适配器
- 测试依赖项失败时你的错误处理
- 测试你对依赖项的配置

**示例：**
```
# 错误：测试 HTTP 库是否工作
def test_requests_library_sends_get():
    response = requests.get("https://example.com")
    assert response.status_code == 200

# 正确：测试使用 HTTP 库的你的代码
def test_user_service_returns_user_on_success():
    http_client = FakeHttpClient(response={"id": 1, "name": "Alice"})
    service = UserService(http_client)
    user = service.get_user(1)
    assert user.name == "Alice"
```

---

## 8. 上帝测试（在一个测试中测试太多内容）

**问题：** 单个测试验证多个行为，导致不清楚什么失败了以及为什么失败。

**症状：**
- 测试名称包含"and"（例如 `test_create_user_and_send_email_and_update_log`）
- 每个测试超过 3 个断言（除非断言单个结果的多个属性）
- 测试包含多个 Act 阶段
- 测试失败信息无法告诉你实际哪里出错
- 测试代码超过 20 行

**修复方法：**
- 每个测试只验证一个行为
- 每个测试只包含一个 Act（动作）
- 以被验证的具体场景命名测试
- 将上帝测试拆分为多个聚焦的测试

**示例：**
```
# 错误：上帝测试
def test_user_registration():
    user = register("alice@test.com", "password123")
    assert user.email == "alice@test.com"       # 行为 1
    assert user.is_active == False               # 行为 2
    assert email_sent_to("alice@test.com")       # 行为 3
    assert audit_log_contains("registration")    # 行为 4
    assert user.created_at is not None           # 行为 5

# 正确：聚焦的测试
def test_registration_creates_user_with_email(): ...
def test_registration_creates_inactive_user(): ...
def test_registration_sends_confirmation_email(): ...
def test_registration_creates_audit_log_entry(): ...
def test_registration_sets_creation_timestamp(): ...
```

---

## 9. 缺失边界情况

**问题：** 测试仅覆盖正常路径，未测试边界条件、错误状态和异常输入。

**常见遗漏的边界情况：**

| 类别 | 示例 |
|----------|----------|
| 边界值 | 0、-1、MAX_INT、空字符串、单个字符 |
| 空集合 | 空列表、空映射、null/None |
| 空值/未定义 | 空输入、缺失的可选字段 |
| 并发 | 同时访问、竞态条件 |
| 错误状态 | 网络故障、磁盘已满、权限被拒绝 |
| Unicode | 表情符号、从右到左文本、特殊字符、多字节字符 |
| 时区 | 夏令时转换、UTC 与本地时间、日期边界 |
| 大型输入 | 超长字符串、超大数字、大量项目 |
| 重复数据 | 相同项目两次、重复键 |
| 顺序 | 已排序、逆序、单个元素 |

**修复方法：** 对于每个函数，系统性地考虑：
1. 空/空值输入时会发生什么？
2. 边界值时会发生什么？
3. 外部调用失败时会发生什么？
4. 输入格式错误时会发生什么？
5. 并发访问时会发生什么？

---

## 10. 不稳定测试（时间依赖、竞态条件）

**问题：** 测试有时通过有时失败，且没有任何代码更改。这些测试会摧毁对测试套件的信任。

**常见原因：**

### 时间依赖测试
```
# 错误：依赖系统时钟
def test_token_not_expired():
    token = create_token(expires_in=1)
    assert token.is_valid()  # 如果机器运行缓慢可能失败

# 正确：控制时间
def test_token_not_expired():
    clock = FakeClock(now=datetime(2025, 1, 1))
    token = create_token(expires_in=3600, clock=clock)
    clock.advance(seconds=3599)
    assert token.is_valid()
```

### 竞态条件
```
# 错误：依赖时机
def test_async_operation():
    start_background_job()
    time.sleep(2)  # 希望此时已完成
    assert job_completed()

# 正确：等待完成信号
def test_async_operation():
    job = start_background_job()
    job.wait(timeout=10)
    assert job.completed
```

### 未设置种子的随机数据
```
# 错误：非确定性
def test_random_selection():
    result = pick_random(items)
    assert result in items  # 总是通过，未测试任何内容

# 正确：为随机性设置种子
def test_random_selection_with_seed():
    result = pick_random(items, seed=42)
    assert result == items[3]  # 确定性，可验证
```

**不稳定测试修复清单：**
1. 使用假时钟控制时间
2. 使用种子控制随机性
3. 使用确定性等待（信号，而非 sleep）
4. 隔离文件系统和网络访问
5. 避免共享可变状态
6. 循环运行测试 100 次以确认其稳定性

---

## 总结：快速参考

| 反模式 | 一行修复建议 |
|-------------|-------------|
| 测试实现细节 | 断言结果，而非内部实现 |
| 过度使用模拟 | 减少耦合，使用假对象 |
| 脆弱的选择器 | 使用 data-testid 或可访问选择器 |
| 测试间依赖 | 每个测试拥有自己的状态 |
| 缓慢的套件 | 模拟 I/O、最小化数据、避免 sleep |
| 过度使用快照 | 编写特定断言 |
| 测试第三方代码 | 测试你的代码，而非他们的 |
| 上帝测试 | 每个测试一个行为 |
| 缺失边界情况 | 系统性地检查边界 |
| 不稳定测试 | 控制时间、随机性、并发 |