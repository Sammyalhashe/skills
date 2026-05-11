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

# Add a remote
jj git remote add <name> <url>

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
jj rebase -s @ -d <remote>/<bookmark>

# Rebase a specific commit
jj rebase -s <commit-id> -d <new-parent>

# Rebase all local commits onto the fetched remote
jj rebase -s '@|-root()' -d <remote>/<bookmark>
```

Common pattern for syncing with upstream:
```bash
jj git fetch --remote origin
jj rebase -s @ -d origin/master
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

## Common Workflows

### Daily Sync Workflow

```bash
# 1. Check current status
jj status

# 2. Fetch all remotes
jj git fetch

# 3. Rebase local work onto latest remote
jj rebase -s @ -d origin/master

# 4. Push changes back
jj git push
```

### Multi-Remote Sync

```bash
# Fetch from multiple remotes
jj git fetch --remote origin
jj git fetch --remote upstream

# Rebase onto whichever you want as the target
jj rebase -s @ -d upstream/master
```

### Creating a New Feature Branch

```bash
# 1. Create new change
jj new origin/master -m "feature: start work on X"

# 2. Make changes, then describe
jj describe -m "feature: implement X"

# 3. Push the bookmark
jj git push --bookmark <bookmark-name>
```

## Tips

- Use `jj help <command>` for detailed help on any command
- Use `jj log --graph` for a visual revision graph
- The working copy (`@`) is always a commit — you can show it with `jj show @`
- Use `--ignore-working-copy` flag to skip snapshotting when you know the state is clean
- Bookmarks are the primary unit of versioning, not commits
