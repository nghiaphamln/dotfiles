# OpenCode Configuration

This directory contains the OpenCode configuration symlinked into `~/.config/opencode` from this dotfiles repo.

## Current Layout

```text
dotfiles/
└── opencode/
    ├── assets/
    │   ├── opencode-logo-dark.png
    │   ├── opencode-logo-dark.svg
    │   ├── opencode-logo-light.png
    │   └── opencode-logo-light.svg
    ├── opencode.jsonc
    ├── README.md
    ├── tui.jsonc
    ├── plugins/
    │   └── rtk.ts
    └── skills/
        └── karpathy-guidelines/SKILL.md
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

### Provider

One OpenAI-compatible provider, `aicheap`, using `AI_CHEAP_BASE_URL` and `AI_CHEAP_API_KEY`. All three GPT-5.6 models use the gateway's 372K context limit.

| Model | Default reasoning | Input / output cost |
|---|---|---|
| `gpt-5.6-sol` | high | 5 / 30 |
| `gpt-5.6-terra` | max | 2 / 12 |
| `gpt-5.6-luna` | low | 0.2 / 1.2 |

Costs are OpenAI's official standard short-context list rates per 1M tokens, used by OpenCode for display estimates only — actual billing comes from the gateway. OpenAI also has a long-context tier at roughly double the input rate, but the token threshold that triggers it is not documented for GPT-5.6, so it is not modeled here.

Default models:
- `model`: `aicheap/gpt-5.6-terra`
- `small_model`: `aicheap/gpt-5.6-luna`

### Reasoning Effort

Each model's `options` sets its default effort. The AI Cheap Bifrost gateway supports the same verified levels for Luna, Terra, and Sol: `low`, `medium`, `high`, `xhigh`, and `max`.

OpenCode already provides `low`, `medium`, `high`, and `xhigh` as built-in OpenAI variants. This config adds the missing gateway-supported `max` variant to all three models. Terra uses `max` by default; Luna and Sol keep their current defaults.

Select a level in the model picker in the TUI, cycle model variants with the `variant_cycle` keybind, or use the CLI:

```bash
opencode run --model aicheap/gpt-5.6-terra --variant max "..."
```

The gateway rejects `ultra` with HTTP 400. Although `none` and `minimal` return HTTP 200, they are omitted from its explicit allowlist and did not report reasoning-token usage in a minimal probe, so they are intentionally not exposed as variants. OpenCode does not validate a variant name locally; use only the levels above.

### Environment Variables

```bash
export AI_CHEAP_BASE_URL="..."
export AI_CHEAP_API_KEY="..."
```

Recommended location: `~/.zshenv`. OpenCode resolves these via `{env:VARIABLE_NAME}` syntax.

### Skills

Skills use OpenCode's [native skill system](https://opencode.ai/docs/skills/). Each skill lives in `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`). OpenCode auto-discovers them and exposes them to agents via the `skill` tool, which loads the full content on demand based on the frontmatter `description`.

| Skill | Purpose | Source |
|---|---|---|
| `karpathy-guidelines` | Simple, surgical, goal-driven engineering work | verbatim from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT) |

The file is kept byte-identical to upstream so it can be re-synced with:

```bash
curl -s https://raw.githubusercontent.com/multica-ai/andrej-karpathy-skills/main/skills/karpathy-guidelines/SKILL.md \
  -o skills/karpathy-guidelines/SKILL.md
```

There is no global `AGENTS.md` and no custom commands. Skill routing is left to the agent's own judgment via the `skill` tool; project-local `AGENTS.md` or `CLAUDE.md` files still apply as usual, and OpenCode's built-in commands are unchanged.

### Permissions

This config uses OpenCode's default agent permissions without overrides. File watching ignores noisy generated folders like `node_modules`, `.git`, `dist`, `build`, and `.cache`.

Built-in LSP and formatter support are enabled with default OpenCode behavior.

### TUI

`tui.jsonc` uses the `system` theme, stacked diff rendering, mouse support, and native OpenCode attention notifications/sounds for done/question/permission/error events.

### Plugins

OpenCode auto-loads local plugins from `~/.config/opencode/plugins/`.

| Plugin | Purpose | Requirement |
|---|---|---|
| `rtk.ts` | Rewrites shell commands through `rtk rewrite` so verbose outputs are token-optimized before they reach the model | `rtk` in PATH |

Install RTK separately, then restart OpenCode:

```bash
brew install rtk
rtk init --show
```

The checked-in plugin was seeded from the official file installed by `rtk init -g --opencode`. It only uses type imports, so no local package dependencies are checked in.

## Verification

```bash
# Check symlink
ls -la ~/.config/opencode

# Check plugins and skills are reachable
ls ~/.config/opencode/plugins/ ~/.config/opencode/skills/

# Check RTK rewrite behavior
rtk rewrite "git status"
```
