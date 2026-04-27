---
name: verification-before-completion
description: Use before claiming a task with a verifiable outcome (tests, build, lint, runtime behavior) is complete. Run the verification command and confirm output — no success claims without fresh evidence. SKIP for pure explanation, code review, read-only exploration, or doc/comment-only edits where no command applies — the spirit ("no false certainty") still applies, but invent no verification command where none exists.
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test command output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Test original symptom: passes | Code changed, assumed fixed |
| Regression test works | Red-green cycle verified | Test passes once |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Relying on partial verification
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter ≠ compiler |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Key Patterns

**Tests:**
```
✅ [Run test command] [See: 34/34 pass] → "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Build:**
```
✅ [Run build] [See: exit 0] → "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**
```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

## When To Apply

**ALWAYS before:**
- Claiming tests/build/lint pass
- Claiming a bug is fixed or feature works
- Committing, PR creation, task completion
- Moving to next task

## When NOT To Apply

The skill governs **verifiable outcomes**. Skip the formal gate when:
- Pure explanation, exploration, or code review (no claim of execution success)
- Doc/comment-only edits with no compile or render step
- Conversational acknowledgments ("got it", "sounds good") that are not completion claims
- UI tweaks where the user verifies visually
- Tasks where no command can prove the claim

In these cases, state results plainly without false certainty. The principle is "no lying about success", not "always run a command".

## The Bottom Line

Run the command. Read the output. THEN claim the result.

This is non-negotiable.
