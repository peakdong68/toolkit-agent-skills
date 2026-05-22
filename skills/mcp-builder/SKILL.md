---
name: mcp-builder
description: >
  当用户需要构建 MCP（Model Context Protocol，模型上下文协议）服务器时使用——包括工具定义、资源
  管理、提示模板、传输层和客户端集成。触发条件：用户提到 "MCP"、
  "MCP server"、"model context protocol"、为 AI 客户端构建工具、创建 AI 集成。
---

# MCP Builder（MCP 构建器）

## 概述

构建生产质量的 MCP（模型上下文协议）服务器，向 AI 客户端暴露工具、资源和提示。本技能涵盖完整开发生命周期：工具定义、资源管理、提示模板、传输配置（stdio、SSE）、错误处理、安全加固、测试和客户端集成。

## 阶段 1：设计

1. 识别要暴露的能力（工具、资源、提示）
2. 使用 Zod/JSON Schema 定义工具模式
3. 规划资源 URI 模式
4. 设计错误处理策略
5. 选择传输层（CLI 使用 stdio，Web 使用 SSE）

**停止 — 向用户展示能力清单和传输选择以获取批准。**

### 能力选择决策表

| 你拥有什么 | MCP 原语 | 示例 |
|---|---|---|
| 修改状态的操作 | 工具（Tool） | `create-issue`、`send-email`、`deploy-app` |
| 读取/查询的操作 | 工具（Tool） | `search-documents`、`get-status` |
| AI 应读取的数据 | 资源（Resource） | `config://settings`、`docs://api/endpoints` |
| 可复用的提示模式 | 提示（Prompt） | `code-review`、`summarize-document` |
| 实时数据流 | 资源（可订阅） | `metrics://cpu/current` |

### 传输选择决策表

| 上下文 | 传输方式 | 原因 |
|---|---|---|
| CLI 工具，本地客户端（Claude Desktop） | Stdio | 简单，无网络开销 |
| Web 应用，远程客户端 | SSE | 可通过网络访问，支持实时通信 |
| 同时支持本地和远程 | Stdio + SSE | 支持两种使用场景 |
| 高吞吐、双向通信 | WebSocket（自定义） | 比 SSE 延迟更低 |

## 阶段 2：实现

1. 设置 MCP 服务器项目结构
2. 实现带输入验证的工具处理程序
3. 实现资源提供者
4. 添加提示模板
5. 配置传输和认证

**停止 — 在进入加固阶段前运行基本冒烟测试。**

### 项目结构

```
src/
  index.ts          # 服务器入口点
  tools/
    search.ts       # 工具实现
    create.ts
  resources/
    documents.ts    # 资源提供者
    config.ts
  prompts/
    review.ts       # 提示模板
  lib/
    database.ts     # 共享工具函数
    validation.ts
tests/
  tools.test.ts
  resources.test.ts
package.json
tsconfig.json
```

### 工具定义模式

```typescript
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { z } from 'zod';

const server = new McpServer({
  name: 'my-mcp-server',
  version: '1.0.0',
});

server.tool(
  'search-documents',
  'Search documents by query. Returns matching documents with relevance scores.',
  {
    query: z.string().describe('Search query string'),
    limit: z.number().min(1).max(100).default(10).describe('Maximum results to return'),
    filter: z.object({
      type: z.enum(['article', 'page', 'note']).optional(),
      dateAfter: z.string().datetime().optional(),
    }).optional().describe('Optional filters'),
  },
  async ({ query, limit, filter }) => {
    const results = await searchEngine.search(query, { limit, ...filter });
    return {
      content: [{
        type: 'text',
        text: JSON.stringify(results, null, 2),
      }],
    };
  }
);
```

### 工具设计原则

| 原则 | 规则 |
|---|---|
| 命名清晰 | 使用动词 - 名词格式：`search-documents`、`create-issue` |
| 描述性说明 | 解释功能、使用时机和返回值 |
| 输入验证 | 每个字段都使用带 `.describe()` 的 Zod 模式 |
| 结构化输出 | 格式良好的文本或 JSON |
| 尽可能幂等 | 相同输入产生相同结果 |
| 可操作的错误 | 具体的错误消息，附带 `isError: true` |

### 工具响应模式

```typescript
// 文本响应
return { content: [{ type: 'text', text: 'Operation completed successfully' }] };

// 结构化数据响应
return { content: [{ type: 'text', text: JSON.stringify(data, null, 2) }] };

// 多部分响应
return {
  content: [
    { type: 'text', text: `Found ${results.length} results:` },
    { type: 'text', text: results.map(r => `- ${r.title}: ${r.summary}`).join('\n') },
  ],
};

// 图像响应
return { content: [{ type: 'image', data: base64Data, mimeType: 'image/png' }] };

// 错误响应
return {
  content: [{ type: 'text', text: `Error: ${error.message}` }],
  isError: true,
};
```

## 资源管理

### 资源定义

```typescript
// 静态资源
server.resource(
  'config',
  'config://app/settings',
  { mimeType: 'application/json' },
  async () => ({
    contents: [{
      uri: 'config://app/settings',
      mimeType: 'application/json',
      text: JSON.stringify(appConfig),
    }],
  })
);

// 带 URI 模板的动态资源
server.resource(
  'document',
  new ResourceTemplate('docs://{category}/{id}', { list: undefined }),
  { mimeType: 'text/markdown' },
  async (uri, { category, id }) => ({
    contents: [{
      uri: uri.href,
      mimeType: 'text/markdown',
      text: await getDocument(category, id),
    }],
  })
);
```

### 资源 URI 约定

```
file:///path/to/file          — 本地文件
https://api.example.com/data  — 远程 HTTP 资源
db://database/table/id        — 数据库记录
config://app/settings         — 配置
docs://category/slug          — 文档
```

## 提示模板

```typescript
server.prompt(
  'code-review',
  'Generate a code review for the given file',
  {
    filePath: z.string().describe('Path to the file to review'),
    severity: z.enum(['strict', 'normal', 'lenient']).default('normal'),
  },
  async ({ filePath, severity }) => {
    const code = await readFile(filePath, 'utf-8');
    return {
      messages: [{
        role: 'user',
        content: {
          type: 'text',
          text: `Review this code with ${severity} standards:\n\n\`\`\`\n${code}\n\`\`\``,
        },
      }],
    };
  }
);
```

## 传输层

### Stdio 传输（CLI 工具，本地开发）

```typescript
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const transport = new StdioServerTransport();
await server.connect(transport);
```

### SSE 传输（Web 应用，远程服务器）

```typescript
import express from 'express';
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js';

const app = express();

app.get('/sse', async (req, res) => {
  const transport = new SSEServerTransport('/messages', res);
  await server.connect(transport);
});

app.post('/messages', async (req, res) => {
  // Handle incoming messages
});

app.listen(3001);
```

## 阶段 3：加固

1. 添加全面的错误处理
2. 实现速率限制和超时
3. 安全审查（输入清理、权限检查）
4. 编写集成测试
5. 为客户端文档化工具和资源

**停止 — 部署前所有测试必须通过，且安全审查必须完成。**

### 错误处理

```typescript
server.tool('risky-operation', 'Performs an operation that might fail', {
  input: z.string(),
}, async ({ input }) => {
  try {
    const result = await performOperation(input);
    return { content: [{ type: 'text', text: JSON.stringify(result) }] };
  } catch (error) {
    if (error instanceof ValidationError) {
      return {
        content: [{ type: 'text', text: `Invalid input: ${error.message}` }],
        isError: true,
      };
    }
    if (error instanceof NotFoundError) {
      return {
        content: [{ type: 'text', text: `Resource not found: ${error.message}` }],
        isError: true,
      };
    }
    console.error('Unexpected error:', error);
    return {
      content: [{ type: 'text', text: 'An unexpected error occurred. Please try again.' }],
      isError: true,
    };
  }
});
```

### 错误处理规则

| 规则 | 原因 |
|---|---|
| 绝不向客户端暴露堆栈跟踪 | 安全风险 |
| 所有错误都返回 `isError: true` | 客户端可区分成功/失败 |
| 服务器端记录意外错误 | 便于调试和监控 |
| 提供可操作的错误消息 | 客户端可自行纠正 |
| 对外部调用设置超时 | 防止请求无限挂起 |
| 处理前验证所有输入 | 尽早拒绝无效数据 |

### 安全考虑

| 类别 | 规则 |
|---|---|
| 输入验证 | Zod 模式、路径遍历防护、长度限制 |
| 权限模型 | 最小权限原则、白名单目录、读写工具分离 |
| 密钥管理 | 仅使用环境变量、绝不包含在响应中、日志中脱敏、定期轮换 |
| 速率限制 | 限制每个客户端的工具调用频率 |
| 审计日志 | 记录所有工具调用及时间戳 |

## 测试 MCP 服务器

```typescript
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { InMemoryTransport } from '@modelcontextprotocol/sdk/inMemory.js';
import { Client } from '@modelcontextprotocol/sdk/client/index.js';

describe('MCP Server', () => {
  let server: McpServer;
  let client: Client;

  beforeEach(async () => {
    server = createServer();
    client = new Client({ name: 'test-client', version: '1.0.0' });
    const [clientTransport, serverTransport] = InMemoryTransport.createLinkedPair();
    await Promise.all([
      server.connect(serverTransport),
      client.connect(clientTransport),
    ]);
  });

  test('search-documents returns results', async () => {
    const result = await client.callTool({
      name: 'search-documents',
      arguments: { query: 'test', limit: 5 },
    });
    expect(result.content[0].type).toBe('text');
    const data = JSON.parse(result.content[0].text);
    expect(data.length).toBeLessThanOrEqual(5);
  });

  test('handles invalid input gracefully', async () => {
    const result = await client.callTool({
      name: 'search-documents',
      arguments: { query: '', limit: -1 },
    });
    expect(result.isError).toBe(true);
  });
});
```

## 客户端集成

### Claude Desktop 配置

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["/path/to/server/dist/index.js"],
      "env": {
        "API_KEY": "your-key-here"
      }
    }
  }
}
```

## 反模式 / 常见错误

| 反模式 | 错误原因 | 正确做法 |
|---|---|---|
| 工具功能过于庞杂 | 难以使用，难以测试 | 拆分为专注的单一功能工具 |
| 缺少输入验证 | 崩溃、安全漏洞 | 始终使用 Zod 模式 |
| 返回原始堆栈跟踪 | 安全风险，使 AI 困惑 | 返回 `isError: true` 并附带简洁消息 |
| 外部调用无超时设置 | 请求可能无限挂起 | 所有 I/O 操作都设置超时 |
| 源码中硬编码密钥 | 凭证泄露风险 | 使用环境变量 |
| 工具缺少描述 | 客户端无法发现用途 | 编写清晰的描述 |
| 同步操作阻塞事件循环 | 服务器无响应 | 所有 I/O 使用 async/await |
| 无测试 | 回归问题无法被发现 | 使用 InMemoryTransport 进行测试 |

## 文档查询（Context7）

使用 `mcp__context7__resolve-library-id` 然后 `mcp__context7__query-docs` 获取最新文档。返回的文档将覆盖记忆中的知识。
- `@anthropic-ai/sdk` — 用于 Claude API 客户端、工具定义或流式传输

---

## 反自我合理化防护

- 切勿跳过工具的输入验证——MCP 客户端可能发送意外数据。
- 切勿省略工具描述——描述是 AI 客户端理解工具用途的唯一途径。
- 切勿在工具实现中硬编码密钥——使用环境变量。
- 切勿在未设置超时的情况下进行网络调用——始终设定合理的超时时间。
- 切勿向客户端泄露堆栈跟踪——捕获并返回友好的错误信息。

## 集成点

| 技能 | 集成方式 |
|---|---|
| `senior-devops` | 容器化并部署 MCP 服务器 |
| `agent-development` | MCP 服务器为智能体提供工具 |
| `security-review` | 工具输入/输出的安全加固 |
| `test-driven-development` | 工具实现的测试驱动开发 |
| `deployment` | MCP 服务器发布的 CI/CD 流水线 |
| `planning` | MCP 服务器设计是实施计划的一部分 |

## 技能类型

**灵活（FLEXIBLE）** — 根据用例调整项目结构、传输选择和工具链。强烈推荐使用 Zod 进行工具验证，并使用 `isError` 进行错误处理。生产部署前建议进行安全审查。