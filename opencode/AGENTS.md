# OpenCode Global Instructions

Use these global instructions for all projects unless project-local `AGENTS.md` or `CLAUDE.md` files add more specific constraints.

- Be pragmatic and direct. Prefer the smallest correct change.
- Inspect the codebase before making assumptions or proposing broad changes.
- Preserve user changes. Do not revert or overwrite unrelated work.
- Avoid speculative abstractions, broad refactors, and unrequested configurability.
- Ask one focused question when ambiguity affects the implementation.
- Use Plan mode for new features, refactors, or unclear multi-step work before editing.
- For bugs and failures, investigate root cause before fixing.
- For verifiable work, run the relevant check before claiming completion.
- For commits, inspect status and diff first, stage only intended files, and follow `git-conventions`.
- Shell commands run non-interactively. Avoid editors, pagers, REPLs, interactive git modes, and prompts; use explicit flags such as `--no-edit`, `-y`, `--no-input`, or native tools instead.
