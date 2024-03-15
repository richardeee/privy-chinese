# Document Code

为选中的代码生成文档

## Template

### Configuration

````json conversation-template
{
  "id": "document-code",
  "engineVersion": 0,
  "label": "生成文档",
  "tags": ["generate", "document"],
  "description": "为选中代码生成文档",
  "header": {
    "title": "生成文档 {{location}}",
    "icon": {
      "type": "codicon",
      "value": "output"
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
    }
  ],
  "chatInterface": "instruction-refinement",
  "initialMessage": {
    "placeholder": "Documenting selection",
    "maxTokens": 2048,
    "stop": ["```"],
    "completionHandler": {
      "type": "active-editor-diff",
      "botMessage": "Generated documentation."
    }
  },
  "response": {
    "placeholder": "Documenting selection",
    "maxTokens": 2048,
    "stop": ["```"],
    "completionHandler": {
      "type": "active-editor-diff",
      "botMessage": "已生成的文档."
    }
  }
}
````

### Initial Message Prompt

```template-initial-message
## 指导
在函数/方法/类级别为代码生成文档。
忽略注释。
编程语言是{{language}}。

## 代码
\`\`\`
{{selectedText}}
\`\`\`

## 代码文档
\`\`\`

```

### Response Prompt

```template-response
## 指导
在函数/方法/类级别为代码生成文档。
忽略注释。
编程语言是{{language}}。

遵守以下指导:
{{#each messages}}
{{#if (eq author "user")}}
{{content}}
{{/if}}
{{/each}}

## 代码
\`\`\`
{{selectedText}}
\`\`\`

## 代码文档
\`\`\`

```
