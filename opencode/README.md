# OpenCode V2 Configuration

This directory contains native OpenCode V2 configuration symlinked into `~/.config/opencode` from this dotfiles repo. Do not use these files with V1.

## Current Layout

```text
dotfiles/
├── opencode/
│   ├── opencode.jsonc  # Providers, models, permissions, and compaction
│   ├── cli.json        # Global terminal client settings
│   ├── README.md
│   └── plugins/karpathy-guidelines.js  # Loads the shared server plugin
└── skills/
    └── karpathy-guidelines/  # OpenCode and Codex plugin package
```

Runtime layout (after symlink):

```text
~/.config/opencode -> dotfiles/opencode
```

OpenCode may create `service.json` in this directory. It contains private service credentials and is Git-ignored. Do not commit it, copy it between machines, or edit it manually. Ponytail's `.ponytail-active` mode flag is also Git-ignored. Installed dependency files are local runtime artifacts, not required configuration.

## Setup

```bash
DOTFILES_DIR="/path/to/your/dotfiles"
ln -sfn "$DOTFILES_DIR/opencode" ~/.config/opencode
```

## What This Configures

### Providers

`aicheap` uses V2's `@opencode/ai/providers/openai` package with `AI_CHEAP_BASE_URL` and `AI_CHEAP_API_KEY`. Each model is capped locally at an 872,000-token context window, with a 744,000-token input budget and a 128,000-token output limit.

| Model | Default reasoning | Input | Cached input | Cache writes | Output |
|---|---|---|---|---|---|
| `gpt-6.2-sol` | high | $2 | $0.10 | $2.50 | $10 |
| `gpt-6.2-astra` | max | $8 | $0.40 | $10 | $40 |
| `gpt-6.1-terra` | max | $1 | $0.05 | $1.25 | $5 |
| `gpt-6-luna` | low | $0.10 | $0.01 | $0.125 | $0.50 |

OpenCode estimates costs using OpenAI's published Standard rates in USD per 1M tokens. Above 272,000 input tokens, the estimates apply 2× input and cache rates and 1.5× output rates to the full request. Actual rates and model availability depend on the gateway.

[OpenAI pricing](https://developers.openai.com/api/docs/pricing) · [GPT-6.2 Sol](https://developers.openai.com/api/docs/models/gpt-6.2-sol) · [GPT-6.2 Astra](https://developers.openai.com/api/docs/models/gpt-6.2-astra) · [GPT-6.1 Terra](https://developers.openai.com/api/docs/models/gpt-6.1-terra)

Default models:
- `model`: `aicheap/gpt-6.2-sol`, with `settings.reasoningEffort: "high"`
- `agents.title.model`: `aicheap/gpt-6-luna` (the V2 replacement for `small_model`)

Existing sessions retain their selected model. Use `/models` to switch a session that used a removed model.

### Reasoning Effort

Each model offers `low`, `medium`, `high`, `xhigh`, and `max`. Terra and Luna also offer `none`.

The effort levels in `capabilities.reasoning.effort` generate the V2 variants. `capabilities.temperature: false` disables temperature controls. The OpenAI runtime uses the Responses API for reasoning-enabled tool calls.

Select a level with `/models`, or use a V2 model reference with `#variant`:

```bash
opencode run --model 'aicheap/gpt-6.2-sol#high' "..."
```

### Environment Variables

```bash
export AI_CHEAP_BASE_URL="..."
export AI_CHEAP_API_KEY="..."
```

Recommended location: `~/.zshenv`. OpenCode resolves these via `{env:VARIABLE_NAME}` syntax. Keep secrets outside this repo. The background service must have these variables in its environment; changing them in a terminal does not update an already-running service.

### Karpathy Guidelines plugin

OpenCode discovers `plugins/karpathy-guidelines.js`, which loads the server plugin from the shared package. The plugin registers the [bundled `SKILL.md`](../skills/karpathy-guidelines/skill/SKILL.md) with OpenCode's [skill API](https://opencode.ai/docs/build/plugins/server#skills). Mention `@karpathy-guidelines` to load it explicitly.

The same directory contains the Codex plugin manifest. See the [root README](../README.md#codex) for the upstream revision and Codex installation commands.

There is no global `AGENTS.md` and no file-based custom commands. Skill routing is left to the agent's own judgment via the `skill` tool; the Ponytail plugin also registers bundled commands and skills and injects its active rules automatically. Project-local `AGENTS.md` files still apply. V2 does not currently discover the old `CLAUDE.md` fallback; put applicable project guidance in `AGENTS.md` instead.

### Ponytail plugin

[`@dietrichgebert/ponytail@5.3.2`](https://github.com/DietrichGebert/ponytail) is configured globally under `plugins` in `opencode.jsonc`. This version supports the OpenCode V2 plugin API and is pinned for reproducible installs. OpenCode installs the package into its own cache; no vendored plugin code or duplicate skill copies are needed here.

Ponytail injects the active ruleset into agent turns and compaction requests, and registers six commands and six skills. It defaults to `full` unless an existing Ponytail environment/config setting or saved mode overrides it. The separate `karpathy-guidelines` skill remains available.

- `/ponytail`: report the active level, or enable the default level when off.
- `/ponytail lite`, `/ponytail full`, `/ponytail ultra`, `/ponytail off`: change the level.
- `/ponytail-review`, `/ponytail-audit`, `/ponytail-debt`, `/ponytail-gain`, `/ponytail-help`: bundled workflows and help.

OpenCode saves the selected level in `~/.config/opencode/.ponytail-active`; this is shared across sessions and projects, not scoped to one chat. The band/dashboard UI advertised upstream is Claude Code-only, not an OpenCode feature.

To reinstall the pinned version or remove it:

```bash
opencode plugin add @dietrichgebert/ponytail@5.3.2
opencode plugin remove @dietrichgebert/ponytail@5.3.2
```

### Permissions

This config keeps the default agent permissions except that access outside the project asks for approval via `external_directory`, restoring V1's behavior. V2 otherwise allows external access by default. This is not a shell sandbox; shell commands still run with the host user's authority.

File watching ignores noisy generated folders like `node_modules`, `.git`, `dist`, `build`, and `.cache`. Filesystem snapshots, manual sharing, and built-in formatting remain enabled.

V2 does not run LSP servers or provide LSP diagnostics. The ineffective `lsp: true` setting has been removed. Use each project's lint, typecheck, compiler, and test commands to validate code changes.

### Compaction

Automatic compaction keeps about 15,000 tokens of recent conversation beside the summary, with a 32,768-token buffer. These use native `compaction.keep.tokens` and `compaction.buffer`. The unsupported V1 `prune` setting is removed. Compaction uses the session's model, not the title model.

### TUI

`cli.json` is the only terminal settings file; the old `tui.jsonc` has been removed. It uses the terminal-derived `system` theme and system appearance, unified diffs (the V2 layout used in place of stacked diffs), word wrapping, mouse support, accelerated scrolling, and attention notifications/sounds at volume 0.35.

The existing V2 preferences are preserved: hidden sidebar, no scrollbar, hidden reasoning, and enabled animations. V1's `prompt.max_width` has no documented V2 setting and is omitted; the V2 client manages prompt layout. The old `attention.enabled` switch is replaced by separate `notifications` and `sound` settings.

## Verification

```bash
# Check symlink
ls -la ~/.config/opencode

# Check skills are reachable
ls ~/.config/opencode/skills/

# Check the V2 client and background service
opencode --version
opencode service status
opencode api get /api/info

# Confirm the installed plugins
opencode plugin list

# Inspect config loading without printing resolved credentials
opencode api get /api/config >/dev/null
```

In the TUI, use `/models` to check the four AiCheap models and their reasoning levels. Use **Open settings** from `Ctrl+P` to check terminal preferences.

Server configuration and valid CLI edits normally reload automatically; in-flight model requests keep their original settings. If a client does not refresh its appearance, close and reopen it. If the shared service is unhealthy, use `opencode service restart` and recheck its status; do not delete service files or the database.

References: [V2 migration](https://opencode.ai/v2/docs/migrate-v1), [models](https://opencode.ai/v2/docs/models), [CLI settings](https://opencode.ai/v2/docs/cli/config), and [troubleshooting](https://opencode.ai/v2/docs/troubleshooting).
