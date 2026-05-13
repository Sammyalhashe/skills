# AI Skills Flake

Multi-platform AI agent skill distribution system. Provides skills, rules, and composition utilities for Claude, Gemini, and OpenAI agents via Nix.

## Flake Outputs

### Individual Skills

Each skill is available as a standalone package:

```
packages.${system}.skill-jj
packages.${system}.skill-jj-sync
packages.${system}.skill-gh
packages.${system}.skill-cloudflared
packages.${system}.skill-nix-health
packages.${system}.skill-skill-creator
packages.${system}.skill-sops-nix
packages.${system}.skill-caveman
```

### Agent Personas

Specialized personas that shape how the AI approaches problems:

```
packages.${system}.agent-neckbeard-nate       # C++ performance & HPC veteran
packages.${system}.agent-planning-paul        # Task decomposition & delegation
packages.${system}.agent-nitpick-nancy        # Testing zealot & QA enforcer
packages.${system}.agent-algorithm-alex       # DS&A and competitive programming
packages.${system}.agent-api-alice            # Library & API design architect
packages.${system}.agent-nix-ninja            # Nix/NixOS ecosystem specialist
packages.${system}.agent-devils-advocate-dave # Adversarial design reviewer
packages.${system}.agent-fullstack-felix      # TypeScript/JavaScript full-stack expert
```

### Rules

Global agent rules (algorithm, execution logging, commit conventions):

```
packages.${system}.rules
```

### Bundles (backward-compatible)

```
packages.${system}.ai-skills         # Everything (local + downloaded skills)
packages.${system}.local-skills      # All local skills composed with rules
packages.${system}.downloaded-skills # All external skills
packages.${system}.default           # Alias for ai-skills
```

### Composition Library

```
lib.composeSkills  # Function to build a custom bundle from selected skills + agents
```

## Usage Examples

### Install everything (home-manager)

```nix
# flake.nix
{
  inputs.skills.url = "github:Sammyalhashe/skills";

  outputs = { self, skills, ... }: {
    homeConfigurations.myUser = home-manager.lib.homeManagerConfiguration {
      modules = [
        skills.homeManagerModules.ai-skills
        {
          ai-skills.enable = true;
        }
      ];
    };
  };
}
```

### Install only specific skills (home-manager)

```nix
{
  inputs.skills.url = "github:Sammyalhashe/skills";

  outputs = { self, skills, nixpkgs, ... }:
    let system = "x86_64-linux";
    in {
      homeConfigurations.myUser = home-manager.lib.homeManagerConfiguration {
        modules = [
          skills.homeManagerModules.ai-skills
          {
            ai-skills = {
              enable = true;
              selectedSkills = [
                skills.packages.${system}.skill-jj
                skills.packages.${system}.skill-gh
              ];
              # rules are included by default
            };
          }
        ];
      };
    };
}
```

### Compose a custom bundle in a consumer flake

```nix
{
  inputs.skills.url = "github:Sammyalhashe/skills";

  outputs = { self, skills, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      compose = skills.lib.composeSkills system;
    in {
      packages.${system}.my-skills = compose {
        skills = [
          skills.packages.${system}.skill-jj
          skills.packages.${system}.skill-gh
        ];
        agents = [
          skills.packages.${system}.agent-neckbeard-nate
          skills.packages.${system}.agent-planning-paul
        ];
        rules = skills.packages.${system}.rules;
      };
    };
}
```

### Use a single skill directly

```nix
# Just symlink one skill into your project's .claude/skills/
{
  inputs.skills.url = "github:Sammyalhashe/skills";

  outputs = { self, skills, ... }:
    let system = "x86_64-linux";
    in {
      # The skill package has platform dirs: claude/jj/, gemini/jj/, openai/jj/
      packages.${system}.jj-skill = skills.packages.${system}.skill-jj;
    };
}
```

### Compose without rules

```nix
let
  compose = skills.lib.composeSkills system;
in compose {
  skills = [
    skills.packages.${system}.skill-jj
  ];
  # Omit rules for a minimal bundle without global agent rules
}
```

## Architecture

The composed output follows a context-efficient design:

```
claude/
  CLAUDE.md                        → @AGENTS.md (thin shim)
  AGENTS.md                        → global rules + routing tables (no content)
  jj/SKILL.md                      → loaded on-demand when jj topic arises
  gh/SKILL.md                      → loaded on-demand when gh topic arises
  agents/neckbeard-nate/AGENT.md   → loaded when C++ perf expertise needed
  agents/fullstack-felix/AGENT.md  → loaded when TypeScript/JS expertise needed
  agents/planning-paul/AGENT.md    → loaded when task decomposition needed
  ...
gemini/
  GEMINI.md                        → @AGENTS.md
  AGENTS.md                        → same structure
  ...
```

- **`AGENTS.md`** is the single source of truth: global rules + routing tables for both skills and agent personas
- **`CLAUDE.md`** / **`GEMINI.md`** / **`OPENAI.md`** are platform shims that just import `@AGENTS.md`
- **No content is concatenated** into AGENTS.md — each `SKILL.md` and `AGENT.md` is loaded on-demand via routing table references, keeping the base context window small (~190 lines)
- **Skills** are procedures ("what to do"); **agents** are personas ("how to think")

## Adding Skills

Place a new directory under `skills/` with at minimum:
- `SKILL.md` — skill instructions with YAML frontmatter
- `_meta.json` — metadata (name, description, version)

The skill will automatically appear as `packages.${system}.skill-<dirname>`.

## Adding Agent Personas

Place a new directory under `agents/` with:
- `AGENT.md` — persona definition with YAML frontmatter (`name`, `role`, `persona`)

The agent will automatically appear as `packages.${system}.agent-<dirname>`.

Example frontmatter:
```yaml
---
name: my-agent
role: Brief role description
persona: Display Name
---
```

## Adding External Skills

Edit `modules/downloaded-skills.nix` and add an entry to `externalSkills`:

```nix
{
  owner = "github-user";
  repo = "skill-repo";
  rev = "main";
  sha256 = "..."; # nix-prefetch-url --unpack
  skillType = "single"; # "single" = repo root is the skill, "multi" = has skills/ subdirectory
  skillNames = []; # required for skillType = "multi"
}
```

## Project Structure

```
flake.nix                    # Flake definition and output wiring
skills/                      # Local skill definitions (procedures)
  jj/SKILL.md
  gh/SKILL.md
  ...
agents/                      # Agent persona definitions
  neckbeard-nate/AGENT.md
  fullstack-felix/AGENT.md
  planning-paul/AGENT.md
  ...
rules/                       # Global agent rules
  global-rules.md
  algorithm.md
  execution-logging.md
bin/                         # Utilities (statusline.sh)
hooks/                       # Hook scripts
modules/
  build-skill.nix            # Single skill → platform derivation
  build-agent.nix            # Single agent → platform derivation
  build-rules.nix            # Rules → AGENTS.md derivation
  compose-skills.nix         # [skills] + [agents] + rules → unified bundle
  install_skills.nix         # All-local composition wrapper
  downloaded-skills.nix      # External skill fetching
  home-manager.nix           # NixOS home-manager module
```
