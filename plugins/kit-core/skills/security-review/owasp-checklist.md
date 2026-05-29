# OWASP Top 10 (2021) -- 详细检查清单

包含漏洞模式、测试方法和安全代码示例的参考文档。

## 1. 访问控制失效 (A01)

### 如何测试
- 通过更改 URL/参数中的 ID 来访问其他用户的资源
- 尝试以普通用户身份访问管理员端点
- 测试 CORS 配置是否存在过于宽松的源设置
- 验证 API 端点是否强制执行授权，而不仅仅是身份验证
- 通过枚举 ID 测试 IDOR（不安全直接对象引用）

### 漏洞模式
```javascript
// 无授权检查 -- 任何已认证用户均可访问任意订单
app.get('/api/orders/:id', authenticate, async (req, res) => {
  const order = await Order.findById(req.params.id);
  res.json(order);
});
```

### 安全模式
```javascript
// 验证订单属于请求用户
app.get('/api/orders/:id', authenticate, async (req, res) => {
  const order = await Order.findOne({
    _id: req.params.id,
    userId: req.user.id  // 限定为已认证用户
  });
  if (!order) return res.status(404).json({ error: 'Not found' });
  res.json(order);
});
```

### 工具
- Burp Suite（手动测试）
- OWASP ZAP（自动化扫描）
- 自定义脚本测试授权边界

---

## 2. 加密机制失效 (A02)

### 如何测试
- 检查是否存在通过 HTTP（而非 HTTPS）传输的数据
- 查找弱哈希算法（用于密码的 MD5、SHA1）
- 检查是否存在硬编码的加密密钥
- 验证敏感数据在静态存储时是否已加密
- 检查 TLS 配置（最低要求 TLS 1.2）

### 漏洞模式
```python
# MD5 不适用于密码哈希
import hashlib
password_hash = hashlib.md5(password.encode()).hexdigest()
```

### 安全模式
```python
# 使用 bcrypt 并设置成本因子
import bcrypt
password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))

# 验证
bcrypt.checkpw(submitted_password.encode(), stored_hash)
```

### 工具
- testssl.sh（TLS 配置检查）
- SSLyze（SSL/TLS 分析）
- grep 搜索弱算法（MD5、SHA1、DES、RC4）

---

## 3. 注入 (A03)

### 如何测试
- 在输入中提交 SQL 元字符（`' OR 1=1 --`）
- 测试 NoSQL 注入（`{"$gt": ""}`）
- 测试命令注入（`;ls`、`$(whoami)`）
- 测试 LDAP 注入、XPath 注入
- 测试模板注入（`{{7*7}}`）

### 漏洞模式
```javascript
// 通过字符串拼接导致 SQL 注入
const query = `SELECT * FROM users WHERE name = '${req.query.name}'`;
db.query(query);

// 命令注入
const { exec } = require('child_process');
exec(`ping ${req.query.host}`);
```

### 安全模式
```javascript
// 参数化查询
const query = 'SELECT * FROM users WHERE name = $1';
db.query(query, [req.query.name]);

// 使用参数数组安全执行命令（无 shell）
const { execFile } = require('child_process');
execFile('ping', ['-c', '4', validatedHost]);
```

### 工具
- SQLMap（SQL 注入）
- Commix（命令注入）
- OWASP ZAP（通用注入扫描）
- ESLint 安全插件（静态分析）

---

## 4. 不安全设计 (A04)

### 如何测试
- 检查敏感端点（登录、注册、密码重置）是否缺少速率限制
- 检查失败尝试后是否缺少账户锁定机制
- 查找业务逻辑缺陷（负数量、价格篡改）
- 验证是否已记录并缓解滥用场景

### 漏洞模式
```javascript
// 登录端点无速率限制
app.post('/login', async (req, res) => {
  const user = await User.findByEmail(req.body.email);
  if (user && await bcrypt.compare(req.body.password, user.hash)) {
    return res.json({ token: createToken(user) });
  }
  res.status(401).json({ error: 'Invalid credentials' });
});
```

### 安全模式
```javascript
// 带账户锁定的速率限制登录
const loginLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 5 });

app.post('/login', loginLimiter, async (req, res) => {
  const user = await User.findByEmail(req.body.email);
  if (!user || user.lockedUntil > Date.now()) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  if (await bcrypt.compare(req.body.password, user.hash)) {
    await user.resetFailedAttempts();
    return res.json({ token: createToken(user) });
  }
  await user.incrementFailedAttempts(); // 5 次失败后锁定
  res.status(401).json({ error: 'Invalid credentials' });
});
```

### 工具
- 威胁建模（STRIDE）
- 架构审查
- 滥用场景分析

---

## 5. 安全配置错误 (A05)

### 如何测试
- 检查管理面板、数据库、云服务是否存在默认凭据
- 验证错误页面是否未暴露堆栈跟踪或内部细节
- 检查是否启用了不必要的 HTTP 方法（TRACE、PUT、DELETE）
- 验证是否已禁用目录列表
- 检查云存储权限（S3 存储桶、GCS）

### 漏洞模式
```javascript
// 向用户暴露堆栈跟踪
app.use((err, req, res, next) => {
  res.status(500).json({
    error: err.message,
    stack: err.stack  // 泄露内部细节
  });
});
```

### 安全模式
```javascript
// 生产环境使用通用错误，开发环境显示详细信息
app.use((err, req, res, next) => {
  console.error(err); // 服务器端记录完整错误
  res.status(500).json({
    error: process.env.NODE_ENV === 'production'
      ? 'Internal server error'
      : err.message
  });
});
```

### 工具
- ScoutSuite（云配置检查）
- Prowler（AWS 安全审计）
- nikto（Web 服务器配置检查）
- 安全标头检查（securityheaders.com）

---

## 6. 使用含有已知漏洞的组件 (A06)

### 如何测试
- 运行 `npm audit` / `pip-audit` / `cargo audit` / `govulncheck`
- 检查是否存在已知 CVE 的组件
- 验证是否已提交锁文件（lock files）
- 审查是否存在已废弃/无人维护的依赖项

### 漏洞模式
```json
// package.json 使用宽松版本控制且包含已知漏洞包
{
  "dependencies": {
    "lodash": "*",
    "minimist": "^0.0.8"
  }
}
```

### 安全模式
```json
// 固定版本，使用维护中的包
{
  "dependencies": {
    "lodash": "4.17.21",
    "minimist": "1.2.8"
  }
}
```

### 工具
- npm audit / yarn audit / pnpm audit
- Snyk（多语言支持）
- Socket.dev（供应链安全）
- Dependabot / Renovate（自动化更新）
- OWASP Dependency-Check

---

## 7. 身份识别和身份验证失效 (A07)

### 如何测试
- 测试弱密码策略（最小长度、复杂度要求）
- 检查是否存在凭证填充防护
- 验证登出时会话令牌是否失效
- 测试会话固定攻击
- 检查密码重置流程是否存在信息泄露

### 漏洞模式
```python
# 弱密码要求，无暴力破解防护
def register(username, password):
    if len(password) < 4:  # 太短
        raise ValueError("Password too short")
    user = User(username=username, password=md5(password))  # 弱哈希
    user.save()
```

### 安全模式
```python
# 强密码要求，正确哈希
import bcrypt
from zxcvbn import zxcvbn

def register(username, password):
    result = zxcvbn(password)
    if result['score'] < 3:
        raise ValueError("Password is too weak: " + result['feedback']['warning'])
    hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))
    user = User(username=username, password_hash=hashed)
    user.save()
```

### 工具
- Hydra（暴力破解测试）
- Burp Suite（会话分析）
- zxcvbn（密码强度评估）

---

## 8. 软件和数据完整性故障 (A08)

### 如何测试
- 验证 CI/CD 流水线是否受保护（签名提交、受保护分支）
- 检查是否存在未签名或未验证的软件更新
- 审查不可信数据的反序列化操作
- 验证 CDN 加载资源的完整性（SRI 哈希）

### 漏洞模式
```html
<!-- 从 CDN 加载脚本但未进行完整性检查 -->
<script src="https://cdn.example.com/lib.js"></script>
```

### 安全模式
```html
<!-- 子资源完整性（SRI）哈希验证 -->
<script src="https://cdn.example.com/lib.js"
  integrity="sha384-abc123..."
  crossorigin="anonymous"></script>
```

### 工具
- npm audit signatures
- Sigstore / cosign（容器签名）
- git 提交签名（GPG/SSH）

---

## 9. 安全日志和监控失效 (A09)

### 如何测试
- 验证登录尝试（成功和失败）是否被记录
- 检查访问控制失败是否被记录
- 验证输入验证失败是否被记录
- 确认日志中不包含敏感数据（密码、令牌、个人身份信息）
- 检查是否对可疑模式设置告警

### 漏洞模式
```javascript
// 无安全事件日志记录
app.post('/login', async (req, res) => {
  const user = await authenticate(req.body);
  if (!user) return res.status(401).send();
  res.json({ token: createToken(user) });
});
```

### 安全模式
```javascript
// 记录安全相关事件
app.post('/login', async (req, res) => {
  const user = await authenticate(req.body);
  if (!user) {
    logger.warn('login_failed', {
      email: req.body.email,  // 记录标识符，而非密码
      ip: req.ip,
      userAgent: req.headers['user-agent']
    });
    return res.status(401).send();
  }
  logger.info('login_success', { userId: user.id, ip: req.ip });
  res.json({ token: createToken(user) });
});
```

### 工具
- ELK Stack / Grafana Loki（日志聚合）
- SIEM 解决方案（告警）
- 自定义审计日志审查

---

## 10. 服务器端请求伪造 -- SSRF (A10)

### 如何测试
- 提交内部 URL（http://127.0.0.1、http://169.254.169.254）
- 使用 DNS 重绑定测试
- 测试 URL 方案（file://、gopher://）
- 检查是否存在可链接到 SSRF 的开放重定向

### 漏洞模式
```python
# 服务器端获取用户控制的 URL 且未进行验证
import requests

@app.route('/proxy')
def proxy():
    url = request.args.get('url')
    response = requests.get(url)  # 可获取任意 URL，包括内部地址
    return response.text
```

### 安全模式
```python
# 针对允许列表验证 URL，阻止内部地址
from urllib.parse import urlparse
import ipaddress

ALLOWED_HOSTS = {'api.example.com', 'cdn.example.com'}

@app.route('/proxy')
def proxy():
    url = request.args.get('url')
    parsed = urlparse(url)

    if parsed.hostname not in ALLOWED_HOSTS:
        abort(400, 'Host not allowed')

    if parsed.scheme not in ('http', 'https'):
        abort(400, 'Scheme not allowed')

    # 解析并检查是否为内部 IP
    ip = socket.gethostbyname(parsed.hostname)
    if ipaddress.ip_address(ip).is_private:
        abort(400, 'Internal addresses not allowed')

    response = requests.get(url, timeout=5)
    return response.text
```

### 工具
- SSRFmap
- Burp Suite Collaborator
- 针对云元数据端点的自定义载荷