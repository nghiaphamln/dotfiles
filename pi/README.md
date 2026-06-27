# Pi Coding Agent Configuration

This directory contains global Pi coding agent configuration symlinked into `~/.pi/agent` from this dotfiles repo.

## Current Layout

```text
dotfiles/
└── pi/
    └── agent/
        ├── AGENTS.md
        ├── APPEND_SYSTEM.md
        ├── models.json
        ├── prompts/
        │   └── plan.md
        ├── settings.json
        └── skills/
            ├── brainstorming/SKILL.md
            ├── git-conventions/SKILL.md
            ├── systematic-debugging/SKILL.md
            ├── test-driven-development/SKILL.md
            └── verification-before-completion/SKILL.md
```

Runtime layout after symlinks:

```text
~/.pi/agent/
├── AGENTS.md          -> dotfiles/pi/agent/AGENTS.md
├── APPEND_SYSTEM.md   -> dotfiles/pi/agent/APPEND_SYSTEM.md
├── models.json        -> dotfiles/pi/agent/models.json
├── prompts/           -> dotfiles/pi/agent/prompts/
├── settings.json      -> dotfiles/pi/agent/settings.json
└── skills/            -> dotfiles/pi/agent/skills/
```

Do not symlink the whole `~/.pi/agent` directory. Keep `auth.json`, sessions, logs, and runtime files local.

## Setup

```bash
DOTFILES_DIR="/path/to/your/dotfiles"
mkdir -p ~/.pi/agent

ln -sf "$DOTFILES_DIR/pi/agent/settings.json" ~/.pi/agent/settings.json
ln -sf "$DOTFILES_DIR/pi/agent/models.json" ~/.pi/agent/models.json
ln -sf "$DOTFILES_DIR/pi/agent/APPEND_SYSTEM.md" ~/.pi/agent/APPEND_SYSTEM.md
ln -sf "$DOTFILES_DIR/pi/agent/AGENTS.md" ~/.pi/agent/AGENTS.md
ln -sfn "$DOTFILES_DIR/pi/agent/skills" ~/.pi/agent/skills
ln -sfn "$DOTFILES_DIR/pi/agent/prompts" ~/.pi/agent/prompts
```

## What This Configures

- Default provider/model: `openai-codex/gpt-5.4`.
- Model cycling: `Ctrl+P` cycles through `gpt-5.5`, `gpt-5.4`, and `gpt-5.4-mini`.
- Thinking level: `high`.
- Model metadata override: `gpt-5.4` and `gpt-5.5` use 500K context; `gpt-5.4-mini` uses 400K context; all use 128K max output tokens.
- UI/privacy: quiet startup, collapsed changelog, install telemetry disabled, and project trust defaults to `ask`.
- Package-managed extensions: RTK output optimization, notifications, Ponytail, structured user questions, rewind/checkpoints, working-line status, tool display rendering, read maps for large files, cache optimization, and smart web fetching.
- Smart fetch: `pi-smart-fetch` registers `web_fetch` and `batch_web_fetch` with conservative defaults: 50K chars, 15s timeout, and batch concurrency 4.
- Cache optimization: `pi-cache-optimizer` improves provider-side prompt/cache behavior and exposes `/cache-optimizer` diagnostics.
- Compaction: enabled, with larger reserve and recent-token budgets than Pi defaults.
- Retry: enabled with three agent-level retries and 2s base backoff.
- Global appended system prompt: Karpathy-style guidelines for simplicity, surgical changes, and verification.
- Global context file: `AGENTS.md`.
- Global skills: local Pi-specific copies of methodology and git convention skills, registered as `/skill:name` commands.
- Prompt template: `/plan <task>` analyzes a task and stops before implementation.

## Plan Mode

Soft plan mode inside Pi:

```text
/plan add oauth support
```

Hard read-only plan mode via shell alias:

```bash
alias piplan='pi --tools read,grep,find,ls'
```

Use `piplan` when you want tool-level protection against edits, writes, and mutating shell commands.

## Verification

```bash
ls -la ~/.pi/agent
pi --list-models gpt-5.4
pi --list-models gpt-5.5
pi --no-session -p "Say ok"
```
