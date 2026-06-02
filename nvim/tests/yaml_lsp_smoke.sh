#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
project_dir="$(mktemp -d)"
trap 'rm -rf "$project_dir"' EXIT

cat >"$project_dir/test.yaml" <<'YAML'
service: api
enabled: true
YAML

git -C "$project_dir" init -q

cat >"$project_dir/assert.lua" <<'LUA'
vim.wait(1500)

local clients = vim.lsp.get_clients({ bufnr = 0 })
for _, client in ipairs(clients) do
	if client.name == "yamlls" then
		return
	end
end

error("yamlls did not attach")
LUA

output="$(
  XDG_CONFIG_HOME="$repo_root" nvim --headless \
    -c "edit $project_dir/test.yaml" \
    -c "lua dofile('$project_dir/assert.lua')" \
    -c qa 2>&1
)"

if printf '%s' "$output" | rg -n 'Error in command line|E[0-9]{4}|yamlls did not attach' >/dev/null; then
  printf '%s\n' "$output" >&2
  exit 1
fi

printf 'YAML LSP smoke check passed\n'
