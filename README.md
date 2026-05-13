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
lib.composeSkills  # Function to build a custom bundle from selected skills
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
          skills.packages.${system}.skill-caveman
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
  CLAUDE.md          → @AGENTS.md (thin shim)
  AGENTS.md          → global rules + routing table (no skill content)
  jj/SKILL.md        → loaded on-demand when jj topic arises
  gh/SKILL.md        → loaded on-demand when gh topic arises
  ...
gemini/
  GEMINI.md          → @AGENTS.md
  AGENTS.md          → same structure
  ...
openai/
  OPENAI.md          → @AGENTS.md
  ...
```

- **`AGENTS.md`** is the single source of truth: global rules + a routing table pointing to individual skills
- **`CLAUDE.md`** / **`GEMINI.md`** / **`OPENAI.md`** are platform shims that just import `@AGENTS.md`
- **Skill content is never concatenated** into AGENTS.md — each `SKILL.md` is loaded on-demand via `@skill-name/SKILL.md` when relevant, keeping the base context window small (~175 lines vs ~1300+)

## Adding Skills

Place a new directory under `skills/` with at minimum:
- `SKILL.md` — skill instructions with YAML frontmatter
- `_meta.json` — metadata (name, description, version)

The skill will automatically appear as `packages.${system}.skill-<dirname>`.

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
skills/                      # Local skill definitions
  jj/SKILL.md
  gh/SKILL.md
  ...
rules/                       # Global agent rules
  global-rules.md
  algorithm.md
  execution-logging.md
bin/                         # Utilities (statusline.sh)
hooks/                       # Hook scripts
modules/
  build-skill.nix            # Single skill → platform derivation
  build-rules.nix            # Rules → AGENTS.md derivation
  compose-skills.nix         # [skills] + rules → unified bundle
  install_skills.nix         # All-local-skills composition wrapper
  downloaded-skills.nix      # External skill fetching
  home-manager.nix           # NixOS home-manager module
```
