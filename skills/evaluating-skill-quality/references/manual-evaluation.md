Evaluate each dimension and assign a score (1-5):

#### A. Naming (Weight: 10%)

| Score | Criteria |
|-------|----------|
| 5 | Gerund form (-ing), clear purpose, memorable |
| 4 | Descriptive, follows conventions |
| 3 | Acceptable but could be clearer |
| 2 | Vague or misleading |
| 1 | Violates naming rules |

**Rules**: Max 64 chars, lowercase + numbers + hyphens only, no reserved words (anthropic, claude), no XML tags.

**Good**: `processing-pdfs`, `analyzing-spreadsheets`, `building-dashboards`
**Bad**: `pdf`, `my-skill`, `ClaudeHelper`, `anthropic-tools`

#### B. Description (Weight: 20%)

| Score | Criteria |
|-------|----------|
| 5 | Clear functionality + specific activation triggers + third person |
| 4 | Good description with some triggers |
| 3 | Adequate but missing triggers or vague |
| 2 | Too brief or unclear purpose |
| 1 | Missing or unhelpful |

**Must include**: What the skill does AND when to use it.
**Good**: "Extracts text from PDFs. Use when working with PDF documents for text extraction, form parsing, or content analysis."
**Bad**: "A skill for PDFs." or "Helps with documents."

#### C. Content Quality (Weight: 30%)

| Score | Criteria |
|-------|----------|
| 5 | Concise, assumes Claude intelligence, actionable instructions |
| 4 | Generally good, minor verbosity |
| 3 | Some unnecessary explanations or redundancy |
| 2 | Overly verbose or confusing |
| 1 | Bloated, explains obvious concepts |

**Ask**: "Does Claude really need this explanation?" Remove anything Claude already knows.

#### D. Structure & Organization (Weight: 25%)

| Score | Criteria |
|-------|----------|
| 5 | Excellent progressive disclosure, clear navigation, optimal length |
| 4 | Good organization, appropriate file splits |
| 3 | Acceptable but could be better organized |
| 2 | Poor organization, missing references, or bloated SKILL.md |
| 1 | No structure, everything dumped in SKILL.md |

**Check**:
- SKILL.md under 500 lines
- References are one-level deep (no nested chains)
- Long reference files (>100 lines) have table of contents
- Uses forward slashes in all paths

#### E. Degrees of Freedom (Weight: 10%)

| Score | Criteria |
|-------|----------|
| 5 | Perfect match: high freedom for flexible tasks, low for fragile operations |
| 4 | Generally appropriate freedom levels |
| 3 | Acceptable but could be better calibrated |
| 2 | Mismatched: too rigid or too loose |
| 1 | Completely wrong freedom level for the task type |

**Guideline**:
- High freedom (text): Multiple valid approaches, context-dependent
- Medium freedom (parameterized): Preferred pattern exists, some variation OK
- Low freedom (specific scripts): Fragile operations, exact sequence required

#### F. Anti-Pattern Check (Weight: 5%)

Deduct points for each anti-pattern found:

- [ ] Too many options without clear recommendation (-1)
- [ ] Time-sensitive information with date conditionals (-1)
- [ ] Inconsistent terminology (-1)
- [ ] Windows-style paths (backslashes) (-1)
- [ ] Deeply nested references (more than one level) (-2)
- [ ] Scripts that punt error handling to Claude (-1)
- [ ] Magic numbers without justification (-1)