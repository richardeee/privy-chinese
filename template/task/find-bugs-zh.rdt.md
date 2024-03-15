# Find Bugs

寻找选中代码中存在的 Bug.

## Template

### Configuration

```json conversation-template
{
  "id": "find-bugs",
  "engineVersion": 0,
  "label": " 寻找 Bug",
  "tags": ["debug", "code quality"],
  "description": " 寻找选中代码中的 Bug.",
  "header": {
    "title": " 寻找 Bug ({{location}})",
    "icon": {
      "type": "codicon",
      "value": "bug"
    }
  },
  "variables": [
    {
      "name": "selectedText",
      "time": "conversation-start",
      "type": "selected-text",
      "constraints": [{ "type": "text-length", "min": 1 }]
    },
    {
      "name": "language",
      "time": "conversation-start",
      "type": "language",
      "constraints": [{ "type": "text-length", "min": 1 }]
    },
    {
      "name": "location",
      "time": "conversation-start",
      "type": "selected-location-text"
    },
    {
      "name": "firstMessage",
      "time": "message",
      "type": "message",
      "property": "content",
      "index": 0
    },
    {
      "name": "lastMessage",
      "time": "message",
      "type": "message",
      "property": "content",
      "index": -1
    }
  ],
  "initialMessage": {
    "placeholder": " 正在寻找 Bug",
    "maxTokens": 1024
  },
  "response": {
    "maxTokens": 1024,
    "stop": ["机器人:", "开发者:"]
  }
}
```

### Initial Message Prompt

```template-initial-message
## 指示
下面的代码可能有什么问题？
只考虑会导致错误行为的Bug。
编程语言是{{language}}。
## 选中的代码
\`\`\`
{{selectedText}}
\`\`\`

## 任务
描述代码可能存在的问题？
只考虑可能导致行为不正确的缺陷。
在可能的情况下提供可能的修复建议。
考虑到代码可能没有任何问题。”
在适当的地方包括代码片段（使用Markdown）和示例。

## 分析

```

### Response Prompt

```template-response
## 指示
继续以下的对话。
特别注意当前开发者的请求。
编程语言是{{language}}。

## 当前请求
开发者: {{lastMessage}}

{{#if selectedText}}
## 选中的代码
\`\`\`
{{selectedText}}
\`\`\`
{{/if}}

## 潜在的 Bug
{{firstMessage}}

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
撰写一个延续对话的回复。
保持专注于当前开发者的请求。
考虑到可能不存在解决方案的情况。
如果信息含糊不清或需要更多的输入，请寻求进一步的澄清。
运用文档文章的写作风格。
避免包含任何链接。
适当的地方需要包含代码片段（使用Markdown）和例子。

## 响应
机器人:
```
