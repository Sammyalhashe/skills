---
name: jj
description: This skill should be used when the user asks about jj (jujutsu), wants to work with a jj repo, mentions jj commands like describe/new/fetch/rebase/push, or needs help with jj workflows. Use proactively whenever the user mentions jj, jujutsu, or working with a jj repository. Make sure to use this skill whenever the user mentions jj, jujutsu, or wants to do any version control work in a jj repo.
effort: low
context: inline
---

# Jujutsu (jj) VCS Skill

## CRITICAL: Agent Behavioral Rules

### Do NOT use raw git commands in a jj repo

If `.jj/` exists in the project root, this is a jj-managed repository. Use `jj` commands exclusively. Raw `git` commands can corrupt jj's internal state.

### Fetch/Rebase Policy

**DO NOT fetch or rebase unless the user explicitly asks or the task requires upstream changes.**

Most tasks (editing files, describing commits, creating new changes, squashing, splitting) are purely local. Unnecessary rebase can silently introduce conflicts that overwrite your changes.

**When fetch+rebase IS appropriate:**
- Start of a session (fetch once to check, rebase only if upstream moved)
- User explicitly says "sync", "update", "pull", "fetch", or "rebase"
- About to create a PR and want it based on latest main
- User asks to resolve conflicts with upstream

**When fetch+rebase is NOT appropriate:**
- You just made local edits and want to commit/describe them
- You're in the middle of a multi-step local workflow
- You're squashing, splitting, or reorganizing local commits
- You're creating a new change on top of current work

**Rebase safety:**
- `jj rebase` can introduce conflicts that silently mangle your changes
- jj does NOT stop on conflicts — it records them in the commit and continues
- Always `jj log` after rebase to verify changes are intact
- Use `jj op undo` immediately if rebase produced unexpected results

## Core Mental Model

- **Working copy is a commit** (`@`). Every file change is auto-snapshotted on the next jj command.
- **No staging area** — every commit is a full snapshot.
- **Change IDs** are stable 12-letter identifiers (e.g., `kkmpptxz`) that survive rewrites. Prefer these over commit hashes when referencing revisions.
- **Bookmarks** are mutable pointers to commits (like Git branches). Only needed for pushing.
- **Operations are reversible** — `jj op undo` reverts any operation safely.

## Command Reference

### Status and History

```bash
jj status                    # Working copy state
jj log                       # Revision history (graph view)
jj log --no-graph            # Plain list
jj show @                    # Show current working copy commit
jj diff                      # Diff of working copy changes
jj diff -r <rev>             # Diff of a specific revision
```

### Creating and Describing Commits

```bash
jj new [<parent>]            # Create new empty change on top of parent or @
jj describe -m "message"     # Describe current working copy commit
jj describe <rev> -m "msg"   # Describe a specific commit
jj commit -m "message"       # Snapshot + create new empty change on top (preferred)
```

### Editing Existing Commits

```bash
jj edit <rev>                # Check out an existing commit for editing
jj squash                    # Squash working copy into its parent
jj squash --from <rev>       # Squash a specific revision into its parent
jj squash --from <s> --into <d>  # Squash into a non-adjacent commit
jj squash -i                 # Interactive: select which hunks to move
jj split                     # Split current revision into two (interactive)
jj absorb                    # Auto-distribute working copy changes into ancestors
```

### Bookmarks (Branches)

```bash
jj bookmark list             # List all bookmarks
jj bookmark create <name> [-r <rev>]   # Create new (errors if exists — safe)
jj bookmark set <name> [-r <rev>]      # Create or move (overwrites — use with care)
jj bookmark track <name>@<remote>      # Track a remote bookmark locally
jj bookmark delete <name>              # Delete a local bookmark
```

### Syncing with Remotes

```bash
jj git fetch                 # Fetch all tracked remotes
jj git fetch --remote <name> # Fetch a specific remote
jj rebase -d main@origin     # Rebase current work onto fetched main
jj git push                  # Push bookmarks that have local changes
jj git push --bookmark <name>          # Push a specific bookmark
jj git push --change <rev>             # Push a change (auto-creates bookmark)
```

### Abandoning and Restoring

```bash
jj abandon <rev>             # Abandon a commit (content absorbed into parent)
jj restore --from <rev> <path>         # Restore file from another revision
jj revert <rev>              # Create new commit that reverses a change
```

### Recovery

```bash
jj op log                    # View operation history
jj op undo                   # Undo the last operation
jj op restore <op-id>        # Restore repo to a specific operation state
```

### Useful Revsets

```
@                            # Current working copy
@-                           # Parent of working copy
main@origin                  # Remote bookmark position
bookmarks()                  # All bookmarks
mine()                       # Commits authored by you
conflicts()                  # Commits with unresolved conflicts
```

## Workflows

### Local Work (Most Common — No Fetch Needed)

This is the default workflow for making changes:

```bash
# 1. Check current state
jj status
jj log

# 2. Make your edits to files (jj auto-snapshots on next command)

# 3. Describe your work
jj describe -m "feat: implement X"

# 4. When done, create a new empty change for next task
jj new
```

### Start-of-Session Sync

When beginning a session, fetch once to check if upstream moved:

```bash
# 1. Fetch to update remote bookmarks
jj git fetch

# 2. Check if main@origin has new commits
jj log -r 'main@origin' --no-graph
```

**If main@origin moved ahead of your work**, rebase:
```bash
jj rebase -d main@origin
jj log   # verify changes survived intact
```

**If main@origin hasn't moved**, skip the rebase — nothing to sync.

After this, do NOT fetch/rebase again mid-session unless there's a specific reason.

### Pre-Push Checklist

Before pushing, verify the commit is valid:

```bash
# 1. Check the commit you want to push
jj log -r @- --no-graph

# 2. Verify it has a description and is not empty
#    - If empty: don't push
#    - If undescribed: jj describe -m "..." first

# 3. Set bookmark to the commit
jj bookmark set <branch-name> -r @-

# 4. Push
jj git push --bookmark <branch-name>
```

### Creating a Feature Branch for PR

```bash
# 1. (Optional) Sync if you want latest main
jj git fetch
jj rebase -d main@origin

# 2. Make changes and describe
jj describe -m "feat: my feature"

# 3. Create bookmark and push
jj bookmark create my-feature -r @
jj git push --bookmark my-feature
```

### Updating an Existing PR

```bash
# Make additional changes (they auto-snapshot)
jj describe -m "feat: updated description"

# Move bookmark forward and push
jj bookmark set my-feature -r @
jj git push --bookmark my-feature
```

## Conflict Resolution

jj stores conflicts in commits — they don't block work.

```bash
jj resolve --list            # List conflicted files
jj resolve [file]            # Open merge tool
jj edit <conflicted-rev>     # Jump to conflicted commit to fix it
```

After resolving a conflict in an ancestor, descendants often auto-resolve too.

## Common Mistakes to Avoid

| Mistake | Consequence | Fix |
|---------|-------------|-----|
| Reflexive fetch+rebase | Overwrites local changes with conflicts | Only sync when needed |
| Using raw git in a jj repo | Corrupts jj state | Always use jj commands |
| Pushing without bookmark | "Nothing to push" | `jj bookmark set <name> -r @` first |
| Pushing empty/undescribed commit | Remote rejects it | `jj describe -m "..."` first |
| Using `bookmark set` for new bookmarks | Silently overwrites | Use `bookmark create` for safety |
| Not checking log after rebase | Miss conflict damage | Always `jj log` after rebase |
| Using `jj undo` after `jj git push` | Confuses local/remote state | Only undo local operations |

## Tips

- `jj op undo` is your safety net — use it liberally for local mistakes.
- The working copy (`@`) is always a commit. After push, jj creates a new empty `@` on top — this is normal.
- Prefer change IDs over commit hashes — they survive rewrites.
- Prefer `jj commit -m "msg"` over `jj describe` + `jj new` — one step instead of two.
- Use `jj log --no-graph -r 'bookmarks()'` to see all bookmark positions.
