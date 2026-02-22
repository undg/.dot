---
name: update-tsdoc
description: Creates or updates TSDoc for TypeScript code. Produces concise documentation that focuses on non-obvious behavior and intent—NOT types. Load when adding, improving, or removing TSDoc comments in TypeScript files.
---

# TSDoc Best Practices

**TypeScript provides types—TSDoc explains *why*, not *what*.**

Unlike JSDoc in JavaScript, TSDoc should **never** duplicate type information. Types are visible in the signature; documentation should explain behavior, intent, and edge cases.

## Core Principle: Don't Document Types

TypeScript already shows types. Repeating them wastes space:

```typescript
// BAD - redundant type documentation
/**
 * @param domain - The domain string to look up
 * @returns Promise containing rating or null
 */
async function fetchRating(domain: string): Promise<Rating | null>

// GOOD - documents intent and edge cases
/**
 * Fetches rating, falling back to scraper on API failure.
 * Returns null when domain has no reviews or request times out.
 */
async function fetchRating(domain: string): Promise<Rating | null>
```

## When to Use @param and @returns

**Only when names/types don't tell the full story:**

```typescript
/**
 * Validates email format.
 * @param email Must include domain with TLD (e.g., "user@example.com")
 * @returns Normalized email (lowercase, trimmed), or null if invalid
 */
function validateEmail(email: string): string | null

// Self-explanatory - no TSDoc needed
function add(a: number, b: number): number
```

**When @param Adds Value**

Add `@param` when the description conveys information not visible in the type signature:

```typescript
// Type shows "string", but format is unclear from signature alone
parseDate("2023-01-15") // What formats are valid?
```

Use `@param` for semantic information:
- **Specific formats:** date patterns, regex expectations, path formats
- **Constraints:** allowed ranges, enum values, validation rules
- **Boolean semantics:** clarifying what true/false means for ambiguous flags
- **Complex objects:** shape expectations when type is generic (e.g., `Record<string, any>`)

## Document What Matters

**Intent and behavior:**

```typescript
/** Milliseconds between retry attempts. Doubles after each failure. */
retryDelayMs: number

/** Strips protocol and www prefix, forces lowercase. */
normalizeUrl(url: string): string
```

**Edge cases and constraints:**

```typescript
/**
 * Parses date from string.
 * @param input ISO 8601 date ("2023-01-15") or Unix timestamp
 * Returns epoch (1970-01-01) for invalid dates instead of throwing.
 */
parseDate(input: string): Date
```

## Keep It Brief

- **One line** is usually enough
- **Two lines max** for complex cases
- No paragraph-length descriptions

## When to Skip TSDoc

```typescript
// Self-explanatory - skip it
function add(a: number, b: number): number
function getUserById(id: string): User | undefined

// Document this - behavior not obvious from signature
/** Rounds towards nearest even number (banker's rounding). */
function roundEven(value: number): number
```

Skip when:
- Name and types are fully explanatory
- No edge cases or special behavior
- Implementation is obvious

## Quick Reference

| Element | When to Document | Example |
|---------|------------------|---------|
| Functions | Intent + edge cases | `/** Fetches rating with scraper fallback. */` |
| Classes | Responsibility | `/** Manages caching with TTL and size limits. */` |
| Properties | Purpose + units/constraints | `/** Max requests per minute. */` |
| `@param` | Only if unclear | `@param includeArchived Include soft-deleted items.` |
| `@returns` | Only if non-obvious | `@returns Null if cache miss.` |
| `@template` | Constraints on generics | `@template T Must be JSON-serializable.` |

## Template

```typescript
/** One-line description of purpose/behavior. */
export class ClassName { }

/**
 * Brief description.
 * Only use @param/@returns when names/types don't explain behavior.
 */
function functionName(): ReturnType { }
```

## Anti-patterns

- Repeating type information (`@param x - A string value`)
- Documenting every parameter (just the unclear ones)
- Paragraph-length descriptions
- Implementation details (`// Uses binary search`)
- `@description` tag (redundant)

## Migration from JSDoc

If converting from JavaScript with JSDoc:
1. Remove all type annotations from JSDoc (`@param {Type}`)
2. Move types to TypeScript signatures
3. Keep only descriptions that explain behavior/intent
4. Remove `@param`/`@returns` if the signature is clear
