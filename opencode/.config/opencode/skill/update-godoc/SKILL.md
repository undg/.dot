---
name: update-godoc
description: Creates or updates Go documentation (godoc). Produces concise documentation following Go conventions. Load when adding, improving, or removing Go documentation comments.
---

# Godoc Best Practices

Go documentation is **minimal by design**. A single, complete sentence is usually sufficient.

## Core Principle: Complete Sentence

Godoc comments should be complete sentences that start with the function/type name:

```go
// BAD - incomplete, doesn't start with function name
// Gets user data
func GetUser(id string) (*User, error)

// GOOD - complete sentence starting with function name
// GetUser retrieves a user by their unique identifier.
// Returns ErrNotFound if the user does not exist.
func GetUser(id string) (*User, error)
```

## The Go Way: Less Is More

**Go has strong conventions:**
- **One sentence** is usually enough
- **Two sentences max** for complex cases
- **No special syntax** (unlike JSDoc/TSDoc—no `@param`, `@return`, etc.)
- **Plain text** that godoc extracts automatically

```go
// Package http provides HTTP client and server implementations.
package http

// User represents a registered user in the system.
type User struct {
    ID    string // unique identifier
    Email string // verified email address
}

// Validate checks that the user has required fields populated.
// Returns an error describing what is missing.
func (u *User) Validate() error {
    // implementation
}
```

## Document Exported Items Only

Go's godoc only shows **exported** (capitalized) identifiers:

```go
// GOOD - document exported function
// NormalizeEmail lowercases and trims whitespace from email.
func NormalizeEmail(email string) string

// Don't document unexported functions - not visible in godoc
func validateFormat(email string) bool
```

## What to Document

**Intent and behavior:**

```go
// ProcessQueue handles messages from the queue.
// It blocks until the context is cancelled.
func ProcessQueue(ctx context.Context) error
```

**Edge cases and errors:**

```go
// FetchData retrieves data from the cache or remote source.
// Returns ErrNotFound if data is not available in either location.
func FetchData(key string) ([]byte, error)
```

**Package documentation:**

```go
// Package cache implements an in-memory cache with TTL expiration.
//
// Basic usage:
//
//	c := cache.New(5 * time.Minute)
//	c.Set("key", value)
package cache
```

## When to Skip Documentation

```go
// Self-explanatory - godoc shows the signature
func Add(a, b int) int

// Document this - behavior not obvious
// RoundEven returns the nearest even integer (banker's rounding).
func RoundEven(x float64) float64
```

Skip when:
- Function name and signature are fully explanatory
- No edge cases or special behavior
- Implementation is trivial

## Quick Reference

| Item | Style | Example |
|------|-------|---------|
| Packages | Complete sentence | `Package http provides...` |
| Functions | Start with name | `GetUser retrieves...` |
| Methods | Start with method name | `Validate checks the user's fields...` |
| Types | Start with name | `User represents...` |
| Struct fields | Brief if unclear | `ID string // unique identifier` |
| Constants | Brief description | `StatusOK = 200 // request succeeded` |

## Template

For packages:

```go
// Package name does one thing well.
//
// Longer description if needed, including usage examples.
package name
```

For functions:

```go
// FunctionName does something specific.
// Additional sentence for edge cases or errors.
func FunctionName() error
```

For types:

```go
// TypeName represents/converts/manages something.
type TypeName struct {
    Field Type // brief description if unclear
}
```

## Anti-patterns

- Using JSDoc-style annotations (`@param`, `@return`)
- Paragraph-length descriptions
- Not starting with the function/type name
- Documenting unexported identifiers
- Repeating obvious information from the signature
- Marketing language ("powerful", "flexible", "easy")

## Testing Documentation

Use example functions to show usage:

```go
// ExampleUser_Validate demonstrates validation.
func ExampleUser_Validate() {
    u := &User{ID: "123"}
    if err := u.Validate(); err != nil {
        log.Fatal(err)
    }
    // Output:
}
```

## Tools

- `go doc` - View documentation locally
- `godoc` server - Browse package docs
- `go vet` - Checks for common mistakes
