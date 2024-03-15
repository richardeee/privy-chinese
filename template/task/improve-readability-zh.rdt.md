# Improve Readability

将选中的代码改写为更加易于阅读的形式

## Template

### Configuration

```json conversation-template
{
  "id": "improve-readability",
  "engineVersion": 0,
  "label": "提高可读性",
  "description": "将选中的代码改写为更加易于阅读的形式",
  "tags": ["code quality"],
  "header": {
    "title": "Improve readability ({{location}})",
    "icon": {
      "type": "codicon",
      "value": "symbol-color"
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
  "chatInterface": "instruction-refinement",
  "initialMessage": {
    "placeholder": "正在提高可读性",
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
以下代码如何提高可读性？
编程语言是{{language}}。
考虑总体可读性和惯用的结构。

## 选中的代码
\`\`\`
{{selectedText}}
\`\`\`

## 任务
如何提高选中代码的可读性？
编程语言是{{language}}。
考虑整体可读性和惯用结构。
在可能的情况下提供潜在的改进建议。
考虑到代码可能是完美的，并且不可能进行任何改进。
在适当的情况下包括代码片段（使用 Markdown）和示例。
代码段必须包含有效的 {{language}} 代码。

## 可读性改进

```

### Response Prompt

```template-response
## 指示
继续下面的对话。
请特别注意当前的开发人员请求。
编程语言是{{language}}。

## 当前请求
开发者: {{lastMessage}}

{{#if selectedText}}
## 选中的代码
\`\`\`
{{selectedText}}
\`\`\`
{{/if}}

## 对话
{{#each messages}}
{{#if (eq author "bot")}}
机器人: {{content}}
{{else}}
开发者: {{content}}
{{/if}}
{{/each}}

## 任务
写一个继续对话的回复。
专注于当前的开发人员请求。
考虑可能没有解决方案的可能性。
如果消息没有意义或需要更多输入，请要求澄清。
省略任何链接。
在适当的情况下包括代码片段（使用 Markdown）和示例。
代码段必须包含有效的 {{language}} 代码。

## 响应
机器人:
```
