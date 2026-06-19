# Pi Agent Instructions

Use these global instructions for all projects unless a project-local `AGENTS.md` or `CLAUDE.md` adds more specific constraints.

- Be pragmatic and direct. Prefer the smallest correct change.
- Inspect the codebase before making assumptions.
- Preserve user changes. Do not revert unrelated work.
- Avoid speculative abstractions and broad refactors.
- Ask one focused question when requirements are ambiguous enough to affect the implementation.
- For bugs and failures, investigate root cause before fixing.
- For verifiable work, run the relevant check before claiming completion.
- For non-trivial features or refactors, clarify the design before implementation unless the user has already specified the exact change.
