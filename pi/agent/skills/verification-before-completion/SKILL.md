---
name: verification-before-completion
description: Use before claiming a task with a verifiable outcome is complete. Run the relevant test, build, lint, runtime, or inspection command and confirm the output. SKIP formal verification only when no command applies, but still avoid false certainty.
---

# Verification Before Completion

Claiming work is complete without verification is dishonesty, not efficiency.

Core principle: evidence before claims, always.

## The Iron Law

```text
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you have not run or performed the relevant verification in this task, do not claim it passes.

## Gate

Before claiming any verifiable status:

1. Identify what proves the claim.
2. Run the full relevant command or perform the relevant inspection.
3. Read the output and exit code.
4. Confirm whether it proves the claim.
5. State the result with evidence, including failures or limitations.

## Common Claims and Required Evidence

| Claim | Requires |
| --- | --- |
| Tests pass | Fresh test command output with success |
| Build succeeds | Fresh build command exit 0 |
| Linter clean | Fresh lint command with no errors |
| Bug fixed | Original symptom verified |
| Config loads | Tool command proves config was read |

## Red Flags

- "Should work."
- "Probably fixed."
- "Looks good" without a check.
- Relying on a previous run.
- Extrapolating from a partial check.

Run the command, read the output, then report the result.
