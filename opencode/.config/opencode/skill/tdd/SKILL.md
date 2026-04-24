---
name: tdd
description: Testing and test-driven development. Use for any testing work: creating, updating, reviewing, or debugging tests, improving coverage, or building features and fixes with red-green-refactor.
---

# Testing and TDD

This skill covers both general testing work and test-driven development.

Use general testing mode when creating, updating, reviewing, debugging, or extending tests in existing code.

Use TDD mode when building or changing behavior test-first with red-green-refactor.

## Philosophy

**Core principle**: Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_ it does it. A good test reads like a specification - "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means (like querying a database directly instead of using the interface). The warning sign: your test breaks when you refactor, but behavior hasn't changed. If you rename an internal function and tests fail, those tests were testing implementation, not behavior.

See [tests.md](tests.md) for cross-language examples and [mocking.md](mocking.md) for mocking guidelines.

## Framework and Language Guidance

- Match the test framework already used by the project.
- For JavaScript and TypeScript projects without an established framework, prefer Vitest over Jest.
- Do not force JavaScript testing patterns onto other languages. Keep the core principle the same: test behavior through public interfaces.
- Use the language's standard testing tools and idioms unless the project already established something else.

### Framework Detection

First, inspect the repo before writing tests:

```bash
glob "**/*.test.*"
glob "**/*.spec.*"
```

Also inspect the project's test scripts, config files, and existing test layout.

Quick reference:

| Sign                               | Framework    |
| ---------------------------------- | ------------ |
| `*.test.ts`, `vitest.config.*`     | Vitest       |
| `jest.config.*`, `@jest/globals`   | Jest         |
| `playwright.config.*`, `*.spec.ts` | Playwright   |
| `cypress/`, `*.cy.ts`              | Cypress      |
| `pytest.ini`, `conftest.py`        | pytest       |
| `*_test.go`, `go test`             | Go testing   |
| `busted`, `*_spec.lua`             | Busted (Lua) |

When a test file already exists, match its structure, naming, and helper patterns unless there is a strong reason to improve them.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This is "horizontal slicing" - treating RED as "write all tests" and GREEN as "write all code."

This produces **crap tests**:

- Tests written in bulk test _imagined_ behavior, not _actual_ behavior
- You end up testing the _shape_ of things (data structures, function signatures) rather than user-facing behavior
- Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine
- You outrun your headlights, committing to test structure before understanding the implementation

**Correct approach**: Vertical slices via tracer bullets. One test → one implementation → repeat. Each test responds to what you learned from the previous cycle. Because you just wrote the code, you know exactly what behavior matters and how to verify it.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

### Two Modes

Choose mode based on task:

- General testing mode: existing tests, flaky tests, CI failures, coverage gaps, test reviews, adding tests around existing code
- TDD mode: new behavior or changed behavior built test-first in red-green-refactor slices

General testing mode still uses the same core principles: test behavior through public interfaces, mock system boundaries only, keep assertions high-signal.

### General Testing Workflow

When task is not strict TDD:

- [ ] Check what test framework and conventions the repo already uses
- [ ] Read code under test and nearby tests
- [ ] Identify highest-value behaviors to verify
- [ ] Add or update tests using existing conventions
- [ ] Run narrowest useful test command first
- [ ] Review failures, flakiness, and assertion quality

### 1. Planning

Before starting TDD work:

- [ ] Check what test framework and conventions the repo already uses
- [ ] Read the code under test and existing tests around it
- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for [deep modules](deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](interface-design.md)
- [ ] List the behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

When not doing TDD, ask instead: "What behavior matters here, and what is already covered?"

### 2. Tracer Bullet

Write ONE test that confirms ONE thing about the system:

```
RED:   Write test for first behavior → test fails
GREEN: Write minimal code to pass → test passes
```

This is your tracer bullet - proves the path works end-to-end.

### 3. Incremental Loop

For each remaining behavior:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:

- One test at a time
- Only enough code to pass current test
- Don't anticipate future tests
- Keep tests focused on observable behavior

When working in an existing test file:

- Preserve existing tests unless the task requires changing them
- Match the local naming and organizational style
- Avoid duplicating behaviors that are already covered

### 4. Refactor

After all tests pass, look for [refactor candidates](refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

### 5. Verify

Run the narrowest useful test command first, then broaden if needed.

Common commands:

| Task              | Command                      |
| ----------------- | ---------------------------- |
| Run all tests     | `npm test`                   |
| Run with coverage | `npm run test:coverage`      |
| Run in watch mode | `npm run test:watch`         |
| Run single file   | `npm test -- my-test.ts`     |
| Run specific test | `npm test -- -t "test name"` |
| Python tests      | `pytest`                     |
| Go tests          | `go test ./...`              |
| Project wrapper   | `make test`                  |

Prefer the repo's standard command over a generic one when both exist.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```

## Assertion Quality

Optimize assertions for debugging. Failures should show enough context that you do not need to re-run with extra logging.

Prefer assertions that expose actual values over boolean or length-only mismatches.

```typescript
expect(someArray.map((item) => item.property)).toContain(value)
expect(data).toEqual([])
```

Avoid low-information assertions when a richer one is available.

```typescript
expect(someArray.some((item) => item.property === value)).toBe(true)
expect(data).toHaveLength(0)
```

When deciding how specific to be, ask: "If this message or representation improves next week, should the test break?" Use exact assertions for business rules and contracts. Use semantic assertions when presentation can evolve.

## Scope and Focus

- Test your code, not the internals of well-tested dependencies.
- Test integration points, not framework behavior.
- If removing a test would not reduce confidence in your code, the test likely adds little value.
