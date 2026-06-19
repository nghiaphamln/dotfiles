---
description: Review current changes without editing files
agent: plan
---

Review the current repository changes with a code-review mindset.

Do not edit files. Do not write code. Do not run mutating commands.

Use `git status`, `git diff`, and relevant read-only inspection to understand the changes.

Focus on:

1. Bugs, behavioral regressions, and security risks.
2. Missing or weak tests and verification gaps.
3. Overbroad or unnecessary changes.
4. Documentation or workflow drift.

Task context:
$ARGUMENTS

Return findings first, ordered by severity with file and line references where possible. If no findings are found, state that and mention residual risks.
