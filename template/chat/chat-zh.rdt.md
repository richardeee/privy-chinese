# AI Chat in Chinese

This template lets you chat with Privy in Chinese.

## Template

### Configuration

```json conversation-template
{
  "id": "chat-zh",
  "engineVersion": 0,
  "label": "开始对话",
  "description": "开始一次对话.",
  "header": {
    "title": "开始对话",
    "useFirstMessageAsTitle": true,
    "icon": {
      "type": "codicon",
      "value": "comment-discussion"
    }
  },
  "variables": [
    {
      "name": "selectedText",
      "time": "conversation-start",
      "type": "selected-text"
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
    "maxTokens": 1024,
    "stop": ["机器人:", "开发者:"]
  }
}
```

### Response Prompt

```template-response
## 指示
继续下面的对话.
特别留意当前开发者的请求.

## 当前请求
开发者: {{lastMessage}}

{{#if selectedText}}
## 已选择的代码
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


## 响应
机器人:
```
