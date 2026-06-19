---
name: context-discovery
description: Use before implementing in an unfamiliar or non-trivial codebase. Finds project rules, existing patterns, similar code, commands, tests, and constraints so generated changes match the repository instead of generic defaults.
---

# Context Discovery

Use this before implementing non-trivial work in a codebase where the relevant patterns are not already obvious.

## Goal

Generate code that matches this repository's actual conventions, not generic best practices.

## Discovery Pass

1. Read project guidance first: `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, README, package scripts, Makefile, and relevant docs.
2. Find similar working code for the requested behavior.
3. Identify the local style for names, files, imports, error handling, testing, logging, and dependency usage.
4. Identify verification commands: focused tests, typecheck, lint, build, or runtime checks.
5. Note constraints and risks before editing.

## Minimal Viable Context

Load only context relevant to the current task. Prefer a few high-signal examples over broad codebase dumps.

## Output Before Implementation

State a concise summary:

```text
Patterns found:
- [pattern/source]

Constraints:
- [constraint]

Verification:
- [command or inspection]
```

If no matching pattern exists, say that explicitly and choose the smallest approach consistent with nearby code.
