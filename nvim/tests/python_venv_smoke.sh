#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
project_dir="$(mktemp -d)"
trap 'rm -rf "$project_dir"' EXIT

mkdir -p "$project_dir/.venv/bin"
touch "$project_dir/pyrightconfig.json"

for tool in python black isort pylint; do
  cat >"$project_dir/.venv/bin/$tool" <<'SH'
#!/usr/bin/env sh
exit 0
SH
  chmod +x "$project_dir/.venv/bin/$tool"
done

cat >"$project_dir/assert.lua" <<'LUA'
local project_dir = assert(vim.env.PROJECT_DIR)
local python = require("config.python")

assert(vim.tbl_contains(python.root_markers, "pyrightconfig.json"), "pyrightconfig.json root marker missing")
assert(vim.tbl_contains(python.root_markers, "Pipfile"), "Pipfile root marker missing")

assert(python.resolve_project_python(project_dir) == project_dir .. "/.venv/bin/python", "project python should prefer .venv")
assert(python.resolve_tool("black", project_dir) == project_dir .. "/.venv/bin/black", "black should prefer .venv")
assert(python.resolve_tool("isort", project_dir) == project_dir .. "/.venv/bin/isort", "isort should prefer .venv")
assert(python.resolve_tool("pylint", project_dir) == project_dir .. "/.venv/bin/pylint", "pylint should prefer .venv")

local fallback_root = vim.fn.stdpath("config")
assert(python.resolve_tool("black", fallback_root):match("black$"), "black fallback should resolve an executable")
assert(python.resolve_pyright_cmd()[1] ~= "", "pyright command should not be empty")
LUA

output="$(
  XDG_CONFIG_HOME="$repo_root" PROJECT_DIR="$project_dir" nvim --headless -c "lua dofile('$project_dir/assert.lua')" -c qa 2>&1
)"

if printf '%s' "$output" | rg -n 'Error in command line|E[0-9]{4}' >/dev/null; then
  printf '%s\n' "$output" >&2
  exit 1
fi

printf 'Python venv smoke check passed\n'
