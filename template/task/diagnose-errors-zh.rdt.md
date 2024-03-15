# Explain Code

Diagnoses any errors or warnings the selected code.

## Template

### Configuration

```json conversation-template
{
  "id": "diagnose-errors",
  "engineVersion": 0,
  "label": "诊断错误",
  "tags": ["debug"],
  "description": "诊断代码段中的警告和错误",
  "header": {
    "title": "诊断错误 ({{location}})",
    "icon": {
      "type": "codicon",
      "value": "search-fuzzy"
    }
  },
  "variables": [
    {
      "name": "selectedTextWithDiagnostics",
      "time": "conversation-start",
      "type": "selected-text-with-diagnostics",
      "severities": ["error", "warning"],
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
    "placeholder": "正在诊断错误",
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
## 指导
阅读下面代码中的错误和警告

## 选中的代码
\`\`\`
{{selectedTextWithDiagnostics}}
\`\`\`

## 任务
For each error or warning, write a paragraph that describes the most likely cause and a potential fix.
Include code snippets where appropriate.

针对每个错误或者告警，写一段描述该错误或告警最有可能的原因以及可能的修复方法。
如果有需要可以包含代码。

## 回答

```

### Response Prompt

```template-response
## 指导
继续下面的对话。
特别留意开发者当前的要求。

## 当前要求
开发者: {{lastMessage}}

{{#if selectedText}}
## 选中的代码
\`\`\`
{{selectedTextWithDiagnostics}}
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
继续进行对话。
专注于当前开发者的请求。
考虑可能不存在解决方案的可能性。
如果消息没有意义或需要更多的输入，要求澄清。
省略任何链接。
在适当的地方包括代码片段（使用Markdown）和示例。

## 响应
机器人:
```
