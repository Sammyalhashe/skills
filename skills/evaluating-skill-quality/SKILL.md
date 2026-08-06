---
name: evaluating-skill-quality
description: Evaluates agent skills against Anthropic's best practices. Use when asked to review, evaluate, assess, or audit a skill for quality. Analyzes SKILL.md structure, naming conventions, description quality, content organization, and identifies anti-patterns. Produces actionable improvement recommendations.
version: 1.0.0
last_updated: 2026-02-02
upstream: https://github.com/gotalab/skillport/tree/main/.skills/experimental/skill-evaluator
license: https://github.com/gotalab/skillport/blob/main/LICENSE
---

# Skill Evaluator (WIP)

Evaluates skills against Anthropic's official best practices for agent skill authoring. Produces structured evaluation reports with scores and actionable recommendations.

## Quick Start

1. Read the skill's SKILL.md and understand its purpose
2. Run automated validation: `scripts/validate_skill.py <skill-path>`
3. Perform manual evaluation against criteria below
4. Generate evaluation report with scores and recommendations

## Evaluation Workflow

### Pre-Evaluation: Security Gate

Before scoring, verify the skill has been security audited:

- [ ] `skill-auditor` has been run on this skill
- [ ] No CRITICAL or HIGH security findings
- [ ] Any MEDIUM findings have been reviewed and accepted

> ⚠️ **If security audit not completed**: Score cannot exceed 3.0 (Acceptable) regardless of other criteria.
> **If CRITICAL findings exist**: Skill is not ready for evaluation. Address security issues first.

### Step 1: Automated Validation

Run the validation script first:

```bash
scripts/validate_skill.py <path/to/skill>
```

This checks:
- SKILL.md exists with valid YAML frontmatter
- Name follows conventions (lowercase, hyphens, max 64 chars)
- Description is present and under 1024 chars
- Body is under 500 lines
- File references are one-level deep

### Step 2: Manual Evaluation

- [references/manual-evaluation.md](references/manual-evaluation.md) - Complete the manual evaluation

### Step 3: Generate Report

Use this template:

```markdown
# Skill Evaluation Report: [skill-name]

## Summary
- **Overall Score**: X.X/5.0
- **Recommendation**: [Ready for publication / Needs minor improvements / Needs major revision]

## Dimension Scores
| Dimension | Score | Weight | Weighted |
|-----------|-------|--------|----------|
| Naming | X/5 | 10% | X.XX |
| Description | X/5 | 20% | X.XX |
| Content Quality | X/5 | 30% | X.XX |
| Structure | X/5 | 25% | X.XX |
| Degrees of Freedom | X/5 | 10% | X.XX |
| Anti-Patterns | X/5 | 5% | X.XX |
| **Total** | | 100% | **X.XX** |

## Strengths
- [List 2-3 things done well]

## Areas for Improvement
- [List specific issues with actionable fixes]

## Anti-Patterns Found
- [List any anti-patterns detected]

## Recommendations
1. [Priority 1 fix]
2. [Priority 2 fix]
3. [Priority 3 fix]

## Pre-Publication Checklist
- [ ] Description is specific with activation triggers
- [ ] SKILL.md under 500 lines
- [ ] One-level-deep file references
- [ ] Forward slashes in all paths
- [ ] No time-sensitive information
- [ ] Consistent terminology
- [ ] Concrete examples provided
- [ ] Scripts handle errors explicitly
- [ ] All configuration values justified
- [ ] Required packages listed
- [ ] Tested with Haiku, Sonnet, Opus
```

## Score Interpretation

| Score Range | Rating | Action |
|-------------|--------|--------|
| 4.5 - 5.0 | Excellent | Ready for publication |
| 4.0 - 4.4 | Good | Minor improvements recommended |
| 3.0 - 3.9 | Acceptable | Several improvements needed |
| 2.0 - 2.9 | Needs Work | Major revision required |
| 1.0 - 1.9 | Poor | Fundamental redesign needed |

## References

- [references/evaluation-criteria.md](references/evaluation-criteria.md) - Detailed evaluation criteria with examples
- [references/scoring-rubric.md](references/scoring-rubric.md) - Complete scoring rubric and edge cases

## Examples

See [evaluations/](evaluations/) for example evaluation scenarios.
