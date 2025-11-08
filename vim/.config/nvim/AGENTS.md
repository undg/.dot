# AGENTS.md

## Build/Lint/Test Commands
- Run all tests: `make test`
- Run single test file: `nvim --headless -c "PlenaryBustedFile spec/<filename>.lua"`
- Watch tests: `make test/watch`
- Lint/format: `stylua .`

## Code Style Guidelines
- Language: Lua
- Indentation: Tabs, width 4
- Quote style: AutoPreferDouble
- Line width: 120 characters
- Import style: Use `require()` for modules
- Naming conventions: snake_case for functions and variables
- Error handling: Use `pcall` or `xpcall` for error recovery
- Formatting: Automatic formatting with stylua
- Testing: Use plenary.nvim test framework in `spec/` directory

## Cursor/Copilot Rules
No specific rules found in .cursor/rules or .cursorrules directories.