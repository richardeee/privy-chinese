# Edit Code

根据指示生成代码.

## Template

### Configuration

````json conversation-template
{
  "id": "edit-code",
  "engineVersion": 0,
  "label": "Edit Code",
  "tags": ["edit"],
  "description": "指示 Privy 编辑代码，并创建一个diff供你审阅",
  "header": {
    "title": "编辑代码 {{location}}",
    "icon": {
      "type": "codicon",
      "value": "edit"
    }
  },
  "chatInterface": "instruction-refinement",
  "variables": [
    {
      "name": "selectedText",
      "time": "conversation-start",
      "type": "selected-text",
      "constraints": [{ "type": "text-length", "min": 1 }]
    }
  ],
  "response": {
    "placeholder": "生在编辑",
    "maxTokens": 1536,
    "stop": ["```"],
    "completionHandler": {
      "type": "active-editor-diff",
      "botMessage": "Generated edit."
    }
  }
}
````

### Response Prompt

```template-response
## 指示
编辑以下代码:
{{#each messages}}
{{#if (eq author "user")}}
{{content}}
{{/if}}
{{/each}}

## 代码
\`\`\`
{{selectedText}}
\`\`\`

## 回答
\`\`\`

```
