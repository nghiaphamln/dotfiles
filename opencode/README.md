# OpenCode Configuration

This directory contains the OpenCode configuration that is symlinked into `~/.config/opencode` from this dotfiles repo.

The current setup is centered around:
- a global `opencode.jsonc` config stored in dotfiles
- a custom OpenAI-compatible provider named `tenefic`
- shared skills loaded from the dotfiles-managed `skills/` and `superpowers/` directories
- an optional `package.json` in the config directory for local plugin or custom tool dependencies

## Current Layout

```text
dotfiles/
├── opencode/
│   ├── opencode.jsonc
│   ├── package.json
│   └── README.md
├── skills/
└── superpowers/
```

Runtime layout:

```text
~/.config/opencode/
├── opencode.jsonc  -> /path/to/your/dotfiles/opencode/opencode.jsonc
├── package.json    -> /path/to/your/dotfiles/opencode/package.json
├── skills          -> /path/to/your/dotfiles/skills
└── superpowers     -> /path/to/your/dotfiles/superpowers
```

## What This Repo Configures

### Global config

`opencode.jsonc` is the main global OpenCode config for this setup.

OpenCode docs primarily show `~/.config/opencode/opencode.json`, but OpenCode supports both JSON and JSONC. This repo intentionally uses JSONC so comments can be added later if needed.

Current config responsibilities:
- declare the custom provider `tenefic`
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

### Skills

This setup expects OpenCode skills to be available through the symlinked `skills/` directory.

`superpowers/` is also symlinked because the current workflow depends on the Superpowers skill collection being available from dotfiles.

In practice, this means OpenCode can discover skills from the config directory without copying those files into `~/.config/opencode` manually.

### package.json

`package.json` exists in the config directory so local plugins or custom tools can declare dependencies if needed.

Important note about the current state:
- the repo currently has a dependency on `@opencode-ai/plugin`
- there are no local plugin files currently present in the active OpenCode plugin directories for this setup
- so the dependency is currently optional for day-to-day use unless local plugins are added later

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

## Symlink Setup

Create the config directory if needed:

```bash
mkdir -p ~/.config/opencode
```

Create or refresh symlinks:

```bash
DOTFILES_DIR="/path/to/your/dotfiles"
ln -sf "$DOTFILES_DIR/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
ln -sf "$DOTFILES_DIR/opencode/package.json" ~/.config/opencode/package.json
ln -sf "$DOTFILES_DIR/skills" ~/.config/opencode/skills
ln -sf "$DOTFILES_DIR/superpowers" ~/.config/opencode/superpowers
```

## How OpenCode Loads This

Useful behavior from current OpenCode docs:

1. Config is merged from multiple sources, not replaced wholesale.
2. Global config under `~/.config/opencode/` is only one layer.
3. Project-level `opencode.json` files can override global settings.
4. Config directories also support plural folders such as `agents/`, `commands/`, `plugins/`, `skills/`, and `tools/`.

For this repo, that means:
- this directory provides the global baseline
- project repos can still override model, permissions, commands, or other settings
- skill discovery is influenced by the symlinked skill directories, not only by `opencode.jsonc`

## Plugins And Dependencies

OpenCode supports two different plugin-related paths:

1. npm plugins declared in config via the `plugin` key
2. local plugins placed in config plugin directories such as `~/.config/opencode/plugins/`

This repo currently does not declare any npm plugins in `opencode.jsonc`.

This setup also does not currently have local plugin source files in the active OpenCode plugin directories.

That means the current `package.json` is best treated as dependency scaffolding for future local plugin or custom tool development, not as proof that plugins are active today.

## Verification Commands

Check the symlinks actually in use:

```bash
ls -la ~/.config/opencode
```

Inspect the resolved OpenCode config:

```bash
opencode debug config
```

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
