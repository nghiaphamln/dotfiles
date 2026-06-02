#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
project_dir="$(mktemp -d)"
trap 'rm -rf "$project_dir"' EXIT

local_project="$project_dir/local-project"
fallback_project="$project_dir/fallback-project"
fallback_bin="$project_dir/fallback-bin"

mkdir -p "$local_project/node_modules/.bin" "$fallback_project" "$fallback_bin"
printf '{"b":2,"a":1}\n' >"$local_project/data.json"
printf '{"b":2,"a":1}\n' >"$fallback_project/data.json"

cat >"$local_project/node_modules/.bin/prettier" <<'SH'
#!/usr/bin/env sh
exit 0
SH
chmod +x "$local_project/node_modules/.bin/prettier"

cat >"$fallback_bin/prettier" <<'SH'
#!/usr/bin/env sh
exit 0
SH
chmod +x "$fallback_bin/prettier"

cat >"$project_dir/assert.lua" <<'LUA'
local project_dir = assert(vim.env.PROJECT_DIR)
local local_project = project_dir .. "/local-project"
local fallback_project = project_dir .. "/fallback-project"

local function formatter_info(path)
	vim.cmd.edit(path)
	return require("conform").get_formatter_info("prettier", 0)
end

local local_info = formatter_info(local_project .. "/data.json")
assert(local_info.available, "prettier should be available for project-local json")
assert(
	vim.fn.resolve(local_info.command) == vim.fn.resolve(local_project .. "/node_modules/.bin/prettier"),
	"prettier should prefer node_modules/.bin"
)

local fallback_info = formatter_info(fallback_project .. "/data.json")
assert(fallback_info.available, "prettier fallback should still be available")
assert(
	fallback_info.command == "prettier",
	"prettier should fall back to PATH command when local binary is absent"
)
assert(
	vim.fn.resolve(vim.fn.exepath(fallback_info.command)) == vim.fn.resolve(project_dir .. "/fallback-bin/prettier"),
	"prettier PATH fallback should resolve to the injected executable"
)
LUA

output="$(
  XDG_CONFIG_HOME="$repo_root" \
  PROJECT_DIR="$project_dir" \
  PATH="$project_dir/fallback-bin:$PATH" \
  nvim --headless -c "lua dofile('$project_dir/assert.lua')" -c qa 2>&1
)"

if printf '%s' "$output" | rg -n 'Error in command line|E[0-9]{4}' >/dev/null; then
  printf '%s\n' "$output" >&2
  exit 1
fi

printf 'Prettier smoke check passed\n'
