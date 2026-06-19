---
name: git-conventions
description: "Use when creating branches, naming branches, preparing commits, writing commit messages, or applying Conventional Commits in this dotfiles repo. Covers branch naming, commit message format, scopes, staging safety, and verification before commit."
---

# Git Conventions

Use these rules when creating branches or preparing commits in this dotfiles repo.

## Branch Names

Use:

```text
<type>/<scope>-<short-kebab-summary>
```

Examples:

```text
feat/pi-plan-prompt
fix/opencode-skill-yaml
chore/pi-extensions
docs/pi-readme
refactor/nvim-lsp-config
```

Rules:

- Use lowercase kebab-case.
- Keep branch names short and descriptive.
- Prefer the top-level tool/config directory as `scope`.
- Do not include secrets, usernames, or temporary local details.

## Commit Messages

Use Conventional Commits:

```text
<type>(<scope>): <summary>
```

Examples:

```text
feat(pi): add plan prompt template
fix(pi): quote skill descriptions for yaml parsing
chore(pi): configure coding agent extensions
docs(pi): document plan mode workflow
refactor(opencode): simplify provider config
```

## Types

Use the smallest accurate type:

| Type | Use for |
| --- | --- |
| `feat` | New user-visible capability, prompt, skill, plugin, config feature |
| `fix` | Bug fix, broken config fix, parsing/loading issue |
| `docs` | Documentation-only changes |
| `chore` | Maintenance, setup, package/config housekeeping |
| `refactor` | Behavior-preserving restructuring |
| `test` | Tests-only changes |
| `style` | Formatting-only changes |
| `perf` | Performance improvements |
| `ci` | CI/build automation |
| `revert` | Revert a previous commit |

For this repo, prefer `feat`, `fix`, `chore`, `docs`, and `refactor` unless another type is clearly better.

## Scopes

Prefer scopes that match top-level tools or shared areas:

```text
pi
opencode
nvim
ghostty
kitty
zed
ideavim
powershell
github-copilot
docs
dotfiles
```

If a change spans multiple unrelated areas, use `dotfiles` or omit the scope only when no single scope fits.

## Summary Rules

- Use imperative mood: `add`, `fix`, `document`, `configure`.
- Start lowercase after the colon.
- No trailing period.
- Keep under about 72 characters when practical.
- Mention what changed, not how hard it was.

Good:

```text
feat(pi): add git convention skill
fix(pi): keep ponytail behind workflow gates
docs(opencode): document skill setup
```

Avoid:

```text
updated stuff
fixes
feat: big changes
chore(pi): made some improvements.
```

## Staging Safety

Before committing:

1. Inspect `git status`.
2. Inspect `git diff` for intended files.
3. Stage only files related to the commit.
4. Do not stage secrets, auth files, sessions, logs, caches, or runtime package stores.
5. Run relevant verification when there is a verifiable outcome.
6. Write the commit message only after verifying the final staged diff.

Never commit:

```text
~/.pi/agent/auth.json
~/.pi/agent/sessions/
~/.pi/agent/npm/node_modules/
*.log
```

## Choosing a Commit Message

Use this decision flow:

1. Did behavior or available capability change? Use `feat`.
2. Did broken behavior/config get corrected? Use `fix`.
3. Is it documentation only? Use `docs`.
4. Is it setup/package/config maintenance? Use `chore`.
5. Is it restructuring without behavior change? Use `refactor`.

When uncertain, choose the least surprising type based on the user-visible result.

## Multi-Commit Guidance

Split commits when changes are independently understandable:

- Config change separate from docs-only cleanup.
- Pi changes separate from OpenCode changes.
- Mechanical formatting separate from behavior changes.

Keep one commit when the files form one logical change and verification applies to the whole change.
