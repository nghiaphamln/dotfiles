# OpenCode Configuration

This directory contains the OpenCode configuration symlinked into `~/.config/opencode` from this dotfiles repo.

The current setup is centered around:
- a global `opencode.jsonc` config stored in dotfiles
- a custom OpenAI-compatible provider named `tenefic`
- the `superpowers` OpenCode plugin installed from git via the `plugin` config key
- an optional `package.json` in the config directory for plugin-related dependencies

## Current Layout

```text
dotfiles/
└── opencode/
    ├── opencode.jsonc
    ├── package.json
    └── README.md
```

Runtime layout:

```text
~/.config/opencode/
├── opencode.jsonc  -> /path/to/your/dotfiles/opencode/opencode.jsonc
└── package.json    -> /path/to/your/dotfiles/opencode/package.json
```

## What This Repo Configures

### Global config

`opencode.jsonc` is the main global OpenCode config for this setup.

OpenCode docs primarily show `~/.config/opencode/opencode.json`, but OpenCode supports both JSON and JSONC. This repo intentionally uses JSONC so comments can be added later if needed.

Current config responsibilities:
- declare the custom provider `tenefic`
- install `superpowers` via the `plugin` array
- define the models exposed through that provider
- attach per-model cost metadata for OpenCode features that read pricing from model definitions
- configure model limits, modalities, and variants
- inject provider credentials through environment variables

Current default model selection:
- `model`: `tenefic/gpt-5.4`
- `small_model`: `tenefic/gpt-5.4-mini`

Current model pricing metadata:
- `cost` is defined per model in `opencode.jsonc`
- pricing values currently follow OpenAI public pricing pages as reference metadata
- these values are useful for estimation and UI features, but may differ from the actual rates billed by `tenefic`

### Provider model setup

The current provider is:

- `tenefic`

It is configured as a custom OpenAI-compatible provider via:
- `options.baseURL`
- `options.headers.Authorization`

Both values are resolved from environment variables.

### Plugins and skills

`opencode.jsonc` installs `superpowers` directly from git:

```json
{
  "plugin": ["superpowers@git+https://github.com/obra/superpowers.git"]
}
```

OpenCode loads the plugin, and the plugin registers its own skills at runtime. No manual `skills/` or `superpowers/` symlinks are required.

### package.json

`package.json` exists in the config directory so OpenCode can resolve plugin-related dependencies if needed.

## Environment Variables

The current config expects:

```bash
export TENEFIC_API_KEY="your-tenefic-key"
export TENEFIC_BASE_URL="your-tenefic-base-url"
```

Recommended place on this machine:

```bash
~/.zshenv
```

Reload shell state after editing:

```bash
source ~/.zshenv
```

OpenCode variable substitution uses the form:

```text
{env:VARIABLE_NAME}
```

Make sure these variables are set before launching OpenCode, because this config references them directly.

## Setup

Create the config directory if needed:

```bash
mkdir -p ~/.config/opencode
```

Create or refresh symlinks:

```bash
DOTFILES_DIR="/path/to/your/dotfiles"
ln -sf "$DOTFILES_DIR/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
ln -sf "$DOTFILES_DIR/opencode/package.json" ~/.config/opencode/package.json
```

Then restart OpenCode so it installs or refreshes the `superpowers` plugin from the configured git source.

## How OpenCode Loads This

Useful behavior from current OpenCode docs:

1. Config is merged from multiple sources, not replaced wholesale.
2. Global config under `~/.config/opencode/` is only one layer.
3. Project-level `opencode.json` files can override global settings.
4. Config directories also support plural folders such as `agents/`, `commands/`, `plugins/`, `skills/`, and `tools/`.

For this repo, that means:
- this directory provides the global baseline
- project repos can still override model, permissions, commands, or other settings
- skill discovery for `superpowers` comes from the plugin, not from dotfiles-managed skill directories

## Plugins And Dependencies

OpenCode supports plugins declared in config via the `plugin` key and local plugins placed in config plugin directories.

This repo uses the config-based approach for `superpowers`.

## Verification Commands

Check the symlinks actually in use:

```bash
ls -la ~/.config/opencode
```

Check that the plugin is present in the resolved config:

```bash
opencode debug config
```

Look for `plugin` including `superpowers@git+https://github.com/obra/superpowers.git`.

Inspect available models from the UI:

```text
/models
```

Inspect credentials or connect a provider interactively:

```text
/connect
```

## Notes About The Current State

- The config is valid for a custom provider setup.
- The config installs `superpowers` via OpenCode's native plugin mechanism.
- The repo currently sets `model` to `tenefic/gpt-5.4` and `small_model` to `tenefic/gpt-5.4-mini`.
- The OpenCode schema supports per-model `cost` metadata under `provider.<name>.models.<model>.cost`.
- This repo currently fills that metadata using OpenAI public pricing as the reference source, not guaranteed Tenefic billing rates.
- Cost tracking, if needed, should usually live in the provider or proxy layer rather than in `opencode.jsonc`.
- `README.md` is intended to document the actual setup in this dotfiles repo, not to replace the full OpenCode docs.

## References

- OpenCode config docs: `https://opencode.ai/docs/config/`
- OpenCode providers docs: `https://opencode.ai/docs/providers/`
- OpenCode models docs: `https://opencode.ai/docs/models/`
- OpenCode plugins docs: `https://opencode.ai/docs/plugins/`
