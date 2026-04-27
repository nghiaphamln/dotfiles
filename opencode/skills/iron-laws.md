# Iron Laws

Core behavioral rules. For full guidance, invoke the relevant skill.

## Brainstorming

**NO CODE BEFORE DESIGN APPROVAL.**

For any new feature, refactor, or non-trivial change: explore intent and constraints, propose 2-3 approaches with trade-offs, and get explicit user approval before writing or scaffolding anything. Plan mode especially: invoke `brainstorming` skill at the start.

Red flags:
- Writing code in the first turn of a feature request
- Proposing a single approach without alternatives
- Skipping clarifying questions because the request "seems clear"
- "I'll just sketch it out" before user approves the design

For full methodology: invoke `brainstorming` skill.

## Debugging

**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.**

Before proposing any fix: read the full error, reproduce it, trace the data flow. If you haven't understood WHY it breaks, you cannot propose a fix.

Red flags — stop and investigate if you catch yourself:
- "Just try changing X and see if it works"
- "It's probably X, let me fix that"
- Proposing fixes before tracing the root cause
- Attempting a 4th fix after 3 have already failed (question the architecture instead)

For full methodology: invoke `systematic-debugging` skill.

## Verification

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Before claiming done, fixed, or passing: run the actual command, read the full output, then make the claim. "Should work", "probably passes", "looks correct" are not verification.

Red flags:
- Using "should", "probably", "seems to"
- Expressing satisfaction before running verification ("Done!", "Perfect!")
- Trusting a previous run instead of running fresh

For full methodology: invoke `verification-before-completion` skill.

## Testing

**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

Write the test. Run it. Watch it fail. Then write the minimal code to make it pass. If you didn't see it fail, you don't know if it tests the right thing.

Red flags:
- Writing code before the test exists
- Test passes immediately on first run (you never saw it fail)
- "I'll add tests after"

For full methodology: invoke `test-driven-development` skill.

## Tool Concurrency

**PARALLEL ONLY WHEN TRULY INDEPENDENT. WHEN IN DOUBT, SEQUENTIAL.**

Two tool calls are independent only if neither's output is the other's input AND neither writes state the other reads. Violating this causes stale reads, edit conflicts, and lost shell state.

**Safe to parallelize (no shared mutable state):**
- Read on different files
- Grep / Glob on different patterns or paths
- WebFetch + local Read
- git status + git diff + git log (read-only snapshot, before any write)
- Independent searches that inform separate decisions

**Must be sequential:**
- Edit/Write followed by Read of the same file (Read sees pre-edit content if parallel)
- Two Edits/Writes touching the same file (second fails — first changed the text)
- Bash `cd X` followed by another Bash command (shell state does not persist across calls — use absolute paths instead)
- Any write followed by `git status` / `git diff` / build / test relying on that write
- Any command whose output the next call needs to read or branch on

Red flags:
- Batching an Edit with a same-file Read in one response
- Batching `cd` with the command that depends on the new directory
- Running verification (`git status`, tests) parallel with the Edit it should verify
- "It'll probably finish in order" — order is not guaranteed
