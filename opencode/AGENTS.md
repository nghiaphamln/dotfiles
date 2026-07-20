# OpenCode Global Instructions

Use these global instructions for all projects unless project-local `AGENTS.md` or `CLAUDE.md` files add more specific constraints.

## Working Style

- Be pragmatic and direct. Prefer the smallest correct change.
- Inspect project guidance, existing patterns, and relevant code before making assumptions or proposing broad changes.
- Surface assumptions and trade-offs when they materially affect the implementation. Do not silently choose between meaningfully different interpretations.
- If a simpler approach exists, say so. Push back when a request would add avoidable complexity or risk.
- Avoid speculative features, single-use abstractions, broad refactors, impossible-scenario error handling, and unrequested configurability.
- Match the repository's existing style. Every changed line should trace directly to the user's request.
- Preserve user changes. Do not revert, overwrite, reformat, or clean up unrelated work.
- Remove only imports, variables, functions, or files made unused by the current change. Mention unrelated dead code instead of deleting it.

## Goal-Driven Execution

- Translate the request into verifiable success criteria before implementing. Define the behavior or outcome that must change and the evidence that will prove it.
- For multi-step work, maintain a short task list using the native TODO tool when available; otherwise state it briefly. Give every step its own verification check:

  ```text
  1. [Step] -> verify: [check]
  2. [Step] -> verify: [check]
  3. [Step] -> verify: [check]
  ```

- Keep task status current as work progresses. Continue until the success criteria are met or a real blocker is found; report blockers and remaining gaps explicitly.
- For behavior changes and bug fixes, prefer a focused test or reproduction that demonstrates the expected outcome. For refactors, establish relevant checks before the change and run them again afterward.

## Execution

- Ask one focused question only when ambiguity materially changes the implementation; otherwise state the assumption and proceed.
- When the user requests planning or design only, remain read-only and stop after the plan. When implementation is explicitly requested, proceed once the relevant context is understood.
- For bugs and failures, investigate and state the root cause before fixing it.
- For verifiable work, run the relevant check before claiming completion. Report the actual evidence and any remaining gaps.
- For commits, inspect status and diff first, stage only intended files, and follow `git-conventions`.
- Shell commands run non-interactively. Avoid editors, pagers, REPLs, interactive git modes, and prompts; use explicit flags such as `--no-edit`, `-y`, `--no-input`, or native tools instead.
