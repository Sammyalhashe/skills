---
name: skill-creator
description: Use this skill when you need to create a new skill or update an existing one. It guides you through the creation of SKILL.md, bundled resources, and packaging.
effort: medium
context: inline
---

# Skill Creator

This skill provides a procedural guide for creating, iterating, and packaging new skills for Gemini CLI and other AI agent harnesses.

## Anatomy of a Skill

A skill consists of:
- **SKILL.md**: Frontmatter (YAML) + Markdown instructions.
- **Resources**: `scripts/`, `references/`, `assets/` (optional).
- **Metadata**: `_meta.json` (for OpenAI/cross-platform compatibility).

## SKILL.md Frontmatter

Every SKILL.md must have YAML frontmatter with these fields:

```yaml
---
name: skill-name
description: When to use this skill (triggers, keywords, scenarios).
effort: low|medium|high
context: inline|fork
---
```

| Field | Values | Meaning |
|-------|--------|---------|
| `effort` | `low` | Handle inline, no subagent needed |
| | `medium` | May benefit from a subagent for research |
| | `high` | Definitely delegate to subagent |
| `context` | `inline` | Must run in main conversation (needs user state) |
| | `fork` | Safe to run in isolated subagent context |

## Workflow

### 1. Initialize

```bash
mkdir -p skills/<skill-name>
```

### 2. Create Content

- **SKILL.md**: Frontmatter (with all required fields) + procedural instructions.
- **_meta.json**: Machine-readable metadata for cross-platform compatibility.
  ```json
  {
    "name": "<skill-name>",
    "description": "Short description for agent harnesses.",
    "version": "1.0.0"
  }
  ```

### 3. Packaging

Place skill in the `skills/` directory of the skills repo. The flake automatically packages it for:
- **Claude Code** (`claude/`)
- **Gemini CLI** (`gemini/`)
- **OpenAI Harnesses** (`openai/`)

The build also:
- Appends skill content to AGENTS.md
- Generates a context routing table entry in CLAUDE.md

## Best Practices

- **Procedural Knowledge**: Focus on "how-to" rather than "what-is".
- **Tool Guidelines**: Include a section for AI agents explicitly stating safety rules and common pitfalls.
- **Modularity**: Keep skills focused on a single domain (e.g., git, nix, sops).
- **Execution Logging**: Skills that change state should remind the agent to log to `~/.claude/skills/execution.log`.
- **Customizations**: Users can override skill behavior via `~/.claude/customizations/<skill-name>.md`.
