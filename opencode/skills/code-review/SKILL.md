---
name: code-review
description: Use for code review, PR review, reviewing current changes, or pre-commit review. Focuses on bugs, regressions, security issues, missing tests, and overbroad changes; findings first with file and line references.
---

# Code Review

Review as a senior engineer looking for correctness risks, not as a summarizer.

## Review Priorities

Findings first, ordered by severity:

1. Bugs and behavioral regressions.
2. Security, privacy, and data exposure risks.
3. Missing or weak tests for changed behavior.
4. Overbroad changes, unrelated refactors, and maintainability risks.
5. Documentation or workflow drift when it affects users or future maintainers.

## Process

1. Inspect current changes with read-only commands: status, diff, and relevant files.
2. Compare changed code against existing patterns and requirements.
3. Trace edge cases and failure paths.
4. Check whether verification covers the changed behavior.
5. Avoid proposing style-only feedback unless it affects correctness or maintainability.

## Output Format

Use this structure:

```text
Findings
- [severity] path:line - Issue and impact. Suggested fix if clear.

Open Questions
- [question]

Residual Risk
- [risk or testing gap]
```

If no findings are found, say so explicitly and mention residual risks or verification gaps. Do not bury findings under a summary.
