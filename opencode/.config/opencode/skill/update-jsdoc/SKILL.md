---
name: update-jsdoc
description: Creates or updates JSDoc for JavaScript code. Produces concise documentation with type annotations via @param/@returns. Load when adding, improving, or removing JSDoc comments.
---

# JSDoc Best Practices

JavaScript lacks a type system—use JSDoc to provide **type safety** and document behavior.

## Principles

**Use @param and @returns for types**
In JavaScript, JSDoc annotations provide the type information that's missing:

```javascript
// GOOD - JSDoc provides type safety
/**
 * @param {string} domain - Domain to look up
 * @param {number} [timeoutMs=5000] - Request timeout
 * @returns {Promise<ProductRating|null>}
 */
async function fetchRating(domain, timeoutMs) { }

// BAD - missing type annotations
/**
 * Fetches rating from API
 */
async function fetchRating(domain, timeoutMs) { }
```

**Document intent alongside types**
Explain non-obvious behavior even when types are present:

```javascript
/**
 * Fetches rating, falling back to scraper on API failure.
 * @param {string} domain - Domain to look up (strips protocol if present)
 * @returns {Promise<Rating|null>} Null when domain has no reviews or times out
 */
async function fetchRating(domain) { }
```

**Keep descriptions brief**
One line is usually enough. Two lines max for complex cases.

## When to Skip JSDoc

Skip documentation when:
- Function name is self-explanatory AND types are obvious
- No edge cases or special behavior
- Implementation is trivial

```javascript
// No JSDoc needed - trivial and self-explanatory
function add(a, b) {
  return a + b;
}

// Document this - behavior isn't obvious
/**
 * Rounds towards nearest even number (banker's rounding).
 * @param {number} value
 * @returns {number}
 */
function roundEven(value) { }
```

## Quick Reference

| Element | When to Use | Example |
|---------|-------------|---------|
| `@param` | **Always** in JS - provides type safety | `@param {string} domain Domain to lookup` |
| `@returns` | **Always** in JS - provides type safety | `@returns {Promise<Rating\|null>}` |
| Description | Document intent + edge cases | `/** Fetches rating with scraper fallback. */` |
| `@typedef` | Define object shapes | `@typedef {{id: string, name: string}} User` |
| `@template` | Generic type parameters | `@template T extends Record<string, any>` |

## Template

For public API functions:

```javascript
/**
 * Brief description of purpose/behavior.
 * @param {Type} paramName Description (optional if name is clear)
 * @param {Type} [optionalParam] Optional params in brackets
 * @returns {ReturnType} Description if non-obvious
 */
function functionName(paramName, optionalParam) { }
```

For classes:

```javascript
/**
 * Responsibility/purpose of the class.
 * @implements {InterfaceName}
 */
class ClassName { }
```

## Anti-patterns

- Missing type annotations on params/returns
- Vague descriptions that just restate the function name
- Paragraph-length descriptions
- Documenting private/internal functions unnecessarily
- Using `@description` tag (redundant)

## TypeScript Note

If migrating to TypeScript, types move to the signature. See `update-tsdoc` skill for TypeScript documentation practices.
