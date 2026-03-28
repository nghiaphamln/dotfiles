# OpenCode Configuration

Cấu hình cho [OpenCode](https://opencode.ai/) — AI coding agent chạy trên terminal.

## Cấu trúc

```
opencode/
├── opencode.jsonc   → ~/.config/opencode/opencode.jsonc  (config chính)
└── package.json     → ~/.config/opencode/package.json    (plugins)

skills/
└── superpowers      → ../superpowers/skills/  (symlink đến skills của Superpowers)

superpowers/         → ~/.config/opencode/superpowers     (git clone obra/superpowers)
```

## Cài đặt

### 1. Symlink config files

```bash
mkdir -p ~/.config/opencode

ln -sf ~/dotfiles/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc
ln -sf ~/dotfiles/opencode/package.json ~/.config/opencode/package.json
ln -sf ~/dotfiles/skills ~/.config/opencode/skills
ln -sf ~/dotfiles/superpowers ~/.config/opencode/superpowers
```

### 2. Khai báo API keys

Config dùng environment variables thay cho API keys thật để an toàn khi lưu trên git public.

Thêm vào `~/.zshenv`:

```bash
# OpenCode API keys
export TENEFIC_API_KEY="your-tenefic-key"
export TENEFIC_BASE_URL="your-tenefic-base-url"
```

Sau khi thêm, reload shell:

```bash
source ~/.zshenv
```

### 3. Cài plugins

```bash
cd ~/.config/opencode && bun install
```

## Providers

Config hiện tại có 2 provider:

| Provider | Env var | Mô tả |
|---|---|---|
| `danglamgiau` | `DANGLAMGIAU_API_KEY` | DangLamGiau API |
| `tenefic` | `TENEFIC_API_KEY`, `TENEFIC_BASE_URL` | Tenefic proxy |

Syntax env var trong `opencode.jsonc`: `{env:VARIABLE_NAME}`.
Nếu env var chưa được set, OpenCode sẽ thay bằng chuỗi rỗng (không báo lỗi).

## Superpowers

[Superpowers](https://github.com/obra/superpowers) là bộ skills giúp AI agent làm việc có quy trình hơn: brainstorming → planning → TDD → code review.

Skills được load tự động khi OpenCode khởi động thông qua chuỗi symlink:

```
~/.config/opencode/skills/superpowers
  → dotfiles/skills/superpowers
    → dotfiles/superpowers/skills/
```

**Skills có sẵn:**
- `brainstorming` — Khám phá yêu cầu trước khi code
- `writing-plans` — Tạo implementation plan
- `executing-plans` — Thực thi plan với subagents
- `test-driven-development` — TDD workflow
- `systematic-debugging` — Debug có hệ thống
- `requesting-code-review` — Review trước khi merge
- `receiving-code-review` — Xử lý feedback review
- `dispatching-parallel-agents` — Chạy nhiều tasks song song
- `subagent-driven-development` — Phát triển qua subagents
- `finishing-a-development-branch` — Hoàn tất branch
- `using-git-worktrees` — Làm việc với git worktrees
- `verification-before-completion` — Xác minh trước khi claim done
- `writing-skills` — Tạo skills mới
- `using-superpowers` — Hướng dẫn tổng quan

### Update Superpowers

```bash
cd ~/dotfiles/superpowers && git pull
```

## Thêm skills tùy chỉnh

Tạo thư mục skill mới trong `dotfiles/skills/`:

```bash
mkdir -p ~/dotfiles/skills/my-skill
# Tạo file skill
echo "---\nname: my-skill\n---\n# My Skill\n..." > ~/dotfiles/skills/my-skill/skill.md
```

OpenCode tự nhận vì `~/.config/opencode/skills/` đã symlink đến `dotfiles/skills/`.
