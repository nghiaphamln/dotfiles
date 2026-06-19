# Karpathy Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Bias toward clarity, small changes, and verifiable outcomes.

## 1. Think Before Coding

Do not assume. Do not hide confusion. Surface tradeoffs.

- State assumptions explicitly when they affect implementation.
- If multiple interpretations exist, present them instead of silently choosing.
- If a simpler approach exists, say so and prefer it.
- If something is unclear, stop, name what is confusing, and ask.

## 2. Simplicity First

Write the minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No flexibility or configurability that was not requested.
- No error handling for impossible scenarios.
- If a solution is much larger than needed, simplify it.

Ask: would a senior engineer say this is overcomplicated? If yes, reduce scope.

## 3. Surgical Changes

Touch only what is necessary. Clean up only your own mess.

- Do not improve adjacent code, comments, or formatting unless required.
- Do not refactor things that are not broken.
- Match existing style, even if you would normally do it differently.
- If you notice unrelated dead code or risks, mention them instead of changing them.
- Remove imports, variables, and functions that your own changes made unused.

Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

Turn work into verifiable goals and loop until checked.

- For bugs: reproduce or identify root cause before fixing.
- For features: define expected behavior and verification before implementing.
- For refactors: preserve behavior and verify before and after when feasible.
- For multi-step work: keep a concise plan with a verification path.

Do not claim success without fresh evidence from a relevant command, inspection, or explicit limitation.

## 5. Workflow Gates Override Minimalism

Ponytail governs solution minimalism only. It must not override workflow gates.

When applicable, these gates take precedence over Ponytail:

1. Use brainstorming before non-trivial design, feature, or refactor work.
2. Use systematic-debugging before bug fixes or unexpected behavior fixes.
3. Use test-driven-development for app-level feature or bugfix work when tests exist.
4. Use verification-before-completion before claiming completion.

Minimal code is still unfinished if the required gate was skipped.
