# TSDoc

Use TSDoc in TypeScript to explain behavior, not types.

## Rules

- Do not repeat types already present in the signature.
- Use `@param` and `@returns` only when names and types are not enough.
- Keep comments short.
- Document constraints, edge cases, and side effects.

## Focus On

- Public functions and classes
- Parameters with unclear semantics
- Return values that need extra context
- Non-obvious validation or fallback behavior

## Skip

- Obvious signatures
- Type restatements
- Exhaustive parameter docs when only one is unclear

## Example

```typescript
/**
 * Fetches rating, falling back to scraper on API failure.
 * Returns null when the request times out or no reviews exist.
 */
async function fetchRating(domain: string): Promise<Rating | null> {}
```
