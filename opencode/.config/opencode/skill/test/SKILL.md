---
name: test
description: Specialized agent for all test-related work (create, update, add tests). Load when writing, modifying, or reviewing tests. Handles test creation, updates, coverage analysis, and best practices for testing across multiple frameworks.
---

# Testing

Handles all test-related work including creating new test files, adding tests to existing files, updating/modifying tests, and ensuring comprehensive test coverage.

## Framework Detection

### FIRST: Check Existing Test Files

Search for existing tests to identify the testing framework:

```bash
glob "**/*.test.*"
glob "**/*.spec.*"
```

Check package.json for test scripts and dependencies.

### Quick Reference: Framework Identification

| Sign                               | Framework    |
| ---------------------------------- | ------------ |
| `*.test.ts`, `vitest.config.*`     | Vitest       |
| `jest.config.*`, `@jest/globals`   | Jest         |
| `playwright.config.*`, `*.spec.ts` | Playwright   |
| `cypress/`, `*.cy.ts`              | Cypress      |
| `pytest.ini`, `conftest.py`        | pytest       |
| `*_test.go`, `go test`             | Go testing   |
| `busted`, `*_spec.lua`             | Busted (Lua) |

### Default: JavaScript/TypeScript

**For JS/TS projects without existing tests:** Use **Vitest** as the default.

Reasons:

- Native ESM/TypeScript support
- Fast execution with Vite
- Jest-compatible API
- Built-in coverage and mocking

## Workflow

Copy this checklist to track progress:

```
- [ ] Step 1: Analyze existing tests and framework
- [ ] Step 2: Understand code under test
- [ ] Step 3: Create/update test structure
- [ ] Step 4: Add comprehensive test cases
- [ ] Step 5: Run tests to verify they pass
- [ ] Step 6: Review for coverage and quality
```

### Step 1: Analyze

- Does a test file already exist for the code?
- What testing framework and patterns are used?
- What functionality needs testing?
- What tests exist (to avoid duplication)?

### Step 2: Understand Code Under Test

Read the implementation thoroughly:

- What are the inputs and outputs?
- What are the edge cases?
- What errors can occur?
- What are the dependencies?

### Step 3: Create/Update Test Structure

**For NEW test files:**

- Match project conventions for naming and organization
- Set up proper imports and configuration
- Create test file structure with describe/it blocks

**For EXISTING test files:**

- Read existing structure thoroughly
- Match patterns, naming conventions, organization
- Preserve existing tests unless asked to modify

### Step 4: Add Test Cases

Cover these scenarios:

| Scenario       | Examples                                      |
| -------------- | --------------------------------------------- |
| Happy path     | Normal inputs, expected outputs               |
| Edge cases     | Empty inputs, boundary values, null/undefined |
| Error handling | Invalid inputs, exceptions, error states      |
| Async behavior | Promises, callbacks, timeouts                 |
| Integration    | Multiple components working together          |

### Step 5: Run and Verify

```bash
npm test
npm run test
yarn test
pnpm test
pytest
go test
make test
```

### Step 6: Review Quality

- Do assertions provide useful failure messages?
- Are tests independent and isolated?
- Is there appropriate coverage?
- Do tests verify behavior, not implementation details?

---

## Best Practices

### Assertion Quality: Optimize for Debugging

**Principle:** Error messages should provide enough context WITHOUT re-running or adding logs.

**Bad - Low information:**

```typescript
expect(someArray.some((item) => item.property === value)).toBe(true)
// Failure: "Expected: true, Received: false" - no context

expect(data).toHaveLength(0)
// Failure: "Expected length: 0, Received: 2" - what's in the array?
```

**Good - High information:**

```typescript
expect(someArray.map((item) => item.property)).toContain(value)
// Failure shows: "Expected array [a, b, c] to contain 'value'"

expect(data).toEqual([])
// Failure shows: "Expected: [], Received: [{...}, {...}]" with actual contents
```

**Guideline:** Prefer assertions that show actual values over boolean/numeric mismatches.

---

### Testing Implementation Details vs Behavior

**The Trade-off:** Exact output tests are specific but brittle.

**When to test exact values:**

- Core business logic (validation rules, calculations)
- Contract/API responses where format matters
- Preventing false positives ("wrong error caught")

**When to test patterns/structure:**

- UI copy/messaging that may evolve
- Implementation details that could be refactored
- When flexibility for improvement is desired

**Best practice:** Test behavior via semantic identifiers:

```typescript
// Brittle - tests presentation
expect(error.message).toBe("User not found in database")

// Resilient - tests behavior
expect(error.code).toBe("USER_NOT_FOUND")
expect(error.severity).toBe("error")
expect(error.message).toBe(dict.en.errorUserNotFound) // if dictionary exist
```

**Ask:** "If I improve this error message next week, should the test break?" If no, don't test exact strings.

---

### Test Scope and Focus

**Principle:** Tests should verify YOUR code, not well-tested dependencies.

**Guidelines:**

- Don't test library behavior (e.g., a mapper with its own tests)
- Don't test framework features (e.g., React hooks, unless testing custom logic)
- Test integration points, not dependency internals

**Ask:** "What would break if I removed this test?" If "nothing in my code," the test adds no value.

---

### Commit Discipline

**Never mix test creation with implementation changes**

- Tests for existing code = separate commit
- New feature + tests for that feature = same commit
- Refactoring existing code = separate commit from tests

**Why:** Easier code review, independent reverts, clean history.

---

### Test Development Process

1. **Understand what to test** - Ask: "What behavior matters? What's already tested?"
2. **One thing at a time** - Focus on one test file, one feature, one concern
3. **Optimize for future maintenance** - Your test will be read when it fails. Write for that moment.

---

## Framework-Specific Patterns

### Vitest (Default for JS/TS)

```typescript
import { describe, it, expect, vi } from "vitest"
import { myFunction } from "./my-module"

describe("myFunction", () => {
  it("should handle normal input", () => {
    const result = myFunction("input")
    expect(result).toBe("expected")
  })

  it("should handle edge cases", () => {
    expect(myFunction("")).toBe("")
    expect(myFunction(null)).toBeNull()
  })
})
```

### Jest

Similar to Vitest, use `jest` global or `@jest/globals` imports.

### pytest (Python)

```python
def test_my_function():
    assert my_function("input") == "expected"

def test_my_function_edge_cases():
    assert my_function("") == ""
    assert my_function(None) is None
```

### Go

```go
func TestMyFunction(t *testing.T) {
    result := MyFunction("input")
    if result != "expected" {
        t.Errorf("MyFunction() = %v, want %v", result, "expected")
    }
}
```

## Commands

| Task              | Command                      |
| ----------------- | ---------------------------- |
| Run all tests     | `npm test`                   |
| Run with coverage | `npm run test:coverage`      |
| Run in watch mode | `npm run test:watch`         |
| Run single file   | `npm test -- my-test.ts`     |
| Run specific test | `npm test -- -t "test name"` |
