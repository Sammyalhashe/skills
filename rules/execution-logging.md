## Execution Logging

After completing any skill-triggered action, append a single JSONL line to `~/.claude/skills/execution.log`:

```json
{"ts":"2026-05-12T16:30:00Z","skill":"jj-sync","action":"push","outcome":"success"}
```

### Fields

| Field | Description |
|-------|-------------|
| `ts` | ISO 8601 timestamp (UTC) |
| `skill` | Skill directory name that was invoked |
| `action` | Short verb describing what was done (sync, build, create, fix) |
| `outcome` | `success` or `failure` |
| `error` | (optional) One-line error description if outcome is failure |

### Rules

- One line per skill invocation. No multi-line entries.
- Log after the action completes, not before.
- Don't log trivial reads or status checks — only actions that changed state.
- Create the file if it doesn't exist. Append only, never truncate.
- If the log file exceeds 1000 lines, note this to the user but don't auto-truncate.
