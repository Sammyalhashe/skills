---
name: jj-sync
description: Use this skill to safely sync Jujutsu (jj) repositories. It ensures changes are described, bookmarks are set, and pushes are only attempted on valid commits.
---

# Jujutsu (jj) Sync Skill

This skill provides a robust workflow for syncing `jj` repositories, avoiding common mistakes like pushing empty or undescribed commits.

## Safe Sync Workflow

Instead of running individual commands, use this sequence to ensure your repository state is valid before pushing:

```bash
# 1. Fetch latest changes from remote
jj git fetch

# 2. Check if there are any local commits that need a description
jj log -r "@-" --no-graph

# 3. If the latest commit is empty or lacks a description, describe it
jj describe -m "feat: <describe your changes here>"

# 4. Set the 'main' bookmark to the current commit
jj bookmark set main -r @

# 5. Push changes
jj git push
```

## Tool Guidelines for Agents

1. **Check Before Push**: ALWAYS run `jj log -n 1` to inspect the commit you are about to push. 
2. **Mandatory Descriptions**: Never attempt to push a commit that is empty or lacks a clear description. If the working copy is empty, check `jj log -r @-` instead.
3. **Bookmark Management**: Always explicitly set your primary bookmark (usually `main`) to the commit you intend to push.
4. **Error Handling**: If `jj git push` fails, do not retry blindly. Check `jj status` and `jj log` to see if your local state has diverged or if the commit is invalid.

## Common Pitfalls

- **Empty Commits**: Attempting to push the working-copy commit when it contains no changes.
- **Undescribed Commits**: Pushing a commit that has no description, which most remotes will reject.
- **Bookmark Mismatch**: Pushing without updating the remote-tracking bookmark, leading to "nothing changed" warnings.
