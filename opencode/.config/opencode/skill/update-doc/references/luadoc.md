# LuaDoc / EmmyLua

Use EmmyLua annotations in Lua to add types and explain behavior.

## Rules

- Annotate public functions, tables, and type aliases.
- Keep the leading description short.
- Use `---@param` and `---@return` for type information.
- Document behavior, failure modes, and optional values.

## Focus On

- Function parameters and return values
- Table shapes and aliases
- Generic helpers
- Error returns in Lua-style APIs

## Skip

- Trivial local helpers
- Repeating obvious type information
- Internal implementation detail

## Example

```lua
---@class User
---@field id string
---@field name string

---Fetches user by ID.
---@param id string User identifier
---@return User|nil User object or nil if not found
local function fetchUser(id)
end
```
