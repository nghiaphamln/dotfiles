---
name: test-driven-development
description: Use when implementing app-level features or bugfixes in a repository that has a test framework. Write a failing test first, watch it fail, then write minimal code to pass. SKIP for dotfiles, config files, shell scripts, infrastructure, throwaway prototypes, generated code, or repos without a test runner.
---

# Test-Driven Development

Write the test first. Watch it fail. Write minimal code to pass.

Core principle: if you did not watch the test fail, you do not know if it tests the right thing.

## The Iron Law

```text
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

## When to Use

Use for app-level:

- New features.
- Bug fixes.
- Refactors.
- Behavior changes.

Skip for dotfiles, config files, shell scripts, infrastructure, throwaway prototypes, generated code, and repos without a test runner.

## Red-Green-Refactor

1. RED: write one minimal test for the desired behavior.
2. Verify RED: run it and confirm it fails for the expected reason.
3. GREEN: write the smallest code that makes it pass.
4. Verify GREEN: run the focused test and then the relevant broader suite.
5. REFACTOR: clean up only after tests are green.

## Good Tests

- Clear name.
- One behavior.
- Tests real code.
- Minimal mocks.
- Fails for the intended missing behavior.

## Red Flags

- Code before test.
- Test passes immediately.
- Failure reason is unclear.
- Rationalizing tests-after.
- Avoiding tests because the change is "small".

If a red flag appears, stop and restart with a failing test.
