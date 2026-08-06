# Writing Tutorials

Tutorials are **learning-oriented lessons** where the user acquires skills through guided practice. The user learns by
doing something meaningful under your guidance toward an achievable goal.

A tutorial answers: **"Can you teach me to...?"**

## Table of Contents

1. [Core Principles](#core-principles)
1. [Structure](#structure)
1. [Anti-Patterns](#anti-patterns)

## Core Principles

### Provide the experience, don't lecture

Trust that learning happens through doing. Your job is to create a carefully designed experience, not to explain
concepts. The user is focused on following directions and getting results - explanation distracts from that.

### Show the destination upfront

Tell the user what they will have built or accomplished by the end. This gives them motivation and a way to gauge
progress. Open with something like: "In this tutorial, you will build a working X that does Y."

### Deliver visible results early and often

Every step should produce something the user can see or verify. Don't front-load setup without payoff. If the first five
steps are configuration with no visible result, restructure so the user sees output sooner.

### Maintain a narrative of the expected

Tell the user what they should see at each step. Provide example output. Flag common errors they might encounter. The
user should never wonder "did that work?" - confirmation should be built into the tutorial.

### Point out what to notice

Prompt the user to observe results: "Notice that the output now includes X" or "You should see Y in the response."
Learning requires reflection, and these prompts create moments of reflection within the flow of doing.

### Use "we" language

"We" affirms the relationship between guide and learner. The user is not alone.

- Don't: "Create a configuration file"
- Do: "Let's create a configuration file"

### Follow a single path

Never present choices, options, or alternatives. Pick one path and guide the user along it. Alternatives belong in
how-to guides. If the tool supports three database backends, pick one for the tutorial.

### Keep it concrete

Stay in the moment of concrete actions and results. Don't generalize. Don't abstract. Lead step by concrete step. The
user will discover general patterns from concrete examples over time.

### Ensure perfect reliability

Every promised result must appear. Every command must work. Every screenshot must match. If the tutorial says "you
should see X" and the user sees Y, the tutorial has failed. Test your tutorials against a clean environment.

## Structure

```markdown
# Tutorial: [What the User Will Build/Accomplish]

One sentence: what the user will have at the end.

## Before You Begin

- Prerequisite 1 (with install link if needed)
- Prerequisite 2

## Step 1: [Action That Produces First Visible Result]

Brief context sentence if needed.

Let's [perform action].

[Expected output or result]

## Step 2: [Next Meaningful Action]

...

## What You've Learned

Brief recap of what the user built and the skills they practiced (2-3 sentences max).

## Next Steps

Links to how-to guides for real-world application of what they learned.
```

## Anti-Patterns

| Don't                                | Why                                                                  | Instead                                 |
| ------------------------------------ | -------------------------------------------------------------------- | --------------------------------------- |
| Explain how things work              | Distracts from doing; user can't absorb theory while following steps | Link to explanation docs                |
| Offer alternatives                   | Creates decision paralysis; user is here to learn, not choose        | Pick one path                           |
| Include optional steps               | Breaks flow; user wonders if they should do them                     | Move to a how-to guide                  |
| Skip showing expected output         | User loses confidence they're on track                               | Show output after every meaningful step |
| Start with theory or background      | User wants to start doing, not reading                               | Jump into the first action quickly      |
| Use "you" imperatives without warmth | Feels like a command manual, not a lesson                            | Use "we" and "let's"                    |
| Cover edge cases                     | Belongs in how-to guides or reference                                | Stay on the happy path                  |
