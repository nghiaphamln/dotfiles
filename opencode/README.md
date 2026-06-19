# OpenCode Configuration

This directory contains the OpenCode configuration symlinked into `~/.config/opencode` from this dotfiles repo.

## Current Layout

```text
dotfiles/
└── opencode/
    ├── AGENTS.md
    ├── assets/
    │   ├── opencode-logo-dark.png
    │   ├── opencode-logo-dark.svg
    │   ├── opencode-logo-light.png
    │   └── opencode-logo-light.svg
    ├── commands/
    │   ├── commit-msg.md
    │   ├── create-pull-request.md
    │   ├── plan.md
    │   └── review.md
    ├── opencode.jsonc
    ├── README.md
    ├── tui.jsonc
    ├── plugins/
    │   └── rtk.ts
    └── skills/
        ├── brainstorming/SKILL.md
        ├── code-review/SKILL.md
        ├── context-discovery/SKILL.md
        ├── git-conventions/SKILL.md
        ├── karpathy-guidelines/SKILL.md
        ├── security-and-secrets/SKILL.md
        ├── systematic-debugging/SKILL.md
        ├── verification-before-completion/SKILL.md
        └── test-driven-development/SKILL.md
```

Runtime layout (after symlink):

```text
~/.config/opencode -> dotfiles/opencode
```

## Setup

```bash
DOTFILES_DIR="/path/to/your/dotfiles"
ln -sfn "$DOTFILES_DIR/opencode" ~/.config/opencode
```

## What This Configures

### Providers

Two OpenAI-compatible providers are configured:

| Provider | Env vars | Notes |
|---|---|---|
| `aicheap` | `AI_CHEAP_BASE_URL`, `AI_CHEAP_API_KEY` | Default provider, 500K context for `gpt-5.4` and `gpt-5.5` |
| `llm` | `LLM_BASE_URL`, `LLM_API_KEY` | Secondary provider, `gpt-5.5`, 272K context |

Default models:
- `model`: `aicheap/gpt-5.5`
- `small_model`: `aicheap/gpt-5.4-mini`

`aicheap/gpt-5.4` and `aicheap/gpt-5.5` default to high reasoning options. `aicheap/gpt-5.4-mini` defaults to low reasoning for lightweight `small_model` tasks. Each model also supports reasoning variants (`none`, `low`, `medium`, `high`, `xhigh`) configurable per-session.

### Workflow

Recommended daily flow:

1. Use Build mode directly for small mechanical changes.
2. Use Plan mode before non-trivial features, refactors, unclear tasks, or reviews.
3. Use `systematic-debugging` for bugs and unexpected failures before fixing.
4. Use `verification-before-completion` before claiming work is done.
5. Use `git-conventions` before branch creation, staging, commits, or commit messages.

OpenCode also loads `AGENTS.md` globally for personal operating rules and `skills/iron-laws.md` eagerly for methodology gates.

### Permissions

This config relies on OpenCode's default agents and permissions. Personal guardrails live in `AGENTS.md` and the methodology skills instead of custom `permission` or `agent` overrides in `opencode.jsonc`.

File watching ignores noisy generated folders like `node_modules`, `.git`, `dist`, `build`, and `.cache`.

### Commands

Custom workflow commands live in `commands/`:

| Command | Agent | Purpose |
|---|---|---|
| `/plan <task>` | `plan` | Analyze context and produce an implementation plan without edits |
| `/review [context]` | `plan` | Review current changes without edits |
| `/commit-msg [context]` | `plan` | Suggest Conventional Commit messages from current changes |
| `/create-pull-request [context]` | `plan` | Inspect the current branch and draft a PR; creates it with `gh` for GitHub after explicit confirmation, otherwise returns title and description |

### TUI

`tui.jsonc` enables native OpenCode attention notifications and sounds for done/question/permission/error events. This replaces the removed custom notification plugin.

### Environment Variables

```bash
# aicheap provider
export AI_CHEAP_BASE_URL="..."
export AI_CHEAP_API_KEY="..."

# llm provider
export LLM_BASE_URL="..."
export LLM_API_KEY="..."
```

Recommended location: `~/.zshenv`. OpenCode resolves these via `{env:VARIABLE_NAME}` syntax.

### Plugins

OpenCode auto-loads local plugins from `~/.config/opencode/plugins/`. This repo manages the whole `~/.config/opencode` directory via symlink.

| Plugin | Purpose | Requirement |
|---|---|---|
| `rtk.ts` | Rewrites shell commands through `rtk rewrite` so verbose outputs are token-optimized before they reach the model | `rtk` in PATH |

Install RTK separately, then restart OpenCode:

```bash
brew install rtk
rtk init --show
```

The checked-in plugin was seeded from the official file installed by `rtk init -g --opencode`; keeping it in dotfiles makes the OpenCode setup reproducible.

The RTK plugin only uses type imports and has no checked-in local package dependencies.

### Skills

Skills use OpenCode's [native skill system](https://opencode.ai/docs/skills/). Each skill lives in `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`). OpenCode auto-discovers them from `~/.config/opencode/skills/` (symlinked from this dotfiles repo) and exposes them to agents via the `skill` tool — the agent invokes `skill({ name: "..." })` on demand to load the full content.

In addition, `skills/iron-laws.md` is loaded eagerly via the `instructions` array in `opencode.jsonc`. It is a condensed reminder of the always-on methodology rules and points the agent to invoke the relevant skill for full guidance.

| Skill | Purpose | Source |
|---|---|---|
| `brainstorming` | Design-first workflow — explore intent, propose approaches, get user approval before any code | local |
| `code-review` | Findings-first review workflow focused on bugs, regressions, missing tests, and security risks | local |
| `context-discovery` | Inspect project rules, patterns, dependencies, and verification commands before changing code | local |
| `git-conventions` | Branch naming, Conventional Commits, scopes, staging safety, and verification before commit | local |
| `karpathy-guidelines` | Think first, keep changes simple and surgical, surface assumptions, and define verifiable success criteria | local, adapted from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) |
| `security-and-secrets` | Secret handling, auth changes, injection risks, and safe logging/review checks | local |
| `systematic-debugging` | Root cause investigation before any fix attempt. Hard gate: no fixes without understanding | local |
| `verification-before-completion` | Evidence before claims — run verification commands before declaring anything done | local |
| `test-driven-development` | Write failing test first, watch it fail, then implement minimal code to pass | local |

The core methodology skills are adapted from [obra/superpowers](https://github.com/obra/superpowers) with Claude Code-specific mechanics removed.

## Verification

```bash
# Check symlinks
ls -la ~/.config/opencode

# Check commands are reachable
ls ~/.config/opencode/commands/

# Check plugins are reachable
ls ~/.config/opencode/plugins/

# Check skills are reachable
ls ~/.config/opencode/skills/

# Check RTK rewrite behavior
rtk rewrite "git status"
```
