# OpenCode V2

## Setup

From the dotfiles root, link the OpenCode configuration. If replacing an existing config, move it aside first and preserve its `service.json` in the new config directory. Git ignores that credentials file.

```bash
mkdir -p ~/.config
ln -s "$PWD/opencode" ~/.config/opencode
```

Add your AiCheap gateway URL and API key to `~/.zshenv`.

```bash
export AI_CHEAP_BASE_URL="..."
export AI_CHEAP_API_KEY="..."
```

If the OpenCode background service is already running, restart it from a shell that has loaded the new values.

```bash
source ~/.zshenv && opencode service restart
```

## Configuration

- [`opencode.jsonc`](opencode.jsonc) defines the provider, models, permissions, and compaction.
- [`cli.json`](cli.json) defines terminal preferences, including `tabs.mode: "off"`.

| AiCheap model | Default reasoning |
|---|---|
| `gpt-6.2-sol` | `high` |
| `gpt-6.2-astra` | `max` |
| `gpt-6.1-terra` | `max` |
| `gpt-6-luna` | `low` |

New sessions use Sol by default, and the title agent uses Luna.

Each model has a local context limit of 872,000 tokens, with 744,000 input and 128,000 output. Auto-compaction keeps 15,000 tokens of recent context and uses a 32,768-token buffer.

## Plugins

- **Karpathy Guidelines** loads from the shared package. Mention `@karpathy-guidelines` in a prompt to load the skill. [SKILL.md](../skills/karpathy-guidelines/skill/SKILL.md)
- **Ponytail 5.3.2** applies its active rules automatically. Run `/ponytail` to check the mode or `/ponytail off` to disable it.

## Verify

```bash
opencode service status
opencode plugin list
```

Use `/models` to check the AiCheap models. Use `opencode reload` to apply server config edits and reopen the TUI to refresh terminal preferences.
