# Generate Code

根据指示生成代码

## Template

### Configuration

````json conversation-template
{
  "id": "generate-code",
  "engineVersion": 0,
  "label": "生成代码",
  "tags": ["generate"],
  "description": "根据指示生成代码",
  "header": {
    "title": "生成代码",
    "icon": {
      "type": "codicon",
      "value": "wand"
    }
  },
  "chatInterface": "instruction-refinement",
  "variables": [],
  "response": {
    "placeholder": "Generating code",
    "maxTokens": 2048,
    "stop": ["```"],
    "completionHandler": {
      "type": "update-temporary-editor",
      "botMessage": "Generated code."
    }
  }
}
````

### Response Prompt

```template-response
## 指示
按照以下规格要求生成代码

## 规格要求
{{#each messages}}
{{#if (eq author "user")}}
{{content}}
{{/if}}
{{/each}}

## 指示
根据规格要求生成代码

## 代码
\`\`\`

```
