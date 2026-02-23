# AGENTS.md

Guidance for agentic coding work in this repo.
Keep changes minimal, follow existing Lua conventions, and prefer tooling noted below.

## Sources of truth
- `Makefile`: test targets and single-test helpers.
- `.stylua.toml`: formatting rules.
- `README.md`: testing overview.
- No Cursor/Copilot rules found in `.cursor/rules`, `.cursorrules`, or `.github/copilot-instructions.md`.

## Build / Lint / Test
- Run all tests: `make test`
- Watch all tests: `make test/watch` (requires `entr`)
- Watch a single test file (interactive): `make test/watch/file` (requires `fzf` and `entr`)
- Run a single test file directly:
  - `nvim --headless -c "PlenaryBustedFile spec/<file>.lua"`
  - Example: `nvim --headless -c "PlenaryBustedFile spec/utils/tbl_spec.lua"`
- Run all tests directly: `nvim --headless -c "PlenaryBustedDirectory spec/"`
- Format/Lint Lua: `stylua .`

Notes:
- Tests use plenary.nvim (see `spec/`).
- `make` targets call headless Neovim; ensure `nvim` is on PATH.
- `entr` and `fzf` are optional helpers for watch flows.

## External tooling
- Required: `nvim`, `make`, `stylua`.
- Optional: `entr` (watch), `fzf` (interactive selection).
- Keep tooling versions consistent with local environment defaults.

## Repo layout (high level)
- `lua/`: Neovim configuration modules.
- `lua/plugins/`: plugin specs and configuration.
- `lua/utils/`: shared helpers (tables, strings, keymaps, paths).
- `lua/keymap/`: keymap definitions.
- `spec/`: tests (plenary busted).

## Formatting
- Use Stylua; do not hand-format against `.stylua.toml`.
- Indentation: tabs, width 4.
- Line endings: Unix (LF).
- Max line width: 120.
- Quote style: AutoPreferDouble (Stylua chooses; avoid manual churn).
- Call parentheses: Always.
- Avoid trailing whitespace.
- Keep alignment simple; don't overuse manual column alignment.

## Strings and long lines
- Prefer `[[...]]` for multi-line strings.
- Avoid manual wrapping; keep lines under 120 when reasonable.
- Do not reflow long comment blocks unless editing that area.

## Imports and module structure
- Group `require()` calls at the top of the file.
- Prefer protected requires for optional deps:

```lua
local ok, mod = pcall(require, "module")
if not ok then
  vim.notify("missing module: module", vim.log.levels.ERROR)
  return
end
```

- Module pattern: `local M = {}` then `return M`.
- Keep module names in sync with file paths, e.g. `require("utils.tbl")`.
- Avoid global variables; prefer locals and module exports.

## Naming conventions
- Use `snake_case` for functions and variables.
- Module tables are typically `M`.
- File names in `lua/plugins/` may include dashes; require strings should match.
- Prefer descriptive keymap `desc` fields.

## Types and documentation
- Use EmmyLua annotations for public helpers:
  - `---@param`, `---@return`, `---@generic`.
- Use triple-dash `---` doc comments for functions.
- Keep comments focused on non-obvious behavior; avoid restating code.

## Error handling and notifications
- Wrap optional `require()` calls with `pcall`.
- Report missing dependencies with `vim.notify(..., vim.log.levels.ERROR)`.
- Return early when prerequisites are missing.
- Prefer `pcall`/`xpcall` around risky calls rather than global error traps.

## Logging and debugging
- Prefer `vim.notify` for user-visible errors and warnings.
- Use `vim.log.levels` for severity.
- Avoid noisy debug output in normal workflows.

## Tables and utility patterns
- Prefer pure functions in `lua/utils/` and return new tables.
- For table transforms, follow patterns in `lua/utils/tbl.lua`.
- Validate input types and notify on misuse when helpful.
- Avoid mutating input tables unless the function name implies it.

## Keymaps
- Use the helper in `lua/utils/keymap.lua` (`Keymap.normal/insert/visual/xisual`).
- Keep mappings deterministic; avoid side effects in key handlers unless needed.
- Provide `desc` for discoverability when possible.

## Neovim options and globals
- Use `vim.opt` and `vim.o` for options; avoid raw `set` commands.
- Use `vim.g` only for true globals and provider toggles.
- Prefer local variables over globals.
- Keep `vim.g.format_on_save` and similar flags documented near use.

## Plugins and configuration
- Plugin specs live in `lua/plugins/*.lua`.
- Configuration blocks typically use `pcall` to guard `require()`.
- Return a plugin spec table from each plugin module.
- Keep plugin commits/branches explicit if pinned.
- Use `dependencies` blocks to express plugin order.
- Keep comments short and practical (what and why).

## Testing guidelines
- Tests live under `spec/` and use plenary busted.
- Name test files with `_spec.lua`.
- Keep tests deterministic and isolated.
- Prefer file-level tests; avoid inter-test state leaks.

## Single-test tips
- Use `make test/watch/file` to pick a spec via fzf.
- Keep spec files under `spec/` path.
- Use `PlenaryBustedFile` for faster iteration.

## Example module pattern

```lua
local M = {}

---@param input_table table
---@return table
function M.example(input_table)
  return input_table
end

return M
```

## Workflow expectations
- Avoid changing unrelated files.
- Follow existing patterns in nearby files.
- If adding a new module, update any central loader if required.
- Keep diffs focused; do not reformat unrelated code.

## LSP Configuration (vim.lsp, Neovim 0.11+)

- **Error messages are misleading**: "method textDocument/hover is not supported" usually means the server failed to start (missing config file), not that the server lacks hover capability.
- **Server list and config files must stay in sync**: `lsp_servers` array in `lua/lsp.lua` must have matching files in `lsp/` directory; drift causes silent failures.
- **Names must match exactly**: Server name in `vim.lsp.enable("name")` must match the filename `lsp/name.lua` (e.g., `cssls` → `lsp/cssls.lua`).
- **Check server health**: Run `:checkhealth vim.lsp` to verify configs load correctly; `:lua =vim.lsp.config['servername']` shows merged config.

## Cursor/Copilot rules
- No additional rules found in `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md`.
