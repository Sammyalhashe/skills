# Writing Explanation Documentation

Explanation documentation provides **understanding-oriented discussion** that deepens and broadens the reader's grasp of
a subject. It brings clarity, context, and the "why" behind decisions. This is the only documentation type that makes
sense to read away from the product itself.

Explanation documentation answers: **"Why...?"**

## Table of Contents

1. [Core Principles](#core-principles)
1. [Structure](#structure)
1. [What Belongs in Explanation](#what-belongs-in-explanation)
1. [What Does NOT Belong in Explanation](#what-does-not-belong-in-explanation)
1. [Language Patterns](#language-patterns)
1. [Anti-Patterns](#anti-patterns)

## Core Principles

### Talk about the subject, not through it

Explanation circles around a topic rather than walking through it step by step. Think "about" - "About user
authentication," "About the plugin architecture," "About rate limiting." The implicit or explicit "about" in the title
signals this document's purpose.

### Make connections

Weave a web of understanding by connecting the topic to other things - related concepts within the project, broader
industry patterns, historical context. These connections are what transform isolated facts into understanding.

### Provide context

Explain the background: why things are the way they are, what historical decisions led here, what technical constraints
shaped the design. Draw out implications. Mention specific examples that illuminate the general concept.

### Admit opinion and perspective

Unlike reference (which is strictly neutral), explanation can and should consider alternatives, weigh trade-offs, and
acknowledge that reasonable people might approach things differently. "We chose X over Y because Z, though Y has
advantages in situations where..."

### Keep it bounded

Explanation has a tendency to absorb other documentation types. Don't let instruction, step-by-step procedures, or
technical descriptions creep in. If you catch yourself writing steps to follow, that belongs in a how-to guide. If
you're listing all options for a configuration key, that belongs in reference.

## Structure

```markdown
# About [Topic]

Opening paragraph: what this topic is and why it matters to the reader. Establish scope.

## Background

Historical context, prior art, or the problem that led to this design. What existed before, and what changed.

## How [Topic] Works

Conceptual explanation of the mechanism - not a step-by-step procedure, but enough for the reader to build a mental
model. Diagrams are valuable here.

## Design Decisions

Why this approach was chosen. What alternatives were considered. What trade-offs were accepted.

> We chose [approach] because [reasoning]. An alternative would be [other approach], which offers [advantages] but
> requires [trade-offs].

## Relationship to [Related Concept]

How this topic connects to other parts of the system or broader concepts the reader may know.

## Limitations and Trade-offs

Honest assessment of where this approach falls short or what constraints users should be aware of.

## Further Reading

- Links to reference docs for technical details
- Links to how-to guides for practical application
- External resources for deeper study
```

## What Belongs in Explanation

- Why the project uses a particular architecture or technology
- The reasoning behind a configuration model or API design
- How a concept in this project relates to the same concept elsewhere
- Trade-offs that were made and why
- Historical context that helps users understand current behavior
- Mental models for how subsystems interact
- Security model rationale
- Performance characteristics and why they exist

## What Does NOT Belong in Explanation

- Step-by-step instructions (how-to guide)
- Complete listings of options, flags, or endpoints (reference)
- Guided learning exercises (tutorial)
- Troubleshooting procedures (how-to guide)

## Language Patterns

- "The reason for X is because historically, Y..."
- "W is generally better than Z in this context, because..."
- "An X in this system is analogous to a W in [familiar system]. However, they differ in..."
- "Some users prefer W because of Z. This can work well when A, but consider B if..."
- "This design was chosen because... An alternative approach would be..."

## Anti-Patterns

| Don't                                   | Why                                     | Instead                                            |
| --------------------------------------- | --------------------------------------- | -------------------------------------------------- |
| Write steps to follow                   | That's a how-to guide                   | Describe concepts and reasoning                    |
| List all options exhaustively           | That's reference                        | Mention a few illustrative examples                |
| Avoid expressing judgment               | Explanation is where opinion belongs    | Weigh trade-offs openly                            |
| Wander without boundaries               | Explanation can absorb everything       | Define a clear topic scope in the title            |
| Duplicate what reference already states | Redundancy causes drift and confusion   | Link to reference for specifics                    |
| Skip the "why"                          | The whole point of explanation is "why" | Every section should answer or contribute to "why" |
| Write only for experts                  | Understanding benefits everyone         | Provide enough context for intermediate users      |
