#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
health_report="$(mktemp)"
trap 'rm -f "$health_report"' EXIT

if rg -n 'vim\.lsp\.config\(server_name\):setup\(' "$repo_root/nvim/lua" >/dev/null; then
  printf 'Legacy mason-lspconfig setup pattern still present\n' >&2
  exit 1
fi

if rg -n 'vim\.lsp\.buf\.inlay_hint' "$repo_root/nvim/lua" >/dev/null; then
  printf 'Legacy inlay hint API still present\n' >&2
  exit 1
fi

if rg -n 'Library/Python/3\.14/bin' "$repo_root/nvim/lua" >/dev/null; then
  printf 'Python user bin path is hardcoded\n' >&2
  exit 1
fi

python3 - "$repo_root/nvim/lua/plugins/lsp.lua" <<'PY'
from pathlib import Path
import sys

text = Path(sys.argv[1]).read_text()

tool_block_start = text.index('"WhoIsSethDaniel/mason-tool-installer.nvim"')
tool_block_end = text.index('-- Mason LSPConfig: bridge between Mason and Neovim LSP configs')
tool_block = text[tool_block_start:tool_block_end]

lsp_block_start = text.index('"mason-org/mason-lspconfig.nvim"')
lsp_block_end = text.index('-- LSPConfig: configure language servers')
lsp_block = text[lsp_block_start:lsp_block_end]

tool_markers = ('"cmake-language-server"', '"cmake-format"')
lsp_markers = ('"cmake"',)

if any(marker in tool_block for marker in tool_markers) or any(marker in lsp_block for marker in lsp_markers):
    print('CMake is still Mason-managed', file=sys.stderr)
    raise SystemExit(1)
PY

XDG_CONFIG_HOME="$repo_root" nvim --headless '+checkhealth' "+w! $health_report" '+qa'

if rg -n 'WARNING Log size:' "$health_report" >/dev/null; then
  printf 'LSP log is oversized\n' >&2
  exit 1
fi

if rg -n "Tool not found: 'gs'" "$health_report" >/dev/null; then
  printf 'ghostscript is missing\n' >&2
  exit 1
fi

if rg -n "Tool not found: 'mmdc'" "$health_report" >/dev/null; then
  printf 'mermaid-cli is missing\n' >&2
  exit 1
fi

if rg -n 'Missing Treesitter languages:' "$health_report" >/dev/null; then
  printf 'treesitter languages are missing\n' >&2
  exit 1
fi

printf 'Neovim health smoke check passed\n'
