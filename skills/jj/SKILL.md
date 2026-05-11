---
name: jj
description: This skill should be used when the user asks about jj (jujutsu), wants to work with a jj repo, mentions jj commands like describe/new/fetch/rebase/push, or needs help with jj workflows. Use proactively whenever the user mentions jj, jujutsu, or working with a jj repository. Make sure to use this skill whenever the user mentions jj, jujutsu, or wants to do any version control work in a jj repo.
---

# Jujutsu (jj) VCS Skill

Jujutsu is an experimental VCS designed for simplicity and efficiency. It differs significantly from Git in its mental model.

## Core Mental Model

- **Commits are immutable** by default. You never edit a commit; you create a new one with the desired content.
- **Working copy is a commit** with a special name `@`. It tracks both content and a parent pointer.
- **Bookmarks** are mutable pointers to commits (like Git branches). They live in local and remote namespaces.
- **Workspace** is a checkout of a commit into the filesystem. A repo can have multiple workspaces.
- **No staging area** — every commit is a full snapshot of the working copy.

## Repository Setup

### Cloning

```bash
# Clone a remote repo (creates a jj repo + workspace)
jj git clone <url> [<directory>]

# Clone and track a specific bookmark
jj git clone <url> --branch <bookmark>
```

### Remote Management

```bash
# List remotes
jj git remote list

# Add a remote (prefer SSH for git operations)
jj git remote add <name> git@github.com:<owner>/<repo>.git

# Remove a remote (does not delete the underlying Git remote)
jj git remote remove <name>

# Rename a remote
jj git remote rename <old> <new>

# Set remote URL
jj git remote set-url <name> <url>
```

## Working with Commits

### Creating New Commits

```bash
# Create a new, empty change and start editing it
jj new [<parent>]

# Create a new change on top of a specific commit
jj new <commit-id>

# Create a new change based on the working copy (snapshot current state)
jj new --ignore-working-copy  # avoids snapshotting first
```

### Describing Commits

```bash
# Describe the current working-copy commit
jj describe

# Describe a specific commit
jj describe <commit-id>

# Describe with message inline
jj describe -m "commit message"

# Edit metadata without changing content
jj metaedit <commit-id>
```

### Viewing Changes

```bash
# Show repo status (working copy state)
jj status          # or: jj st

# Show a commit's description and changes
jj show <commit-id>

# Show revision history
jj log

# Compare file contents between revisions
jj diff [<from> [<to>]]

# Compare diff of two revisions
jj diffedit         # interactive diff editor for the working copy
```

## Syncing with Remotes

### Fetching

```bash
# Fetch all tracked remotes, updating remote bookmarks
jj git fetch

# Fetch a specific remote
jj git fetch --remote <name>

# Fetch from a specific URL
jj git fetch --url <url>
```

After fetching, remote bookmarks are updated but local bookmarks are not. You must rebase or checkout to see fetched changes.

### Rebasing from Upstream

```bash
# Rebase the current workspace's working copy onto the latest remote bookmark
jj rebase -o <remote>/<bookmark>

# Rebase a specific commit
jj rebase -s <commit-id> -d <new-parent>
```

Common pattern for syncing with upstream:
```bash
jj git fetch
jj rebase -o main@origin
```

### Pushing

```bash
# Push all local bookmarks that point to commits already on the remote
jj git push

# Push specific bookmarks
jj git push --bookmark <bookmark-name>

# Push to a specific remote
jj git push --remote <name>

# Force push (recreate remote bookmark at new commit)
jj git push --force

# Push all local bookmarks, creating new ones on the remote
jj git push --all

# Track a remote bookmark after pushing
jj bookmark track <bookmark> --remote=origin
```

## Advanced Operations

### Abandoning Commits

```bash
# Abandon a commit (its content gets absorbed into parents)
jj abandon <commit-id>
```

### Restoring and Reverting

```bash
# Restore file contents from another revision
jj restore --from <commit-id> --to <commit-id>

# Revert a commit (creates a new commit with reversed changes)
jj revert <commit-id>
```

### Squash and Split

```bash
# Move changes from one revision into another
jj squash -s <source> -d <dest>

# Split a revision into two via interactive editor
jj split

# Move changes from a revision into its parents
jj absorb
```

### Working with Bookmarks

```bash
# List bookmarks
jj bookmark list

# Create or move a bookmark to a commit
jj bookmark set <name> [-r <commit>]

# Track a remote bookmark (creates local tracking bookmark)
jj bookmark track <bookmark> --remote=origin

# Untrack a remote bookmark
jj bookmark untrack <bookmark> --remote=origin

# Delete a local bookmark
jj bookmark delete <name>
```

### Syncing Bookmarks Before Push

When you push to a remote, jj makes the current working copy commit immutable and creates a new empty working copy commit on top. Before pushing, update your local bookmarks to the latest change:

```bash
# Update local bookmark to current change before pushing
jj bookmark set main -r @
jj bookmark set master -r @

# Then push
jj git push
```

## Standard Workflow

1. `jj git fetch` — fetch upstream changes
2. `jj status` — inspect branch state visually
3. `jj git rebase -o main@origin` — rebase onto origin main (if needed)
4. `jj new` — create a new change/commit
5. `jj describe` — edit commit description (must be done before pushing)
6. `jj bookmark set <bookmark> -r @` — update local bookmark to current change
7. `jj git push`

## Common Workflows

### Daily Sync Workflow

```bash
# 1. Fetch upstream
jj git fetch

# 2. Check status
jj status

# 3. Rebase onto latest remote main
jj git rebase -o main@origin

# 4. Create new change for your work
jj new

# 5. Describe your commit
jj describe -m "your message"

# 6. Update bookmark to current change
jj bookmark set main -r @

# 7. Push
jj git push
```

### Multi-Remote Sync

```bash
# Fetch from multiple remotes
jj git fetch --remote origin
jj git fetch --remote upstream

# Rebase onto whichever you want as the target
jj git rebase -o main@upstream
```

### Creating a New Feature Branch

```bash
# 1. Fetch and rebase
jj git fetch
jj git rebase -o main@origin

# 2. Create new change
jj new

# 3. Describe and make changes
jj describe -m "feature: implement X"

# 4. Update bookmark and push
jj bookmark set feature-x -r @
jj git push --bookmark feature-x
```

## Configuration

### Config File Locations

Jujutsu config uses a two-level system:
- **Repo config**: `.jj/repo/config.toml` (or `config.toml` inside `.jj/`) — repo-specific settings
- **User config**: `~/.config/jj/config.toml` — global settings

### Setting Config Non-Interactively

Use `--config` flag to set config values without opening an editor:

```bash
# Set a repo-level config value
jj --config "user.name='Sammy'" --config "user.email='sammy@example.com'" status

# Set a global config value via user config
echo 'user.name = "Sammy"' >> ~/.config/jj/config.toml
echo 'user.email = "sammy@example.com"' >> ~/.config/jj/config.toml

# Set the push revset to push all bookmarks by default
jj --config "git.push=bookmark" status

# Configure jj to use main as default branch
jj --config "git.push=bookmark" status
```

### Config Edit

`jj config edit` opens an interactive editor. To avoid the pager prompt, set the EDITOR env var:

```bash
# Non-interactive config edit (requires EDITOR to be set)
EDITOR="vi" jj config edit --repo
EDITOR="vi" jj config edit

# Or use cat to append directly (no interactive prompt)
echo 'ui.log-format = "compact"' >> ~/.config/jj/config.toml
echo 'git.push = "bookmark"' >> ~/.config/jj/config.toml
```

### Common Config Settings

```toml
# ~/.config/jj/config.toml
[user]
name = "Your Name"
email = "your@email.com"

[ui]
log-format = "compact"  # shorter log output

[git]
# Push all bookmarks by default instead of only tracking ones
push = "bookmark"
# Default remote for push/fetch operations
push-remote = "origin"
```

### Tips

- Use `jj help <command>` for detailed help on any command
- Use `jj log --graph` for a visual revision graph
- The working copy (`@`) is always a commit — you can show it with `jj show @`
- Use `--ignore-working-copy` flag to skip snapshotting when you know the state is clean
- Bookmarks are the primary unit of versioning, not commits

### Automatic Working Copy Commits

When you push to a remote (e.g., `jj git push`), jj makes the current working copy commit immutable and creates a new empty working copy commit on top. These empty commits are normal and expected — they are jj's way of tracking the mutable working copy state. You do not need to abandon or clean them up; they are part of jj's design.
