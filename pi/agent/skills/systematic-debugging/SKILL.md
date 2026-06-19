---
name: systematic-debugging
description: "Use when encountering any bug, test failure, build failure, regression, or unexpected behavior. Hard gate: no fixes without root cause investigation first."
---

# Systematic Debugging

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

Core principle: always find root cause before attempting fixes. Symptom fixes are failure.

## The Iron Law

```text
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you have not completed root cause investigation, do not propose fixes.

## When to Use

Use for any technical issue:

- Test failures.
- Build failures.
- Production bugs.
- Unexpected behavior.
- Performance problems.
- Integration issues.

Use this especially when a quick fix seems obvious, you are under time pressure, or previous fixes failed.

## Process

1. Read the full error message, stack trace, and relevant logs.
2. Reproduce the issue consistently when feasible.
3. Check recent changes and current diffs.
4. Find similar working code and compare patterns.
5. Trace data flow until the bad value or behavior originates.
6. State a single hypothesis with evidence.
7. Test the hypothesis minimally.
8. Fix the root cause, not the symptom.
9. Verify the original issue and relevant regressions.

## Trivial Bugs

When the root cause is obvious from a single error message, you may collapse the investigation into one short statement of cause, then fix and verify. The root cause must still be stated before fixing.

## Red Flags

- "Just try changing X."
- "It is probably Y" without evidence.
- Multiple changes before checking which one worked.
- A third failed fix attempt.
- Fixes that reveal new symptoms in unrelated places.

If any red flag appears, stop and return to investigation.
