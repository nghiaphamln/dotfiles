# Iron Laws

Core behavioral rules. For full guidance, invoke the relevant skill.

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
