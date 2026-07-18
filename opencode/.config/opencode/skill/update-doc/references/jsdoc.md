# JSDoc

Use JSDoc in JavaScript to provide types and explain behavior.

## Rules

- Include `@param` and `@returns` with types.
- Describe intent, edge cases, and constraints.
- Keep descriptions brief.
- Skip private helpers unless the project documents them.

## Focus On

- Public API functions
- Classes and object shapes
- Optional parameters and return behavior
- Tricky input formats or failure cases

## Skip

- Trivial functions with obvious names and types
- Paragraph-length descriptions
- Redundant implementation notes

## Example

```javascript
/**
 * Fetches rating, falling back to scraper on API failure.
 * @param {string} domain Domain to look up.
 * @returns {Promise<Rating|null>} Null when the domain has no reviews.
 */
async function fetchRating(domain) {}
```
