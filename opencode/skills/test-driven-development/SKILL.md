---
name: test-driven-development
description: Use when implementing app-level features, bug fixes, behavior changes, or pure refactors in a repository with a test framework. Use red-green-refactor for changed behavior and a green-before/green-after baseline for pure refactors. SKIP for dotfiles, config files, shell scripts, infrastructure, throwaway prototypes, generated code, or repos without a test runner.
---

# Test-Driven Development (TDD)

## Overview

For new or changed behavior, write the test first, watch it fail, then write minimal code to pass. For a pure refactor, establish a green baseline and keep it green.

**Core principle:** A test intended to prove new behavior must fail for the expected reason before the implementation makes it pass.

## When to Use

**Use red-green-refactor for app-level behavior changes:**
- New features
- Bug fixes
- Behavior changes

**Use a green baseline for pure refactors:**
- Run the relevant existing checks before editing.
- Add a passing characterization test first when important behavior lacks coverage.
- Refactor without changing behavior, then run the same checks again.

**Skip by default:**
- Dotfiles and configuration files
- Shell scripts and infrastructure
- Throwaway prototypes
- Generated code
- Repositories without a test runner

If the user explicitly wants tests for one of these cases, follow the closest practical test and verification loop.

## The Iron Law

```
NO NEW OR CHANGED PRODUCTION BEHAVIOR WITHOUT A FAILING TEST FIRST
```

This gate applies only to new or changed behavior written during the current task. Never delete, revert, or overwrite pre-existing code or user work to manufacture a red phase. If you wrote implementation code first and can safely undo only your own current-task changes, return to the failing test; otherwise preserve the work, add the strongest regression test available, and report the actual sequence honestly.

Pure behavior-preserving refactors do not need a failing test. They need relevant checks passing before and after the refactor.

## Red-Green-Refactor

### RED - Write Failing Test

Write one minimal test showing what should happen.

**Good test:**
```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };

  const result = await retryOperation(operation);

  expect(result).toBe('success');
  expect(attempts).toBe(3);
});
```
Clear name, tests real behavior, one thing.

**Bad test:**
```typescript
test('retry works', async () => {
  const mock = jest.fn()
    .mockRejectedValueOnce(new Error())
    .mockResolvedValueOnce('success');
  await retryOperation(mock);
  expect(mock).toHaveBeenCalledTimes(3);
});
```
Vague name, tests mock not code.

**Requirements:** One behavior. Clear name. Real code (no mocks unless unavoidable).

### Verify RED - Watch It Fail

**MANDATORY. Never skip.**

Run the test. Confirm:
- Test fails (not errors)
- Failure message is expected
- Fails because feature missing (not typos)

**Test passes?** You're testing existing behavior. Fix test.

### GREEN - Minimal Code

Write simplest code to pass the test. Don't add features, refactor other code, or "improve" beyond the test.

### Verify GREEN - Watch It Pass

**MANDATORY.**

Run all tests. Confirm:
- Test passes
- Other tests still pass
- No new relevant errors or warnings were introduced; report pre-existing noise instead of expanding scope to clean it up

**Test fails?** Fix code, not test.

### REFACTOR - Clean Up

After green only:
- Remove duplication
- Improve names
- Extract helpers

Keep tests green. Don't add behavior.

### Repeat

Next failing test for next feature.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Tests after achieve same goals" | Tests-after = "what does this do?" Tests-first = "what should this do?" |
| "Already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "The implementation already exists" | Preserve pre-existing or user-written code. Add a regression or characterization test and do not claim a test-first sequence you did not observe. |
| "TDD will slow me down" | TDD faster than debugging. Pragmatic = test-first. |

## Red Flags - Stop and Re-establish the Test Loop

- New or changed behavior written during the current task before its test
- Test passes immediately (without seeing it fail first)
- Can't explain why test failed
- Rationalizing "just this once"
- "Tests after achieve the same purpose"

**If the agent's own current-task behavior change was written first, return to the failing test when that can be done without touching pre-existing or user work. Otherwise preserve the work, add the best regression test available, and disclose that the red phase was not observed.**

## Example: Bug Fix

**Bug:** Empty email accepted

**RED**
```typescript
test('rejects empty email', async () => {
  const result = await submitForm({ email: '' });
  expect(result.error).toBe('Email required');
});
```

**Verify RED:** Run test → see it fail with expected reason.

**GREEN**
```typescript
function submitForm(data: FormData) {
  if (!data.email?.trim()) {
    return { error: 'Email required' };
  }
}
```

**Verify GREEN:** Run test → see it pass.

## Verification Checklist

Before marking work complete:

- [ ] New behavior is covered by focused tests where applicable
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason (feature missing, not typo)
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass
- [ ] No new relevant errors or warnings were introduced
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered
- [ ] Pure refactors had relevant checks pass before and after

If required boxes are not applicable, say why. If an applicable red-green step was missed, preserve existing work, add the strongest verification now, and report the gap honestly.

## Final Rule

```
New or changed app behavior with a test runner -> test exists and failed first
Pure refactor -> relevant checks pass before and after
Pre-existing or user-written behavior -> preserve it and add regression or characterization coverage
Otherwise -> use the closest practical verification path and report limitations
```
