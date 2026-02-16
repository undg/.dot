---
name: nvim-lsp
description: Configures Neovim LSP using the native vim.lsp.enable API (Neovim 0.11+). Load when working with LSP server configurations, lsp/*.lua files, or vim.lsp.config/setup.
---

# Neovim Native LSP Configuration

Uses the modern native LSP API (Neovim 0.11+).

**Documentation**: https://neovim.io/doc/user/lsp.html

## Project Notes

- **NO typescript servers** in `lsp/` - TypeScript is handled by a separate plugin (typescript-tools or similar)
- Use `lsp/<name>.lua` files on runtimepath for server definitions

## File Structure

```
nvim/
├── lsp/
│   ├── basedpyright.lua    -- Server configs
│   ├── lua_ls.lua
│   └── eslint.lua
├── after/lsp/
│   └── basedpyright.lua    -- Overrides (highest priority)
└── lua/
    └── lsp.lua             -- vim.lsp.enable() calls
```

## Server Config (lsp/<name>.lua)

```lua
return {
    cmd = { 'server-binary', '--stdio' },  -- REQUIRED
    filetypes = { 'python', 'lua' },
    root_markers = { '.git', 'pyproject.toml' },
    -- OR use root_dir callback:
    -- root_dir = function(bufnr, on_dir)
    --     on_dir(vim.fs.root(bufnr, { '.git', 'pyproject.toml' }))
    -- end,
    settings = {
        serverName = {
            -- Server-specific settings
        }
    },
}
```

**Requirements:**
- `cmd`: Explicit command required
- `root_dir` callback: Must call `on_dir(path)`, not return
- `root_markers`: Alternative to root_dir, searches upward for files

## Root Markers

`root_markers` searches upward from buffer for files/directories:

```lua
-- Single marker (first found wins)
root_markers = { '.git', 'package.json' }

-- Nested = equal priority (finds first of group, then next group)
root_markers = { { 'pyproject.toml', 'setup.py' }, '.git' }
-- Searches for pyproject.toml OR setup.py; if neither, searches for .git
```

## Config Loading & Overrides

Configs merge in priority order (later overrides earlier):

1. `vim.lsp.config('*', {...})` -- Global defaults for ALL servers
2. `lsp/<name>.lua` files on runtimepath -- Base server config
3. `after/lsp/<name>.lua` -- Project-specific overrides (plugin configs)
4. `vim.lsp.config('name', {...})` in init.lua -- Final overrides

Merge uses `vim.tbl_deep_extend('force', ...)` - later values override earlier.

### Examples

**Base config** (`lsp/lua_ls.lua`):
```lua
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.git' },
}
```

**Override** (`after/lsp/lua_ls.lua`):
```lua
return {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' }
        }
    }
}
```

**Runtime override** (init.lua):
```lua
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = { checkThirdParty = false }
        }
    }
})
```

## Enable Servers

In `lua/lsp.lua`:

```lua
-- Define or extend configs
vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            semanticTokens = { multilineTokenSupport = true }
        }
    }
})

-- Enable servers
vim.lsp.enable({
    'basedpyright',
    'lua_ls',
    'eslint',
    -- NO typescript here - handled by separate plugin
})
```

## Verification

```vim
:checkhealth vim.lsp
:lua =vim.lsp.get_clients()
:lua =vim.lsp.config['servername']  -- View merged config
```

## Common Issues

- **Missing `cmd`**: Server won't start
- **root_dir signature**: Use `function(bufnr, on_dir)` and call `on_dir(path)`
- **Wrong settings key**: Match exact server name (e.g., `basedpyright` not `pyright`)
