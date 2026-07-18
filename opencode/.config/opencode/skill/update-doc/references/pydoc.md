# Python Docstrings

Use Python docstrings to explain behavior, side effects, and exceptions.

## Rules

- Prefer Google style unless the project uses NumPy style.
- Document arguments and returns only when they are not obvious.
- Keep the first line short.
- Mention exceptions and side effects when callers need them.

## Focus On

- Public modules, classes, and functions
- Non-obvious defaults or validation
- Error conditions and side effects
- Usage examples for complex APIs

## Skip

- Repeating type hints
- Trivial functions
- Long narrative paragraphs

## Example

```python
"""Fetches user by ID with retry logic on transient failures.

Returns None if the user is not found or the request times out.
"""
def fetch_user(user_id: str, timeout: int = 30) -> User | None:
    pass
```
