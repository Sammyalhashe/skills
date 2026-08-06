---
name: documenting-for-end-users
description: Generates end-user documentation following the Diataxis framework (tutorials, how-to guides, reference, explanation). Distinct from documenting-a-codebase which covers internal developer docs. Use when asked to create user docs, write tutorials, or generate product documentation.
version: 1.0.0
last_updated: 2026-02-24
---

# Documenting for End Users

Generates user-facing documentation using the [Diataxis framework](https://diataxis.fr). For internal developer/codebase
documentation, use `documenting-a-codebase` instead.

| Document          | Purpose                           | Answers                   |
| ----------------- | --------------------------------- | ------------------------- |
| **Tutorials**     | Learning-oriented lessons         | "Can you teach me to...?" |
| **How-to guides** | Goal-oriented directions          | "How do I...?"            |
| **Reference**     | Information-oriented descriptions | "What is...?"             |
| **Explanation**   | Understanding-oriented discussion | "Why...?"                 |

## When to Use

- "create user docs"
- "write end-user documentation"
- "generate tutorials and guides"
- "document this for users"
- "create Diataxis docs"
- "write user-facing docs"
- "generate product documentation"
- "create onboarding tutorials"
- "document the API for users"

## Workflow

### Phase 1: Explore the Project

Use the Task tool (Explore agent) and Read to understand the project:

1. Identify what the project **is** (CLI tool, library, web app, API, service)
1. Map all **user-facing surfaces** (commands, endpoints, UI pages, public API, configuration)
1. Read existing documentation, README, help text, and usage examples. If user-facing docs already exist, summarize
   what's there and confirm with the user whether to replace, augment, or restructure before proceeding
1. Identify the **primary user personas** (developer integrating a library, end user of a CLI, admin configuring a
   service)
1. Note any onboarding flow, getting-started patterns, or common workflows

### Phase 2: Plan Documentation Scope

Before writing, determine:

- **Tutorials**: What are 1-3 foundational tasks a new user must learn? What is the simplest meaningful end-to-end
  workflow?
- **How-to guides**: What are the real-world tasks users need to accomplish? What problems do they bring to this tool?
- **Reference**: What is the complete surface area that needs describing? (commands, options, config, API, error codes)
- **Explanation**: What design decisions, architecture, or concepts need context to understand?

Ask the user which output format they prefer before generating:

**Single-file** — all four quadrants as sections within one file (the existing README or a new `docs.md`), using
`## Getting Started`, `## How-To Guides`, `## Reference`, `## Explanation` as section headers. Generate a table of
contents after the intro linking to all sections and subsections. If the project uses `mdformat-toc`, add the marker
comments instead and let `mdformat` populate it.

**Multi-file** — separate files organized in a `docs/` directory:

```
docs/
  tutorials/
    getting-started.md        # First tutorial - the essential onboarding path
    [additional-tutorials].md # One file per tutorial
  how-to/
    [task-name].md            # One file per task/problem
  reference/
    [topic].md                # One file per reference area (e.g., cli.md, api.md, configuration.md)
  explanation/
    [topic].md                # One file per concept requiring context
```

File naming: lowercase, hyphen-separated, descriptive of content (e.g., `deploy-to-production.md` not `guide-3.md`).

Each file or section should start with a clear title and a one-sentence summary of what the reader will find.

### Phase 3: Generate Documentation

Generate all four quadrant types in the chosen format. Write them in this order because each builds on the previous:

1. **Tutorials** first - the getting-started onboarding path. Read `references/tutorials.md` before writing.
1. **How-to guides** - practical tasks users need to accomplish. Read `references/how-to-guides.md` before writing.
1. **Reference** - complete technical descriptions. Read `references/reference.md` before writing.
1. **Explanation** - the "why" that ties everything together. Read `references/explanation.md` before writing.

## Adapting to Project Type

The four quadrants apply regardless of project type, but emphasis shifts:

| Project Type | Tutorial Focus                 | How-to Focus           | Reference Focus                    | Explanation Focus                     |
| ------------ | ------------------------------ | ---------------------- | ---------------------------------- | ------------------------------------- |
| CLI tool     | First command to useful output | Common tasks and flags | All commands, options, env vars    | Design philosophy, config model       |
| Library/SDK  | Import to first working call   | Integration patterns   | Public API, types, errors          | Architecture, extension model         |
| Web app      | Account to first value         | Workflows, admin tasks | UI elements, settings, permissions | Data model, security model            |
| API/Service  | Auth to first request          | Common integrations    | Endpoints, schemas, errors         | Rate limiting, versioning, auth model |

## Quality Checks

After generating documentation, verify:

- [ ] Each document belongs clearly to one quadrant (no hybrid docs)
- [ ] Tutorials are completable by following steps exactly
- [ ] How-to guides address a specific real-world goal in the title
- [ ] Reference covers the complete user-facing surface area
- [ ] Explanation provides context not found in the other three types
- [ ] Cross-references link between quadrants where relevant
- [ ] No internal implementation details leaked into user-facing docs

## Tools Used

- **Task (Explore agent)**: Project exploration and surface area mapping
- **Glob**: Find existing docs, README, help text, examples
- **Grep**: Find user-facing surfaces (exports, commands, routes, CLI args)
- **Read**: Analyze source code, existing docs, config files
- **Write**: Create documentation files
- **Bash**: Run help commands, extract version info, test examples
