# OpenCode Configuration

This directory contains the OpenCode configuration symlinked into `~/.config/opencode` from this dotfiles repo.

## Current Layout

```text
dotfiles/
└── opencode/
    ├── opencode.jsonc
    ├── package.json
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
├── package.json    -> dotfiles/opencode/package.json
└── skills/         -> dotfiles/opencode/skills/
```

## Setup

```bash
DOTFILES_DIR="/path/to/your/dotfiles"
mkdir -p ~/.config/opencode
ln -sf "$DOTFILES_DIR/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
ln -sf "$DOTFILES_DIR/opencode/package.json"   ~/.config/opencode/package.json
ln -sf "$DOTFILES_DIR/opencode/skills"         ~/.config/opencode/skills
```

## What This Configures

### Providers

Three custom OpenAI-compatible providers are configured:

| Provider | Env vars | Notes |
|---|---|---|
| `aicheap` | `TENEFIC_BASE_URL`, `TENEFIC_API_KEY` | Default provider, 400K context |
| `tenefic-codex` | `CODEX_BASE_URL`, `CODEX_API_KEY` | 1M context variant |
| `tenefic-llm` | `LLM_BASE_URL`, `LLM_API_KEY` | 1M context, reasoning set to `high` by default |

Default models:
- `model`: `aicheap/gpt-5.4`
- `small_model`: `aicheap/gpt-5.4-mini`

Each model supports reasoning variants (`none`, `low`, `medium`, `high`, `xhigh`) configurable per-session.

### Environment Variables

```bash
# aicheap provider
export TENEFIC_BASE_URL="..."
export TENEFIC_API_KEY="..."

# tenefic-codex provider
export CODEX_BASE_URL="..."
export CODEX_API_KEY="..."

# tenefic-llm provider
export LLM_BASE_URL="..."
export LLM_API_KEY="..."
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
| `defuddle` | Extract clean Markdown from web pages — strip clutter to save tokens during research | symlink → `~/Work/repos/obsidian-skills` |

The four methodology skills are adapted from [obra/superpowers](https://github.com/obra/superpowers) with Claude Code-specific mechanics removed. `defuddle` is a symlink to [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) — promoted to global because it is useful in any project, not just Obsidian vaults.

To set up the `defuddle` symlink target on a fresh machine:

```bash
mkdir -p ~/Work/repos
git clone https://github.com/kepano/obsidian-skills.git ~/Work/repos/obsidian-skills
```

The four other kepano skills (`obsidian-markdown`, `obsidian-bases`, `obsidian-cli`, `json-canvas`) stay project-local in the `nghia-brain` vault since they only matter when working inside an Obsidian vault.

## Verification

```bash
# Check symlinks
ls -la ~/.config/opencode

# Check skills are reachable
ls ~/.config/opencode/skills/
```
