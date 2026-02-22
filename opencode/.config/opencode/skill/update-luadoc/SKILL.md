---
name: update-luadoc
description: Creates or updates LuaDoc/EmmyLua annotations for Lua code. Produces concise documentation with type annotations via EmmyLua format. Load when adding, improving, or removing Lua documentation.
---

# LuaDoc/EmmyLua Best Practices

Lua is dynamically typed—use EmmyLua annotations to provide **type safety** and document behavior.

## Core Principles

**Use EmmyLua for type annotations**
In Lua, EmmyLua provides the type information that's missing:

```lua
---@class User
---@field id string
---@field name string
---@field email string

---Fetches user by ID
---@param id string User identifier
---@return User|nil User object or nil if not found
---@return string|nil Error message if request failed
local function fetchUser(id)
    -- implementation
end
```

**Document intent alongside types**
Explain behavior that isn't obvious from types alone:

```lua
---Normalizes URL by stripping protocol and www prefix
---Returns nil for invalid URLs instead of error
---@param url string Raw URL string
---@return string|nil Normalized URL or nil if invalid
local function normalizeUrl(url)
    -- implementation
end
```

## EmmyLua Syntax

**Functions:**
```lua
---Description of what this does
---@param name Type Description if unclear
---@return ReturnType Description if non-obvious
---@return nil|string Error message on failure (optional second return)
function functionName(param) end
```

**Classes/Tables:**
```lua
---Represents a configuration with validation
---@class Config
---@field timeout number Seconds to wait for response
---@field retries number Max retry attempts
---@field callback function|nil Optional completion handler
local Config = {}
```

**Type aliases:**
```lua
---@alias HttpMethod "GET"|"POST"|"PUT"|"DELETE"
---@alias StatusCode 200|201|400|401|404|500
```

**Generics:**
```lua
---@generic T : table
---@param list T[] Array of items
---@param fn fun(item: T): boolean Filter function
---@return T[] Filtered array
local function filter(list, fn) end
```

## Keep It Brief

- **One line** for the main description
- **Minimal param descriptions** - only when name isn't clear
- **Document behavior, not implementation**

## When to Skip Documentation

```lua
-- Self-explanatory - no docs needed
local function add(a, b)
    return a + b
end

-- Document this - behavior isn't obvious
---Rounds towards nearest even number (banker's rounding)
---@param value number
---@return number
local function roundEven(value) end
```

Skip when:
- Function name and types are fully explanatory
- No edge cases or special behavior
- Implementation is trivial

## Quick Reference

| Annotation | Purpose | Example |
|------------|---------|---------|
| `---@param` | Parameter type | `---@param id string User ID` |
| `---@return` | Return type | `---@return User\|nil` |
| `---@class` | Define class/table | `---@class Config` |
| `---@field` | Class property | `---@field timeout number` |
| `---@type` | Variable type | `---@type string[]` |
| `---@alias` | Type alias | `---@alias Method "GET"\|"POST"` |
| `---@generic` | Generic types | `---@generic T : table` |
| `---@async` | Async function | `---@async` |
| `---@deprecated` | Mark deprecated | `---@deprecated Use fetchUserV2 instead` |

## Template

For public functions:

```lua
---Brief description of purpose/behavior
---@param paramName Type Description if unclear
---@param optionalParam? Type Optional params with ?
---@return ReturnType Description if non-obvious
---@return nil|string Error on failure (Lua convention)
local function functionName(paramName, optionalParam)
    -- implementation
end
```

For classes:

```lua
---Description of class responsibility
---@class ClassName
---@field fieldName Type Description
local ClassName = {}
return ClassName
```

## Anti-patterns

- Missing type annotations on params/returns
- Repeating obvious type info in descriptions
- Paragraph-length descriptions
- Documenting private/internal functions
- Using plain comments instead of EmmyLua annotations

## Lua Conventions

- Multiple returns for errors: `return nil, "error message"`
- Optional params use `?` suffix: `---@param timeout? number`
- Tables are often classes: document their shape with `---@class`
- Functions that can fail: document the error return value
