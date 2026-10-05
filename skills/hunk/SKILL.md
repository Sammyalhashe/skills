---
name: hunk
description: Reviews diffs through a live Hunk session by loading the review skill bundled with the installed hunk CLI. Use when the user asks to review changes with Hunk, has a Hunk session open, or wants review comments placed on a diff they are viewing in Hunk.
effort: low
context: inline
---

# Hunk

Load the Hunk skill and use it for this review.

1. Run `hunk skill path` to get the path of the skill bundled with the installed
   hunk.
2. Read that file and follow it for the rest of the review.

The bundled skill ships with hunk itself, so it always matches the installed
version. Do not copy its contents here.

If `hunk` is not on PATH, tell the user rather than guessing at its commands.
