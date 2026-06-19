---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior. Hard gate — no fixes without root cause investigation first.
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Abridged process for trivial bugs:** When the root cause is obvious from a single error message (typo, missing import, undefined variable, off-by-one with clear fix), you may collapse Phases 1–3 into one short paragraph stating the cause, then go to Phase 4. The Iron Law still applies — you must state the cause before fixing — but you do not need formal pattern analysis or hypothesis testing for cases where the error message names the cause directly.

## Investigation Ladder

Complete the smallest investigation that proves the cause. Do not perform ceremony when a single error message already names the cause, but do not guess.

1. Read the full error, stack trace, logs, or failing output.
2. Reproduce the issue when feasible, or identify the exact observed symptom.
3. Check recent changes: current diff, recent commits, dependency/config changes, and environment differences.
4. Find similar working code and compare patterns.
5. Trace the bad value or behavior to its source.
6. State one hypothesis with evidence.
7. Test the hypothesis with the smallest command, inspection, or temporary diagnostic.
8. Fix the root cause with one focused change.
9. Verify the original symptom and relevant regressions.

For multi-component systems, add diagnostics at component boundaries before proposing fixes. Identify where data first becomes wrong, then investigate that component.

If three fix attempts fail, stop and question the architecture or assumptions before trying a fourth fix.

## Red Flags - STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "One more fix attempt" (when already tried 2+)
- Each fix reveals new problem in different place

**ALL of these mean: STOP. Return to investigation.**

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question pattern, don't fix again. |

## Implementation Rule

Prefer a failing test before fixing app-level behavior. If tests are unavailable or the issue is config/runtime-only, use the smallest command, log, or inspection that reproduces the original symptom.
