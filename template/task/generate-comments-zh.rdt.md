# Explain Code

解释选中的代码.

## Template

### Configuration

```json conversation-template
{
  "id": "generate-comments",
  "engineVersion": 0,
  "label": "生成注释",
  "description": "为选中的代码生成",
  "tags": ["debug", "understand"],
  "header": {
    "title": "生成注释 ({{location}})",
    "icon": {
      "type": "codicon",
      "value": "book"
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
    "placeholder": "正在生成注释",
    "maxTokens": 512
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
为下面的代码生成注释，只需要解释关键代码行的作用。

## 选中的代码
\`\`\`
{{selectedText}}
\`\`\`

## 任务
为选中的代码生成注释，在关键代码行上方使用单行注释的方式解释代码的作用，注释应当尽量简洁清晰。

## 响应

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
\`\`\`
{{selectedText}}
\`\`\`
{{/if}}

## 代码总结
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
