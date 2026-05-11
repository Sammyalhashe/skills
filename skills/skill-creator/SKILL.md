---
name: skill-creator
description: Use this skill when you need to create a new skill or update an existing one. It guides you through the creation of SKILL.md, bundled resources, and packaging.
---

# Skill Creator

This skill provides a procedural guide for creating, iterating, and packaging new skills for Gemini CLI and other AI agent harnesses.

## Anatomy of a Skill

A skill consists of:
- **SKILL.md**: Frontmatter (YAML) + Markdown instructions.
- **Resources**: `scripts/`, `references/`, `assets/` (optional).
- **Metadata**: `_meta.json` (for OpenAI/cross-platform compatibility).

## Workflow

### 1. Initialize
Use a template to start.
```bash
# Create a new skill directory
mkdir -p skills/<skill-name>
```

### 2. Create Content
- **SKILL.md**: Define the trigger metadata (name/description) and procedural instructions.
- **_meta.json**: Define machine-readable metadata.
  ```json
  {
    "name": "<skill-name>",
    "description": "Short description for agent harnesses.",
    "version": "1.0.0"
  }
  ```

### 3. Packaging
Ensure your skill is placed in the `skills/` directory of the `skills` repo, and the flake will automatically package it for:
- **Claude Code** (`claude/`)
- **Gemini CLI** (`gemini/`)
- **OpenAI Harnesses** (`openai/`)

## Best Practices
- **Procedural Knowledge**: Focus on "how-to" rather than "what-is".
- **Tool Guidelines**: Include a section for AI agents explicitly stating safety rules and common pitfalls.
- **Modularity**: Keep skills focused on a single domain (e.g., git, nix, sops).
