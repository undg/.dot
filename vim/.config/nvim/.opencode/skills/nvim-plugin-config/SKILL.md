---
name: nvim-plugin-config
description: Configures Neovim plugins in this repo. Load when asked about any Neovim plugin option, config key, or setup — before making any changes.
---

# Neovim Plugin Configuration

Before changing any config option, read the relevant help docs. Never guess config keys.

**Plugin docs** (lazy-managed plugins) — resolve base path first:
```bash
nvim --headless -c "lua print(vim.fn.stdpath('data'))" -c "qa" 2>&1
# then read: <stdpath_data>/lazy/<plugin-name>/doc/
```

**Neovim built-in docs** (vim.lsp, vim.diagnostic, vim.api, etc.) — resolve path first:
```bash
nvim --headless -c "lua print(vim.env.VIMRUNTIME)" -c "qa" 2>&1
# then read: <VIMRUNTIME>/doc/
```
