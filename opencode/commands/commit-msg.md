---
description: Suggest Conventional Commit messages for current changes
agent: plan
---

Use the `git-conventions` skill.

Inspect current changes with read-only git commands only.

Do not stage, commit, push, or edit files.

Task context:
$ARGUMENTS

Return:

1. A concise summary of changed areas.
2. 2-3 candidate Conventional Commit messages.
3. The recommended commit message and why.
4. Any warning if the diff appears to contain unrelated changes that should be split.
