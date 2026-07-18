# Godoc

Use Go comments for exported identifiers only.

## Rules

- Start with the item name.
- Use a complete sentence.
- Keep it to one sentence when possible.
- Add a second sentence only for edge cases or errors.
- Do not use JSDoc-style tags.

## Focus On

- Package purpose
- Exported types, functions, methods, and constants
- Non-obvious behavior and errors
- Examples only when they add real value

## Skip

- Unexported identifiers
- Obvious signatures
- Marketing language or implementation detail

## Examples

```go
// Package cache implements an in-memory cache with TTL expiration.
package cache

// NormalizeEmail lowercases and trims whitespace from email.
func NormalizeEmail(email string) string
```
