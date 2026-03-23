# Zed IDE Dotfiles Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Zed IDE config to dotfiles repo và tạo directory symlink `~/.config/zed -> dotfiles/zed`, nhất quán với pattern kitty/nvim.

**Architecture:** Tạo thư mục `zed/` trong dotfiles chứa `settings.json` và `.gitignore` (để exclude prompts DB). Backup và xóa `~/.config/zed` hiện tại, sau đó tạo symlink trỏ về dotfiles.

**Tech Stack:** zsh, ln (symlink), git

---

### Task 1: Tạo thư mục zed trong dotfiles và copy settings

**Files:**
- Create: `zed/settings.json`
- Create: `zed/.gitignore`

- [ ] **Step 1: Tạo thư mục zed và copy settings.json**

```bash
mkdir -p /Users/nghiapham/Work/Nexorion/dotfiles/zed
cp ~/.config/zed/settings.json /Users/nghiapham/Work/Nexorion/dotfiles/zed/settings.json
```

- [ ] **Step 2: Tạo .gitignore để exclude prompts DB và themes (nếu rỗng)**

```bash
cat > /Users/nghiapham/Work/Nexorion/dotfiles/zed/.gitignore << 'EOF'
# Zed runtime files - không track vào git
prompts/
EOF
```

- [ ] **Step 3: Verify nội dung**

```bash
cat /Users/nghiapham/Work/Nexorion/dotfiles/zed/settings.json
cat /Users/nghiapham/Work/Nexorion/dotfiles/zed/.gitignore
```

Expected: `settings.json` có vim_mode, theme, font settings. `.gitignore` có `prompts/`.

- [ ] **Step 4: Commit**

```bash
cd /Users/nghiapham/Work/Nexorion/dotfiles
git add zed/settings.json zed/.gitignore
git commit -m "feat(zed): add zed ide config"
```

---

### Task 2: Tạo symlink ~/.config/zed -> dotfiles/zed

**Files:**
- Symlink: `~/.config/zed`

- [ ] **Step 1: Backup thư mục zed hiện tại**

```bash
cp -r ~/.config/zed ~/.config/zed.backup.$(date +%Y%m%d_%H%M%S)
echo "Backup created"
```

- [ ] **Step 2: Xóa thư mục zed hiện tại**

```bash
rm -rf ~/.config/zed
```

- [ ] **Step 3: Tạo symlink**

```bash
ln -s /Users/nghiapham/Work/Nexorion/dotfiles/zed ~/.config/zed
```

- [ ] **Step 4: Verify symlink**

```bash
ls -la ~/.config/zed
cat ~/.config/zed/settings.json
```

Expected: `~/.config/zed` là symlink trỏ về dotfiles/zed. `settings.json` đọc được.

- [ ] **Step 5: Tạo lại thư mục prompts để Zed không bị lỗi**

```bash
mkdir -p ~/.config/zed/prompts
```

Expected: `~/.config/zed/prompts/` tồn tại (là thư mục thật bên trong symlinked dir).

- [ ] **Step 6: Verify toàn bộ cấu trúc**

```bash
ls -la ~/.config/ | grep zed
ls -la ~/.config/zed/
```

Expected output:
```
~/.config/zed -> /Users/nghiapham/Work/Nexorion/dotfiles/zed
zed/
├── .gitignore
├── settings.json
└── prompts/        ← thư mục thật, không tracked bởi git
```

- [ ] **Step 7: Commit docs**

```bash
cd /Users/nghiapham/Work/Nexorion/dotfiles
git add docs/
git commit -m "docs: add zed dotfiles plan"
```

---

### Verification cuối

- [ ] Mở Zed IDE, kiểm tra settings vẫn hoạt động (vim mode, theme, font size)
- [ ] Chạy `ls -la ~/.config/zed` — phải là symlink
- [ ] Chạy `git status` trong dotfiles — phải clean (prompts/ không bị track)
