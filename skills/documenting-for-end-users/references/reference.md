# Writing Reference Documentation

Reference documentation provides **information-oriented technical descriptions** of the product's machinery - its APIs,
commands, options, configuration, types, and behavior. Users consult reference material while working; they look things
up rather than read through it.

Reference documentation answers: **"What is...?"**

## Table of Contents

1. [Core Principles](#core-principles)
1. [Structure Templates](#structure-templates)
1. [Anti-Patterns](#anti-patterns)

## Core Principles

### Describe and only describe

The key imperative is neutral description. Accuracy, precision, completeness, and clarity are essential. Don't instruct
(that's a how-to guide). Don't explain why (that's explanation). Don't teach (that's a tutorial). If you're tempted to
add instruction or explanation, link to the appropriate document instead.

### Mirror the product's structure

Organize reference documentation to match the structure of the thing it describes, not the user's journey or workflow.
If the product has three subsystems, the reference has three sections. If a CLI has five command groups, the reference
has five corresponding sections.

This structure helps users find information by knowing where they are in the product.

### Adopt standard patterns

Use consistent formatting throughout. Every command entry should follow the same template. Every API endpoint should
list the same fields in the same order. Consistency lets users build expectations about where to find information.

### Be austere and authoritative

Reference material is dry, factual, and leaves no room for doubt or ambiguity. It is the single source of truth. State
facts plainly. Use neutral language. Avoid hedging, opinion, or conversational tone.

### Provide examples without explanation

Examples show usage in context. They illustrate, they don't explain. Include the input and output; don't narrate what's
happening.

## Structure Templates

### CLI Command Reference

```markdown
# Command Reference

## `command-name`

Brief one-line description of what the command does.

### Synopsis

\`\`\`
tool command-name [options] <required-arg> [optional-arg]
\`\`\`

### Arguments

| Argument | Required | Description |
|---|---|---|
| `required-arg` | Yes | What this argument specifies |
| `optional-arg` | No | What this argument specifies. Default: `value` |

### Options

| Option | Short | Description | Default |
|---|---|---|---|
| `--output` | `-o` | Output format (`json`, `text`, `csv`) | `text` |
| `--verbose` | `-v` | Enable verbose output | `false` |

### Examples

\`\`\`sh
tool command-name myfile.txt
tool command-name --output json myfile.txt
\`\`\`

### Exit Codes

| Code | Meaning |
|---|---|
| `0` | Success |
| `1` | General error |
| `2` | Invalid arguments |
```

### API Endpoint Reference

```markdown
# API Reference

## `POST /resource`

Creates a new resource.

### Request

**Headers:**

| Header | Required | Description |
|---|---|---|
| `Authorization` | Yes | Bearer token |
| `Content-Type` | Yes | Must be `application/json` |

**Body:**

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | `string` | Yes | Resource name (1-255 chars) |
| `tags` | `string[]` | No | Associated tags. Default: `[]` |

**Example:**

\`\`\`json
{
  "name": "my-resource",
  "tags": ["production"]
}
\`\`\`

### Response

**`201 Created`**

\`\`\`json
{
  "id": "res_abc123",
  "name": "my-resource",
  "created_at": "2026-01-15T10:30:00Z"
}
\`\`\`

### Errors

| Status | Code | Description |
|---|---|---|
| `400` | `invalid_name` | Name contains invalid characters |
| `409` | `duplicate` | Resource with this name already exists |
| `429` | `rate_limited` | Too many requests. Retry after `Retry-After` header value |
```

### Configuration Reference

```markdown
# Configuration Reference

## Configuration File

Location: `~/.tool/config.yaml`

| Key | Type | Default | Description |
|---|---|---|---|
| `log_level` | `string` | `"info"` | Logging level (`debug`, `info`, `warn`, `error`) |
| `timeout` | `integer` | `30` | Request timeout in seconds |
| `retries` | `integer` | `3` | Number of retry attempts |

## Environment Variables

| Variable | Description | Overrides |
|---|---|---|
| `TOOL_LOG_LEVEL` | Logging level | `log_level` in config file |
| `TOOL_API_KEY` | API authentication key | - |
```

## Anti-Patterns

| Don't                          | Why                                 | Instead                                         |
| ------------------------------ | ----------------------------------- | ----------------------------------------------- |
| Add "Getting Started" sections | That's a tutorial                   | Link to the tutorial                            |
| Explain design decisions       | That's explanation                  | Link to explanation docs                        |
| Walk through workflows         | That's a how-to guide               | Link to how-to guides                           |
| Omit edge cases or constraints | Reference must be complete          | Document limits, defaults, and error conditions |
| Use inconsistent formatting    | Users rely on predictable structure | Apply the same template everywhere              |
| Add conversational commentary  | Reference is austere and factual    | State facts neutrally                           |
| Skip documenting error states  | Users need to handle errors         | List all errors with their meaning              |
