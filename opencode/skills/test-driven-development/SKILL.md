---
name: test-driven-development
description: Use when implementing app-level features or bugfixes in a repository that has a test framework set up. Write failing test first, watch it fail, then write minimal code to pass. SKIP for dotfiles, config files, shell scripts, infrastructure, throwaway prototypes, generated code, or repos without a test runner.
---

# Test-Driven Development (TDD)

## Overview

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## When to Use

**Use for app-level code:**
- New features
- Bug fixes
- Refactoring
- Behavior changes

**Skip by default:**
- Dotfiles and configuration files
- Shell scripts and infrastructure
- Throwaway prototypes
- Generated code
- Repositories without a test runner

If the user explicitly wants tests for one of these cases, follow the closest practical red-green loop.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

For app-level production code with a test framework, writing code before the test means restarting from the test. Do not keep prewritten code as a hidden reference unless the user explicitly opts out of TDD for this task.

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
- Output pristine (no errors, warnings)

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
| "Deleting X hours is wasteful" | Sunk cost fallacy. Keeping unverified code is technical debt. |
| "Keep as reference, write tests first" | You'll adapt it. That's testing after. Delete means delete. |
| "TDD will slow me down" | TDD faster than debugging. Pragmatic = test-first. |

## Red Flags - STOP and Start Over

- Code before test
- Test passes immediately (without seeing it fail first)
- Can't explain why test failed
- Rationalizing "just this once"
- "Tests after achieve the same purpose"
- "Already spent X hours, deleting is wasteful"

**All of these mean: stop and restart from the test unless the user explicitly opts out of TDD for this task.**

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
- [ ] Output pristine (no errors, warnings)
- [ ] Tests use real code (mocks only if unavoidable)
- [ ] Edge cases and errors covered

If required boxes are not applicable, say why. If they are applicable and unchecked, restart from the missing red-green step.

## Final Rule

```
App-level production behavior with a test runner -> test exists and failed first
Otherwise -> use the closest practical verification path
```
