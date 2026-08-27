---
name: resume-reviewer
description: Reviews software-engineering resumes and rewrites weak bullet points into impact-driven ones. Use when the user asks for a resume or CV review, wants help quantifying accomplishments, is tailoring a resume to a specific job description or target role, asks about ATS or applicant tracking systems, or wants feedback on bullet points, a skills section, or resume formatting.
effort: medium
context: inline
---

# Resume Review

## Context

Resume content or target role: **$ARGUMENTS**

If no resume was provided, ask for it before reviewing. If no target role or job
description was provided, ask for one — relevance and ATS keywords cannot be
scored without it. Review what you were given rather than blocking on a missing
extra: if only a role is named, offer the framework; if only a resume is given,
review everything except relevance and say so.

## Procedure

1. Read the resume once end to end before commenting, so the review reflects the
   whole document rather than the first bullet you hit.
2. Score each rubric dimension below, with a one-line justification per score.
3. Rewrite every weak bullet, showing BEFORE and AFTER.
4. Close with the top 3 priorities, ordered by impact.

## CRITICAL: Never invent metrics

The rewrites go on a real resume that the user will be interviewed against. A
fabricated number is a job-losing liability, not a stylistic flourish.

- Never fill in a latency, dollar amount, percentage, or headcount the user did
  not give you.
- When a bullet needs a number the user has not supplied, write a placeholder in
  the AFTER line — `reduced P99 latency from [BEFORE] to [AFTER]` — and ask for
  the real figure.
- The quantification guide below is for helping the user *recall or estimate*
  their own numbers. Estimates must come from them, and approximations should be
  marked as such (`~800ms`).
- If the user cannot quantify something, prefer a specific technical detail over
  an invented metric. Scope, architecture, and constraints still beat "worked on".

## The SWE Resume Framework

```
Format: 1 page (< 5 years), 2 pages max (10+ years)
Order:  Contact → Summary (optional) → Experience → Skills → Education → Projects
Goal:   Pass the 30-second skim AND the detailed read

Recruiter scan order:
1. Current/recent title and company
2. Bullet impact numbers
3. Skills/tech stack
4. Education
```

## Impact-Driven Bullet Points

```
Formula: [Strong verb] + [what you did] + [measurable result]

WEAK bullets (no impact):
- "Worked on the recommendation engine"
- "Fixed bugs in the payment service"
- "Responsible for backend development"

STRONG bullets (verb + result):
- "Redesigned recommendation engine query pattern, reducing P99 latency from 2.3s → 340ms"
- "Identified and fixed a race condition in payment processing that caused $50K/month in duplicate charges"
- "Led migration of monolith to 5 microservices, enabling independent deployments and 40% faster CI runs"
- "Implemented Redis caching layer reducing MongoDB load by 60% and cutting infrastructure cost $3K/month"

Strong verbs by category:
  Built/shipped:    Architected, Built, Designed, Implemented, Shipped, Launched, Developed
  Improved:         Optimized, Reduced, Improved, Accelerated, Streamlined, Automated
  Led:              Led, Mentored, Managed, Coordinated, Drove, Championed
  Analyzed:         Investigated, Debugged, Diagnosed, Identified, Discovered
  Saved:            Reduced, Eliminated, Saved, Cut, Prevented
```

## Quantification Guide

```
Prompt the user for numbers they already know; do not supply them yourself:
  Latency: "reduced average latency from ~800ms to ~200ms"
  Scale:   "service handling 50K+ requests/day"
  Cost:    "reduced infrastructure cost by ~$2K/month"
  Team:    "collaborated with 6-person team"
  Coverage:"increased test coverage from 40% to 85%"
  Time:    "reduced deploy time from 45 minutes to 8 minutes"

Types of metrics to include:
  - Performance: latency, throughput, error rate
  - Scale: users, requests/sec, data volume
  - Business: revenue, cost, conversion rate
  - Developer experience: build time, deploy frequency, time-to-merge
  - Reliability: uptime improvement, incidents reduced
```

## Skills Section

```
Group by category, list most relevant to target role first:

Languages:    JavaScript/TypeScript, Python, Go, Rust
Backend:      Node.js, Express.js, NestJS, GraphQL
Frontend:     React, Next.js, TailwindCSS
Databases:    PostgreSQL, MongoDB, Redis, Elasticsearch
Cloud/DevOps: AWS (ECS, RDS, Lambda), Docker, Kubernetes, Terraform, GitHub Actions
Testing:      Jest, Playwright, Pytest

What NOT to include:
- Microsoft Office, HTML (too basic)
- Outdated tech: jQuery, PHP 5 (if you're targeting modern roles)
- Skills you couldn't be interviewed on (Kubernetes if you've only touched it once)
```

## ATS Optimization

```
Applicant Tracking Systems scan for keyword matches.

1. Mirror language from the job description:
   JD says "Node.js" → use "Node.js" (not "NodeJS" or "node")
   JD says "CI/CD pipelines" → use that exact phrase

2. Use a clean, parseable format:
   - Single column preferred
   - No tables, text boxes, or graphics (ATS can't parse these)
   - Standard section headers: "Experience", "Skills", "Education"
   - PDF format (preserves formatting) or plain text

3. Include all relevant technologies in bullets AND skills section

4. Check ATS score: jobscan.co or similar tools
```

## Output Format

Emit the review in exactly this shape:

```
## Resume Review: [Name / Role]

### Impact (1-5)
Bullet strength, quantification, specificity

### Relevance (1-5)
Match between experience and target role

### Clarity (1-5)
Readability, conciseness, grammar

### Technical Depth (1-5)
Shows engineering skills, architecture decisions, scale

### ATS Readiness (1-5)
Format, keywords, standard headers

---

### Rewrites
For each weak bullet:
BEFORE: [original]
AFTER:  [improved version with impact]

### Top 3 Priorities
1. [Most impactful change]
2. [Second priority]
3. [Third priority]
```

## Agent Guidelines

- Be direct about weak bullets. A review that calls everything "solid" is
  worthless to someone competing for a role.
- Score against the target role, not in the abstract. A 5 for a backend role may
  be a 2 for an ML role.
- Rewrite bullets, do not merely describe what is wrong with them. The AFTER line
  is the deliverable.
- Keep the user's voice and seniority. Do not inflate an IC contribution into
  leadership language the user cannot defend in an interview.
- Flag anything that reads as a red flag to a reviewer — unexplained gaps,
  title inflation, a claim contradicted elsewhere in the resume.
