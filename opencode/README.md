# OpenCode Configuration

This directory contains the OpenCode configuration symlinked into `~/.config/opencode` from this dotfiles repo.

## Current Layout

```text
dotfiles/
└── opencode/
    ├── opencode.jsonc
    ├── README.md
    └── skills/
        ├── brainstorming/SKILL.md
        ├── systematic-debugging/SKILL.md
        ├── verification-before-completion/SKILL.md
        └── test-driven-development/SKILL.md
```

Runtime layout (after symlinks):

```text
~/.config/opencode/
├── opencode.jsonc  -> dotfiles/opencode/opencode.jsonc
└── skills/         -> dotfiles/opencode/skills/
```

## Setup

```bash
DOTFILES_DIR="/path/to/your/dotfiles"
mkdir -p ~/.config/opencode
ln -sf "$DOTFILES_DIR/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
ln -sf "$DOTFILES_DIR/opencode/skills"         ~/.config/opencode/skills
```

## What This Configures

### Providers

One custom OpenAI-compatible provider is configured:

| Provider | Env vars | Notes |
|---|---|---|
| `aicheap` | `AI_CHEAP_BASE_URL`, `AI_CHEAP_API_KEY` | Default provider, 400K context |

Default models:
- `model`: `aicheap/gpt-5.4`
- `small_model`: `aicheap/gpt-5.4-mini`

Each model supports reasoning variants (`none`, `low`, `medium`, `high`, `xhigh`) configurable per-session.

### Environment Variables

```bash
# aicheap provider
export AI_CHEAP_BASE_URL="..."
export AI_CHEAP_API_KEY="..."
```

Recommended location: `~/.zshenv`. OpenCode resolves these via `{env:VARIABLE_NAME}` syntax.

### Skills

Skills use OpenCode's [native skill system](https://opencode.ai/docs/skills/). Each skill lives in `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`). OpenCode auto-discovers them from `~/.config/opencode/skills/` (symlinked from this dotfiles repo) and exposes them to agents via the `skill` tool — the agent invokes `skill({ name: "..." })` on demand to load the full content.

In addition, `skills/iron-laws.md` is loaded eagerly via the `instructions` array in `opencode.jsonc`. It is a condensed reminder of the four iron laws and points the agent to invoke the relevant skill for full methodology.

| Skill | Purpose | Source |
|---|---|---|
| `brainstorming` | Design-first workflow — explore intent, propose approaches, get user approval before any code | local |
| `systematic-debugging` | Root cause investigation before any fix attempt. Hard gate: no fixes without understanding | local |
| `verification-before-completion` | Evidence before claims — run verification commands before declaring anything done | local |
| `test-driven-development` | Write failing test first, watch it fail, then implement minimal code to pass | local |

The four methodology skills are adapted from [obra/superpowers](https://github.com/obra/superpowers) with Claude Code-specific mechanics removed.

## Verification

```bash
# Check symlinks
ls -la ~/.config/opencode

# Check skills are reachable
ls ~/.config/opencode/skills/
```
