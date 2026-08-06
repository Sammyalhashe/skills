# Writing How-To Guides

How-to guides are **goal-oriented directions** that help a user accomplish a specific real-world task. The user already
knows what they want to do and has basic competence - they need practical steps to get it done.

A how-to guide answers: **"How do I...?"**

## Table of Contents

1. [Core Principles](#core-principles)
1. [Structure](#structure)
1. [Language Patterns](#language-patterns)
1. [Anti-Patterns](#anti-patterns)

## Core Principles

### Address real-world complexity

Real problems don't always have linear solutions. Sequences fork, overlap, and require judgment. A how-to guide
acknowledges this with conditional steps: "If you're using X, do A. If you're using Y, do B instead."

### Assume competence

The reader is not learning - they are working. Don't explain foundational concepts or teach basics. They know what they
want to achieve and need directions to get there.

### Omit the unnecessary

Practical usability beats completeness. Start and end in a reasonable place. The reader will connect your guide to their
own work. You don't need to cover every possible variation - cover the common path and the important branches.

### Name it precisely

The title should say exactly what the guide shows. "How to deploy to production with zero downtime" not "Deployment" or
"Production guide." A user scanning a list of guides should know immediately whether this one solves their problem.

### Maintain focus on the goal

Everything in the guide should serve the stated goal. Explanation, background, and tangential reference dilute the
guide's usefulness. Link to those resources instead of inlining them.

### Seek flow

Ground your steps in the user's natural thinking and activity patterns. The sequence should feel logical, not arbitrary.
Consider the pace - don't cluster too many substeps, and don't pad with unnecessary ones.

- Bad: Step 1 with 10 sub-bullets covering unrelated setup tasks
- Good: Step 1 focuses on one logical action, Step 2 builds on it naturally

## Structure

```markdown
# How to [Accomplish Specific Goal]

One sentence: what this guide helps you do and when you'd need it.

## Prerequisites

- What the user must have set up or know before starting
- Link to tutorial if they need foundational knowledge first

## Steps

### 1. [First Action]

[Instruction]

> If [condition], do [alternative] instead.

### 2. [Next Action]

[Instruction]

[Expected result or how to verify success]

### 3. [Final Action]

[Instruction]

## Verification

How to confirm the goal was achieved.

## Troubleshooting

Common problems and their solutions (2-3 most frequent issues).

## Related

- Links to reference docs for options mentioned
- Links to other how-to guides for related tasks
```

## Language Patterns

Use conditional imperatives to handle real-world variation:

- "If you want X, do Y. To achieve W, do Z."
- "For production environments, add the `--secure` flag."
- "If you see error X, check Y before continuing."
- "Refer to the configuration reference for a full list of options."

## Anti-Patterns

| Don't                                  | Why                                                | Instead                               |
| -------------------------------------- | -------------------------------------------------- | ------------------------------------- |
| Teach concepts or explain why          | User is here to get something done, not learn      | Link to tutorials or explanation docs |
| Use a vague title                      | User can't find the guide or know if it's relevant | Be specific: "How to X when Y"        |
| Provide a single rigid sequence        | Real-world problems have branches and conditions   | Use conditional steps                 |
| Include complete reference information | Buries the actionable steps in noise               | Link to reference docs                |
| Assume only one starting point         | Users arrive with different existing setups        | Acknowledge common variations         |
| Mix multiple goals in one guide        | Dilutes focus, harder to find and follow           | Split into separate guides            |
| Over-explain each step                 | Slows down a competent user                        | Keep instructions direct              |
