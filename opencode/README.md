# OpenCode V2 Configuration

This directory contains native OpenCode V2 configuration symlinked into `~/.config/opencode` from this dotfiles repo. Do not use these files with V1.

## Current Layout

```text
dotfiles/
└── opencode/
    ├── opencode.jsonc  # Providers, models, permissions, and compaction
    ├── cli.json        # Global terminal client settings
    ├── README.md
    └── skills/
        └── karpathy-guidelines/SKILL.md
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

Providers use V2's native `package`, `settings`, and `capabilities` fields:

- `aicheap`: `@opencode/ai/providers/openai`, using `AI_CHEAP_BASE_URL` and `AI_CHEAP_API_KEY`. The three GPT models are capped locally at an 872,000-token context window, with a 744,000-token input budget and 128,000-token output limit. This intentionally stays below the published 1,050,000-token context window.
- `antigravity`: `@opencode/ai/providers/google`, using `LLM_BASE_URL` with `/v1beta` appended and `LLM_API_KEY`. Its existing Gemini and Claude model IDs are preserved; the Google runtime is intentional for this gateway's API, including its Claude aliases.

| Model | Default reasoning | Input | Cached input | Cache writes | Output |
|---|---|---|---|---|---|
| `gpt-6.1-sol` | high | $2 | $0.10 | $2.50 | $10 |
| `gpt-6-astra` | max | $10 | $1 | $12.50 | $50 |
| `gpt-6-luna` | low | $0.10 | $0.01 | $0.125 | $0.50 |

Prices are OpenAI's published Standard rates in USD per 1M tokens for requests with at most 272,000 input tokens, checked on 2026-10-17. Each model also configures the published long-context tier for requests above 272,000 input tokens: 2x input/cache rates and 1.5x output rates for the full request. These are OpenCode display estimates; actual billing comes from the gateway. No Fast, Ultrafast, Batch, Flex, or regional-processing price adjustments are configured. Antigravity has no explicit price overrides.

Sources: [OpenAI pricing](https://developers.openai.com/api/docs/pricing), [GPT-6.1 Sol](https://developers.openai.com/api/docs/models/gpt-6.1-sol), [GPT-6 Astra](https://developers.openai.com/api/docs/models/gpt-6-astra), and [GPT-6 Luna](https://developers.openai.com/api/docs/models/gpt-6-luna).

Default models:
- `model`: `aicheap/gpt-6.1-sol`, with `settings.reasoningEffort: "high"`
- `agents.title.model`: `aicheap/gpt-6-luna` (the V2 replacement for `small_model`)

Existing sessions retain their selected model; changing the configured default does not override them.

### Reasoning Effort

Each GPT model's `settings` sets its default effort. Sol and Astra support `low`, `medium`, `high`, `xhigh`, and `max`. Luna additionally supports `none`, included explicitly in its effort list.

The effort levels are declared explicitly in `capabilities.reasoning.effort`, allowing V2 to generate the variants. Astra uses `max` by default; Luna uses `low` and Sol uses `high`. GPT temperature controls are explicitly disabled with `capabilities.temperature: false`. The OpenAI runtime uses the Responses API for reasoning-enabled tool calls, as required by Sol and Luna.

Select a level with `/models`, or use a V2 model reference with `#variant`:

```bash
opencode run --model 'aicheap/gpt-6.1-sol#high' "..."
```

Only the published levels above are exposed; V2 rejects unknown variants. Antigravity's model aliases rely on the gateway's reasoning defaults and intentionally expose no effort variants (`supported: true` without effort or budget controls). Legacy `variants.<name>.disabled` entries are not used.

### Environment Variables

```bash
export AI_CHEAP_BASE_URL="..."
export AI_CHEAP_API_KEY="..."
export LLM_BASE_URL="..."
export LLM_API_KEY="..."
```

Recommended location: `~/.zshenv`. OpenCode resolves these via `{env:VARIABLE_NAME}` syntax. Keep secrets outside this repo. The background service must have these variables in its environment; changing them in a terminal does not update an already-running service.

### Skills

Skills use OpenCode's [native skill system](https://opencode.ai/v2/docs/skills/). Each skill lives in `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`). OpenCode auto-discovers them and exposes them to agents via the `skill` tool, which loads the full content on demand based on the frontmatter `description`.

| Skill | Purpose | Source |
|---|---|---|
| `karpathy-guidelines` | Simple, surgical, goal-driven engineering work | verbatim from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) (MIT) |

The file is kept byte-identical to upstream so it can be re-synced with:

```bash
curl -s https://raw.githubusercontent.com/multica-ai/andrej-karpathy-skills/main/skills/karpathy-guidelines/SKILL.md \
  -o skills/karpathy-guidelines/SKILL.md
```

There is no global `AGENTS.md` and no file-based custom commands. Skill routing is left to the agent's own judgment via the `skill` tool; Ponytail and Aseprite AI Artist also register their bundled commands and skills through plugins. Ponytail injects its active rules automatically. Project-local `AGENTS.md` files still apply. V2 does not currently discover the old `CLAUDE.md` fallback; put applicable project guidance in `AGENTS.md` instead.

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

### Aseprite AI Artist

[`with-pebbly/aseprite-ai-artist`](https://github.com/with-pebbly/aseprite-ai-artist) is installed globally as two pieces:

- The V2 OpenCode plugin, pinned to commit `5894b12cead839789077b279369409f868451ffc` (0.8.2), registers fourteen `/aseprite:*` commands and skills, plus connection-status and preview-reminder hooks.
- The local MCP server runs `npx -y @pebbly/aseprite-ai-artist@0.8.2 serve`. `ASEPRITE_AI_PROMPTS=0` avoids duplicate workflows because the plugin already registers them.

Both entries live in `opencode.jsonc`, alongside Ponytail and the existing providers. The Aseprite Lua extension is installed outside this repo in Aseprite's config directory. This machine already had extension 0.8.2 connected to Aseprite 1.3.17.2, so installation did not replace it or restart the application.

For a new machine, install Aseprite 1.3+ and Node 22.6+, open Aseprite once, then install the extension:

```bash
npx -y @pebbly/aseprite-ai-artist@0.8.2 install-extension
```

Restart Aseprite after installing its extension. The tracked config supplies the OpenCode plugin and MCP server; to add them manually instead:

```bash
opencode plugin add 'github:with-pebbly/aseprite-ai-artist#5894b12cead839789077b279369409f868451ffc::path:opencode'
opencode mcp add aseprite-ai-artist --global --env ASEPRITE_AI_PROMPTS=0 -- npx -y @pebbly/aseprite-ai-artist@0.8.2 serve
```

Start with `/aseprite:studio <request>`, or choose `/aseprite:draw`, `/aseprite:animate`, `/aseprite:review`, or `/aseprite:export` for one stage. The server exposes eighteen MCP tools and the bundled craft knowledge as resources. No art is published automatically; `/aseprite:submit` is an explicit gallery-submission workflow.

This setup uses the live Aseprite window, not headless mode, and does not enable arbitrary Lua execution. Drawing tools can change the active document; saving and exporting can write anywhere the user account can. The bridge listens only on `127.0.0.1` (ports 9931/9932), but any local process can control Aseprite through it while it runs. Use it only on a trusted machine.

Check the connection without drawing:

```bash
opencode mcp list
npx -y @pebbly/aseprite-ai-artist@0.8.2 doctor
```

The MCP `preflight` tool must report `ready: true` before drawing. Installation was checked with `preflight` only; no pixels, layers, frames, or files in the open drawing were changed.

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

# Confirm the plugins and Aseprite MCP connection
opencode plugin list
opencode mcp list

# Inspect config loading without printing resolved credentials
opencode api get /api/config >/dev/null
```

In the TUI, use `/models` to confirm the three GPT models offer `low`, `medium`, `high`, `xhigh`, and `max`, Luna additionally offers `none`, and Antigravity models offer no effort variants. New sessions default to GPT-6.1 Sol with high reasoning; the title agent uses GPT-6 Luna. Use **Open settings** from `Ctrl+P` to check terminal preferences.

Server configuration and valid CLI edits normally reload automatically; in-flight model requests keep their original settings. If a client does not refresh its appearance, close and reopen it. If the shared service is unhealthy, use `opencode service restart` and recheck its status; do not delete service files or the database.

References: [V2 migration](https://opencode.ai/v2/docs/migrate-v1), [models](https://opencode.ai/v2/docs/models), [CLI settings](https://opencode.ai/v2/docs/cli/config), and [troubleshooting](https://opencode.ai/v2/docs/troubleshooting).
