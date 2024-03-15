# Explain Code

解释选中的代码.

## Template

### Configuration

```json conversation-template
{
  "id": "explain-code-with-context",
  "engineVersion": 0,
  "label": "根据上下文解释代码",
  "description": "根据所有打开的文件解释选中的代码",
  "tags": ["debug", "understand"],
  "header": {
    "title": "根据上下文解释代码 ({{location}})",
    "icon": {
      "type": "codicon",
      "value": "book"
    }
  },
  "variables": [
    {
      "name": "openFiles",
      "time": "conversation-start",
      "type": "context"
    },
    {
      "name": "selectedText",
      "time": "conversation-start",
      "type": "selected-text",
      "constraints": [{ "type": "text-length", "min": 1 }]
    },
    {
      "name": "location",
      "time": "conversation-start",
      "type": "selected-location-text"
    },
    {
      "name": "lastMessage",
      "time": "message",
      "type": "message",
      "property": "content",
      "index": -1
    }
  ],
  "response": {
    "maxTokens": 2048,
    "stop": ["机器人:", "开发者:"]
  }
}
```

### Response Prompt

```template-response
## 指示
继续以下的对话。
特别关注当前开发者的请求。

## 当前请求
开发者: {{lastMessage}}

{{#if selectedText}}
## 选中的代码
\`\`\`{{language}}
{{selectedText}}
\`\`\`
{{/if}}

## 代码总结
## 打开的文件
{{#each openFiles}}
### 文件: {{name}}
\`\`\`{{language}}
{{content}}
\`\`\`
{{/each}}

## 对话
{{#each messages}}
{{#if (neq @index 0)}}
{{#if (eq author "bot")}}
机器人: {{content}}
{{else}}
开发者: {{content}}
{{/if}}
{{/if}}
{{/each}}

## 任务
编写一个继续对话的回应。
保持专注于当前开发者的请求。
考虑可能没有解决方案的可能性。
如果信息没有意义或者需要更多的输入，要求进行澄清。
使用文档文章的风格。
省略任何链接。
在适当的地方包含代码片段（使用 Markdown）和示例。

## 响应
机器人:
```
