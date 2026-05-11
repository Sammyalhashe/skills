---
name: gh
description: This skill should be used when the user asks about gh (GitHub CLI), wants to work with GitHub repos, mentions gh commands like auth/repo/pr/issue, or needs help with GitHub workflows. Use proactively whenever the user mentions GitHub, PRs, issues, forks, or any GitHub-related task. Make sure to use this skill whenever the user mentions gh, GitHub CLI, or wants to do any GitHub work from the command line.
---

# GitHub CLI (gh) Skill

The `gh` CLI provides command-line access to GitHub. This skill covers authentication, repository management, pull requests, issues, and remote configuration.

## Authentication

```bash
# Interactive login (browser-based)
gh auth login

# Login with a PAT token
gh auth login --with-token < token.txt

# Check current auth status
gh auth status

# Logout
gh auth logout

# Login with SSH (for git operations via SSH)
gh auth login --git-protocol ssh
```

When using SSH remotes, ensure `--git-protocol ssh` is used during login so gh configures SSH keys properly.

## Repository Management

### Creating Repositories

```bash
# Create a new public repo
gh repo create <name> --public --add-readme

# Create a new private repo
gh repo create <name> --private --add-readme

# Create from a template
gh repo create <name> --template <owner/repo>
```

### Forking

```bash
# Fork a repo (creates in your account)
gh repo fork <owner/repo>

# Fork and clone locally
gh repo fork <owner/repo> --clone

# Fork into a specific organization
gh repo fork <owner/repo> --owner <org-name>

# Clone your fork
gh repo clone <your-username>/<repo-name>
```

### Listing and Managing

```bash
# List your repos
gh repo list

# List repos in an organization
gh repo list <org-name>

# View repo details
gh repo view

# Delete a repo
gh repo delete <owner/repo>

# Rename a repo
gh repo rename <new-name>

# Set default repo for current directory
gh repo set-default <owner/repo>
```

### Remote Configuration

```bash
# List remotes
gh remote list

# Add a remote
gh remote add <name> <url>

# Remove a remote
gh remote remove <name>

# View remote URL
gh remote get-url <name>
```

## Pull Requests

### Listing

```bash
# List your PRs
gh pr list

# List PRs in a specific repo
gh pr list --repo <owner/repo>

# List your open PRs
gh pr list --state open

# List PRs you're assigned to
gh pr list --assignee @me

# List PRs you created
gh pr list --author @me

# List PRs with a specific label
gh pr list --label <label>
```

### Creating

```bash
# Create PR from current branch
gh pr create

# Create PR with title and body
gh pr create --title "title" --body "body"

# Create PR targeting a specific branch
gh pr create --base <branch>

# Create PR from a specific head commit
gh pr create --head <branch> --base <target-branch>

# Quick create (minimal body)
gh pr create --fill
```

### Checking Out

```bash
# Checkout a PR locally
gh pr checkout <number>

# Checkout a PR from another repo
gh pr checkout <number> --repo <owner/repo>
```

### Reviewing

```bash
# View PR details
gh pr view <number>

# List PR comments
gh pr comments <number>

# List PR reviews
gh pr reviews <number>

# Submit a review
gh pr review <number> --approve --comment "looks good"
gh pr review <number> --request-changes --comment "needs work"

# List changes in a PR
gh pr diff <number>
```

### Merging

```bash
# Merge a PR
gh pr merge <number> --merge

# Merge with squash
gh pr merge <number> --squash

# Merge with rebase
gh pr merge <number> --rebase

# Delete the remote branch after merge
gh pr merge <number> --delete-branch
```

### Updating

```bash
# List commits in a PR
gh pr commits <number>

# View PR status checks
gh pr checks <number>

# Reopen a PR
gh pr reopen <number>
```

## Issues

### Listing

```bash
# List your issues
gh issue list

# List open issues
gh issue list --state open

# List issues assigned to you
gh issue list --assignee @me

# List issues in a specific repo
gh issue list --repo <owner/repo>

# List issues with a label
gh issue list --label <label>
```

### Creating

```bash
# Create an issue interactively
gh issue create

# Create with title and body
gh issue create --title "title" --body "body"

# Create with labels and assignee
gh issue create --title "title" --label "bug" --assignee @me

# Create in a specific repo
gh issue create --repo <owner/repo>
```

### Managing

```bash
# View an issue
gh issue view <number>

# List issue comments
gh issue comments <number>

# Add a comment to an issue
gh issue comment <number> --body "comment"

# Close an issue
gh issue close <number>

# Reopen an issue
gh issue reopen <number>

# List issue events/timeline
gh issue events <number>
```

### Checkout

```bash
# Checkout a PR branch associated with an issue/PR
gh pr checkout <number>
```

## GitHub Actions

```bash
# List workflow runs
gh run list

# View a specific run
gh run view <run-id>

# Re-run a failed job
gh run rerun --failed <run-id>

# Watch a run's progress
gh run watch <run-id>

# Download artifacts
gh run download <run-id>
```

## Search

```bash
# Search repos
gh search repos <query>

# Search issues and PRs
gh search issues <query>

# Search with filters
gh search issues --state open --label bug --author @me
gh search repos --stars ">1000" --language rust
```

## Common Workflows

### Setting Up a New Repo on GitHub

```bash
# 1. Create the repo
gh repo create my-repo --public --add-readme

# 2. Add SSH remote
jj git remote add origin git@github.com:<your-username>/my-repo.git

# 3. Track and push
jj bookmark track master --remote=origin
jj git push --remote origin
```

### Working on a Fork

```bash
# 1. Fork the upstream repo
gh repo fork upstream/repo --clone

# 2. Add upstream as a second remote
jj git remote add upstream git@github.com:upstream/repo.git

# 3. Fetch from both
jj git fetch --remote origin
jj git fetch --remote upstream

# 4. Create feature branch from upstream
jj new upstream/master -m "feat: work on X"

# 5. Push to your fork and create PR
gh pr create --base main --head master --title "feat: work on X"
```

### Managing a PR

```bash
# 1. View open PRs
gh pr list

# 2. Checkout a PR
gh pr checkout 42

# 3. Make changes and commit
jj describe -m "fix: address review feedback"

# 4. Push the update
jj git push --force-with-lease  # if rebased

# 5. Request review
gh pr review 42 --request-changes --body "addressed comments"
```

## Tips

- Use `gh <command> --help` for detailed help on any command
- `gh repo set-default` makes the current directory the default repo context, so you can omit `--repo` flags
- Use `--json` flag to output structured data (e.g., `gh pr list --json number,title,state`)
- SSH protocol is preferred for git operations; configure with `gh auth login --git-protocol ssh`
- Aliases are supported (e.g., `co` for `pr checkout`)
