---
name: update-pydoc
description: Creates or updates Python docstrings following Google or NumPy style. Produces concise documentation focusing on intent and behavior, not types. Load when adding, improving, or removing Python documentation.
---

# Python Docstring Best Practices

Python has type hints—docstrings should explain **why** and **how**, not **what**.

## Core Principle: Document Behavior, Not Types

With type hints (PEP 484), the signature shows types. Docstrings should explain behavior:

```python
# BAD - repeats type information
"""Fetches a user.

Args:
    user_id: A string representing the user identifier.
    timeout: An integer for the timeout in seconds.

Returns:
    A User object or None if not found.
"""
def fetch_user(user_id: str, timeout: int = 30) -> User | None:
    pass

# GOOD - documents intent and edge cases
"""Fetches user by ID with retry logic on transient failures.

Returns None if user not found or request times out.
"""
def fetch_user(user_id: str, timeout: int = 30) -> User | None:
    pass
```

## Style: Google vs NumPy

Use **Google style** by default (cleaner, more popular):

```python
# Google Style (recommended)
"""Brief description.

Longer description if needed explaining behavior, edge cases,
and any important implementation details worth noting.

Args:
    param_name: Description only if unclear from type/name.
    optional_param: Optional description with default value.

Returns:
    Description of return value, especially non-obvious cases.

Raises:
    ValueError: When and why this is raised.
    TimeoutError: When and why this is raised.
"""

# NumPy Style (use if project convention)
"""Brief description.

Parameters
----------
param_name : type
    Description only if unclear.
optional_param : type, optional
    Description with default.

Returns
-------
type
    Description of return value.

Raises
------
ValueError
    When and why.
"""
```

## When to Include Args/Returns

**Minimal approach:** Only document parameters/returns when unclear:

```python
# Self-explanatory - no Args/Returns section needed
"""Validates email format using regex."""
def validate_email(email: str) -> bool:
    pass

# Document non-obvious parameters
"""Fetches data from cache or source.

Args:
    force_refresh: Ignore cache even if not expired.

Returns:
    Parsed JSON dict, or None if fetch failed.
"""
def fetch_data(key: str, force_refresh: bool = False) -> dict | None:
    pass
```

## Document What Matters

**Intent and behavior:**

```python
"""Normalizes URL by stripping protocol and www prefix.

Force-lowercases the domain for consistent comparison.
"""
def normalize_url(url: str) -> str:
    pass
```

**Edge cases and side effects:**

```python
"""Parses date string using current locale settings.

Note:
    Returns epoch date (1970-01-01) for invalid inputs instead of raising.
    Side effect: Modifies global locale if set_locale=True.
"""
def parse_date(input_str: str, set_locale: bool = False) -> datetime:
    pass
```

## Keep It Brief

- **One-liner** for simple functions
- **Multi-line** only for complex cases
- **Skip Args/Returns** if type hints explain everything
- **Document exceptions** that callers should handle

```python
# One-liner is enough
"""Returns the sum of two integers."""
def add(a: int, b: int) -> int:
    return a + b

# Multi-line for complexity
"""Rounds value to nearest even integer (banker's rounding).

Used in financial calculations to avoid rounding bias.

Args:
    value: Number to round.
    precision: Decimal places (default 0).

Returns:
    Rounded float.
"""
def round_even(value: float, precision: int = 0) -> float:
    pass
```

## Quick Reference (Google Style)

| Section | When to Use | Example |
|---------|-------------|---------|
| One-liner | Most functions | `"""Fetches user by ID."""` |
| Description | Complex behavior | Explain intent, edge cases |
| Args | Unclear params | `user_id: Must be UUID format.` |
| Returns | Non-obvious return | `User object or None if not found.` |
| Raises | Exceptions to handle | `ValueError: If ID malformed.` |
| Note | Important caveats | `Modifies global state.` |
| Example | Complex usage | Show typical usage pattern |

## Template (Google Style)

```python
"""Brief one-line description.

Longer description if behavior needs explanation.

Args:
    param_name: Only document if unclear from name/type.

Returns:
    Description only if non-obvious.

Raises:
    ExceptionName: When and why.
"""
def function_name(param: Type) -> ReturnType:
    pass
```

## Classes

```python
"""Manages connection pool with automatic reconnection.

Attributes:
    max_connections: Maximum concurrent connections allowed.
    retry_attempts: Number of retries before giving up.
"""
class ConnectionPool:
    max_connections: int
    retry_attempts: int = 3
```

## Modules

```python
"""User authentication and authorization module.

Provides functions for login, logout, and permission checking.
"""
```

## Anti-patterns

- Repeating type information in docstrings
- Documenting every single parameter
- Paragraph-length descriptions
- Using `@param` syntax (JSDoc style—wrong for Python)
- Missing docstrings on public modules/classes/functions
- Outdated docstrings that don't match implementation

## Type Hints vs Docstrings

| Element | Type Hint | Docstring |
|---------|-----------|-----------|
| Parameter types | `def f(x: int)` | Skip - already shown |
| Return types | `-> dict` | Skip - already shown |
| Behavior | N/A | Document intent |
| Edge cases | N/A | Document explicitly |
| Examples | N/A | Include if complex |

## Tools

- `pydoc` - View documentation
- `pdoc` / `mkdocstrings` - Generate HTML docs
- `pydocstyle` / `darglint` - Lint docstring style
- `mypy` - Type checking (complements docstrings)

## Legacy Python (pre-3.5)

For code without type hints, include types in Args/Returns:

```python
"""Fetches user by ID.

Args:
    user_id (str): The user identifier.

Returns:
    User or None: User object if found.
"""
def fetch_user(user_id):
    pass
```
