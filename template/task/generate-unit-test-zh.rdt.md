# Generate Unit Test

为选中的代码生成单元测试

## Template

### Configuration

```json conversation-template
{
  "id": "generate-unit-test",
  "engineVersion": 0,
  "label": "生成单元测试",
  "tags": ["generate", "test"],
  "description": "为选中的代码生成单元测试",
  "header": {
    "title": "生成单元测试 ({{location}})",
    "icon": {
      "type": "codicon",
      "value": "beaker"
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
      "name": "lastMessage",
      "time": "message",
      "type": "message",
      "property": "content",
      "index": -1
    }
  ],
  "initialMessage": {
    "placeholder": "生在生成测试用例",
    "maxTokens": 1024
  },
  "response": {
    "placeholder": "Updating Test",
    "maxTokens": 1024,
    "stop": ["机器人:", "开发者:"]
  }
}
```

### Initial Message Prompt

```template-initial-message
## 指示
为下面的代码生成单元测试

## 选中的代码
\`\`\`
{{selectedText}}
\`\`\`

## 任务
编写一个单元测试，包含针对正常路径和所有边缘情况的测试用例。
编程语言是{{language}}。

## 响应

```

### Response Prompt

```template-response
## 指示
将下面的代码重写为: "{{lastMessage}}"

## 代码
\`\`\`
{{temporaryEditorContent}}
\`\`\`

## Task
写一个能继续对话的回应。
专注于当前开发者的请求。
如果信息不明确或需要更多输入，要求澄清。
省略任何链接。
在适当的地方，包括代码片段（使用Markdown）和示例。

## 响应
机器人:
```
