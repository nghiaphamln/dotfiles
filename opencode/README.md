# OpenCode Configuration

Configuration for [OpenCode](https://opencode.ai/) — an AI coding agent that runs in the terminal.

## Structure

```
opencode/
├── opencode.jsonc   → ~/.config/opencode/opencode.jsonc  (main config)
└── package.json     → ~/.config/opencode/package.json    (plugins)

skills/
└── superpowers      → ../superpowers/skills/  (symlink to Superpowers skills)

superpowers/         → ~/.config/opencode/superpowers     (git clone of obra/superpowers)
```

## Setup

### 1. Create symlinks

```bash
mkdir -p ~/.config/opencode

ln -sf ~/dotfiles/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -sf ~/dotfiles/opencode/package.json ~/.config/opencode/package.json
ln -sf ~/dotfiles/skills ~/.config/opencode/skills
ln -sf ~/dotfiles/superpowers ~/.config/opencode/superpowers
```

### 2. Set API keys

The config uses environment variables instead of hardcoded keys, making it safe to store in a public git repository.

Add the following to `~/.zshenv`:

```bash
# OpenCode API keys
export TENEFIC_API_KEY="your-tenefic-key"
export TENEFIC_BASE_URL="your-tenefic-base-url"
```

Then reload your shell:

```bash
source ~/.zshenv
```

### 3. Install plugins

```bash
cd ~/.config/opencode && bun install
```

## Providers

| Provider | Env var | Description |
|---|---|---|
| `tenefic` | `TENEFIC_API_KEY`, `TENEFIC_BASE_URL` | Tenefic proxy |

Environment variable syntax in `opencode.jsonc`: `{env:VARIABLE_NAME}`.
If a variable is not set, OpenCode replaces it with an empty string (no error thrown).

## Superpowers

[Superpowers](https://github.com/obra/superpowers) is a collection of skills that give AI agents a structured development workflow: brainstorming → planning → TDD → code review.

Skills are loaded automatically when OpenCode starts via the following symlink chain:

```
~/.config/opencode/skills/superpowers
  → dotfiles/skills/superpowers
    → dotfiles/superpowers/skills/
```

**Available skills:**
- `brainstorming` — Explore requirements before writing code
- `writing-plans` — Create an implementation plan
- `executing-plans` — Execute a plan using subagents
- `test-driven-development` — TDD workflow
- `systematic-debugging` — Structured debugging process
- `requesting-code-review` — Review work before merging
- `receiving-code-review` — Handle review feedback
- `dispatching-parallel-agents` — Run multiple tasks in parallel
- `subagent-driven-development` — Development via subagents
- `finishing-a-development-branch` — Complete and wrap up a branch
- `using-git-worktrees` — Work with git worktrees
- `verification-before-completion` — Verify before claiming work is done
- `writing-skills` — Create new skills
- `using-superpowers` — General overview and entry point

### Update Superpowers

```bash
cd ~/dotfiles/superpowers && git pull
```

## Adding Custom Skills

Create a new skill directory inside `dotfiles/skills/`:

```bash
mkdir -p ~/dotfiles/skills/my-skill
echo "---\nname: my-skill\n---\n# My Skill\n..." > ~/dotfiles/skills/my-skill/skill.md
```

OpenCode will pick it up automatically since `~/.config/opencode/skills/` is symlinked to `dotfiles/skills/`.
