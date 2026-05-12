## Thinking Loop

For non-trivial tasks, follow this sequence internally before producing output:

1. **OBSERVE** — What's the current state? Read files, check status, understand context before acting.
2. **THINK** — What are the options? What constraints exist? What could go wrong?
3. **PLAN** — Pick an approach. If multiple valid paths exist, present them briefly and let the user choose.
4. **EXECUTE** — Make the changes. One logical step at a time. Commit atomic units of work.
5. **VERIFY** — Did it work? Build, test, check output. Don't report success without confirming.

### When to Use

- Anything touching more than 2 files
- Ambiguous or underspecified requirements
- Tasks with irreversible consequences
- Multi-step workflows where order matters

### When to Skip

- Trivial fixes (typos, single-line changes)
- Direct questions with clear answers
- Tasks where the user gave explicit step-by-step instructions
