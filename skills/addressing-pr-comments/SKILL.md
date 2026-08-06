---
name: addressing-pr-comments
description: Process and address PR review comments from BBGitHub. Use when the user wants to handle, triage, or address review comments on their pull request. Detects the remote (upstream preferred over origin), finds the PR for the current branch, categorizes comments by complexity, and guides the user through resolving each one.
allowed-tools: Bash(git remote:*) Bash(git branch:*) Read Edit Task AskUserQuestion TodoWrite mcp__bbgithub__bbgithub-search-issues-and-pull-requests mcp__bbgithub__bbgithub-pulls-list-review-comments mcp__bbgithub__bbgithub-pulls-get
version: 1.0.0
last_updated: 2026-01-26
license: MIT
---

# Addressing PR Comments

Process open review comments on the current branch's PR, categorize by complexity, and resolve systematically.

## Workflow

### Step 1: Detect Remote

Run `git remote -v` to list remotes. Select remote in this order:
1. `upstream` if present
2. `origin` otherwise

Extract owner/repo from the remote URL (e.g., `git@bbgithub.dev.bloomberg.com:owner/repo.git` or `https://bbgithub.dev.bloomberg.com/owner/repo`).

### Step 2: Get Current Branch

Run `git branch --show-current` to get the current branch name.

### Step 3: Find PR for Current Branch

Use `mcp__bbgithub__bbgithub-search-issues-and-pull-requests` with query:
```
is:pr is:open head:{branch-name} repo:{owner}/{repo}
```

**If no PR found:**
1. Search for other open PRs in the repo: `is:pr is:open repo:{owner}/{repo}`
2. List the found PRs to the user
3. Ask: "No PR found for branch `{branch}`. Did you mean to switch to one of these branches?"
4. Stop workflow

**If PR found:** Continue with the PR number.

### Step 4: Fetch Review Comments

Use `mcp__bbgithub__bbgithub-pulls-list-review-comments` with owner, repo, and pullNumber.

Filter to only **open/unresolved** comments (comments without a resolution or reply that resolves them).

If no open comments, inform user and stop.

### Step 5: Categorize Comments

For each open comment, categorize based on scope and complexity:

**Small comments** - Localized changes, single file, clear scope:
- Typos, naming, formatting
- Simple logic fixes
- Adding/removing a line or two
- Documentation updates

**Big comments** - Broader changes, multiple files, or requires design decisions:
- Architectural changes
- New abstractions or refactoring
- Changes affecting multiple components
- Performance optimizations requiring analysis
- Security-related changes

### Step 6: Process Small Comments

For each small comment, sub-categorize:

**Obvious fixes** (single clear solution):
- State the planned change directly: "For comment about X, I will change Y to Z"
- No question needed

**Non-obvious fixes** (multiple valid approaches):
- Generate 2-3 solution options
- Use `AskUserQuestion` tool to present options
- Example question: "How should I address: '{comment}'?"
- Options like: "Option A: ...", "Option B: ...", etc.

### Step 7: Process Big Comments

For each big comment:

1. Use `Task` tool with `subagent_type: "Explore"` to:
   - Analyze the codebase context relevant to the comment
   - Understand current implementation
   - Generate 2-4 solution approaches with trade-offs

2. Present findings using `AskUserQuestion`:
   - Summarize the comment and context
   - List each approach with pros/cons
   - Let user choose direction

### Step 8: Confirm and Execute

After all comments are categorized and decisions collected:

1. Present a summary of all planned changes:
   ```
   Small (obvious): X changes
   Small (user-selected): Y changes
   Big (user-selected): Z changes
   ```

2. Use `AskUserQuestion` to ask: "Ready to apply these changes?"
   - Option: "Yes, apply all changes"
   - Option: "Review list again"
   - Option: "Cancel"

3. If confirmed, implement changes sequentially, marking progress.

## Example Output Format

When presenting comments:

```
## PR #123: "Feature title"

### Small Comments (3)

1. **Obvious** - `src/foo.go:42` - @reviewer
   > "Typo in variable name"
   Action: Rename `recieve` to `receive`

2. **Needs input** - `src/bar.go:15` - @reviewer
   > "Consider error handling here"
   [Will ask user for preference]

### Big Comments (1)

1. `src/core/` - @reviewer
   > "This should use the new caching layer"
   [Will analyze and present options]
```
