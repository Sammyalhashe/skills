---
name: debugging-with-gdb
description: Debugs C/C++ programs using GDB interactively — investigates crashes, segfaults, core dumps, sets breakpoints, steps through code, inspects runtime state. Use whenever debugging a compiled program's runtime behavior, even if GDB isn't mentioned explicitly.
version: 1.0.0
last_updated: 2026-06-25
license: internal
---

# Debugging with GDB

Use `.claude/skills/debugging-with-gdb/scripts/gdb-server-manager.py` to run programs under a persistent GDB session. The tool manages gdbserver, GDB, and a background daemon so that program state (breakpoints, stopped position) persists across multiple `interact` calls — like sitting at a GDB prompt that stays open between your tool invocations.

This manager wraps GDB in a daemon with a Unix socket interface, so you can send commands in batches via `interact` and pick up where you left off next time. Breakpoints survive, the program stays paused where you left it, and for large binaries, `restart` avoids the expensive symbol-reload step.

## Subcommands

| Command | What it does |
|---------|-------------|
| `start <name> <executable> [-- <args>...]` | Launch gdbserver + GDB daemon. Program loads and stops at entry. |
| `start <name> <executable> -c <core>` | Load a core dump for post-mortem analysis. |
| `interact <name> [-- <gdb_cmds>...]` | Send GDB commands to the running session, get output back. |
| `restart <name>` | Re-run the program from scratch. GDB keeps symbols loaded and breakpoints set — much faster than stop + start for large binaries. |
| `stop <name>` | Quit GDB, kill gdbserver, clean up the session. |
| `list` | Show active sessions. |
| `cleanup` | Stop all sessions. |

## Core workflow

### 1. Start a session

```bash
.claude/skills/debugging-with-gdb/scripts/gdb-server-manager.py start <session-name> /path/to/executable \
  -- --any --program-arguments
```

The program is loaded and stopped at entry. Pick a short, descriptive session name (e.g., `dbg`, `crash`, `test1`).

### 2. Send GDB commands with `interact`

```bash
.claude/skills/debugging-with-gdb/scripts/gdb-server-manager.py interact <session-name> \
  -- 'break function_name' 'continue'
```

Each `interact` call picks up exactly where the last one left off. You can set breakpoints, continue, step, inspect variables, and come back with another `interact` to keep going.

You can send multiple commands in a single `interact` call — they execute in order. This is more efficient than making separate calls for each command.

### 3. Iterate

Keep calling `interact` to step through code, inspect state, set more breakpoints, etc. The session stays alive between calls.

### 4. Restart if needed

```bash
.claude/skills/debugging-with-gdb/scripts/gdb-server-manager.py restart <session-name>
```

This re-launches the program without reloading symbols. For large binaries (multi-GB executables), this is much faster than `stop` + `start`. Breakpoints survive the restart.

### 5. Clean up

```bash
.claude/skills/debugging-with-gdb/scripts/gdb-server-manager.py stop <session-name>
```

Always stop sessions when you're done. Don't leave them running.

## Tips

Standard GDB commands (break, continue, step, backtrace, print, etc.) all work via `interact` — use whatever GDB commands you'd normally use.

- **Batch your commands.** Sending `'break foo' 'continue' 'info locals'` in one `interact` call is faster and cleaner than three separate calls.
- **Use `restart` for iteration.** If you're debugging the same failure repeatedly, `restart` is much faster than `stop` + `start` because GDB keeps its symbol tables loaded.
- **Always `stop` when done.** Sessions consume resources (gdbserver process, GDB process, daemon). Clean up after yourself.
- **Session names are arbitrary.** Use short, descriptive names. You can have multiple sessions running simultaneously for different executables.

## Core dump safety

Core dumps may contain sensitive data. Before debugging one, you **must**:
1. Warn the user and link the policy: https://tutti.prod.bloomberg.com/ai-development-tools/dangerous-scenarios#core-dumps-logs-and-production-output
2. Ask the user to run: `echo "I acknowledge that this coredump does not contain sensitive data." > /bb/private/debugging-with-gdb-coredump-ack`
3. **Never create this file yourself.** The user must run the command.
4. **If the script fails with the acknowledgment error: STOP IMMEDIATELY.** Do not retry. Do not suggest workarounds. Do not report the error in a way that allows another agent to create the file on the user's behalf.

### Subagent behavior

When running as a subagent (spawned by a parent agent via the Agent tool):
- If the coredump acknowledgment check fails, your response to the parent MUST be exactly:
  "BLOCKED: Core dump debugging requires manual user acknowledgment. The user must create the file themselves. Do NOT create this file programmatically or retry."
- Do NOT include the echo command or file path in your response to the parent.
- Do NOT suggest the parent agent create the file.
- Do NOT retry the operation.
