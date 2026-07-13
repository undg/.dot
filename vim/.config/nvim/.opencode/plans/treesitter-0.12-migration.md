# Tree-sitter 0.12 Migration Audit — Plan

Branch: `TBD`

---

## Goal

Reset this config onto the Neovim 0.12 native Tree-sitter path first. Then reintroduce only the extra features that still matter, one by one, with clear documentation and old code kept as reference.

---

## General Instructions

Start from a minimal 0.12-native base.

Do not preserve an old Tree-sitter integration just because it used to work.

For every feature:

- document old behavior
- document old config snippet
- decide: keep, replace, downgrade, remove
- test the exact user-facing behavior after the change

Do not delete old behavior without writing down what it did first.

---

## Baseline Feature Inventory

Document these before changing behavior:

- markdown rendering in `.md` files
- syntax highlighting in common languages
- fenced-code-block language injections inside markdown
- code commenting in mixed-language files like TSX/JSX/HTML
- folds
- textobjects
- incremental selection
- symbol/reference illumination
- embedded language support
- test discovery / test navigation if Tree-sitter affects it
- big-file behavior when Tree-sitter is disabled

For each item, record:

- where it is configured
- what plugin or built-in feature provides it
- what breaks today on 0.12
- how to manually verify it later

### Captured Baseline Notes

Captured on 2026-07-13 from current local config plus headless open tests.

| Feature | Current behavior on 0.12 | What breaks today | Manual verification |
| --- | --- | --- | --- |
| Markdown rendering in `.md` files | Broken on markdown open. `render-markdown.nvim` loads and hits Tree-sitter injection/query path. | Opening `README.md` and `AGENTS.md` throws `attempt to call method 'range' (a nil value)` from `vim.treesitter.get_range` via `nvim-treesitter/query_predicates.lua` and `render-markdown/request/view.lua`. | Open `README.md` and `AGENTS.md` without errors. Confirm rendered headings, bullets, checkboxes, and code blocks still display acceptably. |
| Syntax highlighting in common languages | Minimal native base works for Lua. Markdown is intentionally skipped for now. | `vim.treesitter.start()` works for `lua/plugins/treesitter.lua`. Plain markdown Tree-sitter start still crashes, so markdown cannot yet be counted as working syntax-highlight coverage. | Open `lua/plugins/treesitter.lua`, `lua/autocmd.lua`, and later one parser-backed non-Lua file if available. Confirm no Tree-sitter errors and visible highlighting. |
| Fenced-code-block language injections inside markdown | Broken. Disabling `render-markdown.nvim` was not enough; plain markdown Tree-sitter start still crashes. Repo markdown files contain fenced blocks (`README.md`, `AGENTS.md`). | Same `node:range()` crash still occurs in injection parsing path when `vim.treesitter.start()` runs on markdown. | Open `README.md` and `AGENTS.md` with markdown Tree-sitter disabled for now. Re-test later after markdown parser/query strategy changes. |
| Code commenting in mixed-language files like TSX/JSX/HTML | Not verified in this repo. No TSX/JSX fixture file exists here. Old behavior is clearly configured. | Unknown runtime state today. Risk remains because commentstring depends on `nvim-ts-context-commentstring` + Tree-sitter context queries. | Use a TSX or HTML buffer and run `gcc` on JS, JSX, and HTML regions. Confirm comment delimiters switch correctly. |
| Folds | Configured through `nvim-ufo` with Tree-sitter first, indent fallback second. Not directly tested yet. | No direct error captured yet. Risk is medium because provider order prefers Tree-sitter. | Open a structured Lua or Go/TypeScript file, run fold motions, and inspect `UfoInspect` if needed. |
| Textobjects | Configured, not verified. No direct failure captured yet. | Unknown runtime state today. Depends on `nvim-treesitter-textobjects`. | In a Lua file, test `af`, `if`, `ac`, `ic`, `ab`, `ib`, `]]`, `[[`, `][`, `[]`, `]v`, `[m`, `]V`, `[M`. |
| Incremental selection | Configured, not verified. | Unknown runtime state today. Depends on old `nvim-treesitter` module. | In a Lua file, test `vn`, repeated `vn`, `vnm`, and `vm`. |
| Symbol/reference illumination | Likely still functional because provider order is `lsp`, `treesitter`, `regex`, but not verified. | Unknown whether Tree-sitter provider itself is healthy. | Put cursor on a repeated symbol in a Lua file with or without LSP attached. Confirm references illuminate and no errors appear. |
| Embedded language support | `otter.nvim` is installed but no usage was found in this repo. | Unknown. No fixture and no local callsites beyond plugin declaration. | If you actually use `otter.nvim`, open the real target buffer type and verify embedded language features there. |
| Test discovery / test navigation if Tree-sitter affects it | `neotest` is configured and depends on `nvim-treesitter`, but repo has no JS/TS test project fixture for `neotest-vitest`. | Unknown in this repo. Dependency is present; actual breakage not reproduced here. | Open a real Vitest project file and run `ttr`, `ttf`, `ttj`, `ttk`. |
| Big-file behavior when Tree-sitter is disabled | Clearly configured by `bigfile.nvim`. Tree-sitter, illuminate, and ufo detachment are part of the big-file path. Not executed here. | No direct breakage observed. Migration must preserve disable path semantics. | Open or simulate a file over configured threshold and confirm `treesitter`, `illuminate`, and `ufo` are disabled cleanly. |

### Baseline Verification Fixtures

- `README.md`: real markdown file with fenced `bash` blocks; currently crashes on open.
- `AGENTS.md`: real markdown file with fenced `lua` blocks; currently crashes on open.
- `lua/plugins/treesitter.lua`: real Lua file; headless open produced no Tree-sitter crash.
- `lua/autocmd.lua`: real Lua file for later fold/highlight/manual checks.
- No repo-local `ts`, `tsx`, `js`, `jsx`, or `go` fixture files were found, so mixed-language comment, folds in TS/Go, and `neotest-vitest` verification need either a scratch buffer or a real external project.

### Exact Old Config Ownership

| Feature | File | Provider | Critical options / notes |
| --- | --- | --- | --- |
| Markdown rendering in `.md` files | `lua/plugins/render-markdown-nvim.lua` | `MeanderingProgrammer/render-markdown.nvim` | Explicit dependency on `nvim-treesitter/nvim-treesitter`; `ft = { "markdown" }`; `render_modes = { "n", "c", "t" }`; custom heading, code, bullet, checkbox rendering. |
| Syntax highlighting | `lua/plugins/treesitter.lua` | old `nvim-treesitter`, now migrating to built-in `vim.treesitter.start()` | Old config used `highlight.enable = true`; `use_languagetree = true`; `additional_vim_regex_highlighting = false`; plugin was pinned to commit `42fc28ba918343ebfd5565147a42a26580579482`. |
| Parser install / auto-install | `lua/plugins/tree-sitter-manager.lua` and `lua/plugins/treesitter.lua` | `tree-sitter-manager.nvim` plus `nvim-treesitter` build/install hooks | `ensure_installed` contains `bash`, `css`, `go`, `html`, `javascript`, `json`, `lua`, `markdown`, `markdown_inline`, `python`, `toml`, `tsx`, `typescript`, `yaml`; `auto_install = true`; plugin note says CLI must be installed system-wide. |
| Fenced-code-block injections in markdown | `lua/plugins/treesitter.lua` and `lua/plugins/render-markdown-nvim.lua` | `nvim-treesitter` query/injection path used by render-markdown | `highlight.use_languagetree = true`; markdown renderer depends directly on Tree-sitter; current crash stack passes through injection parsing. |
| Mixed-language commenting | `lua/plugins/comment.lua` and dependency declared in `lua/plugins/treesitter.lua` | `Comment.nvim` + `nvim-ts-context-commentstring` | `pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()`. |
| Folds | `lua/plugins/nvim-ufo.lua`; old commented fallback in `lua/config.lua` | `nvim-ufo` with Tree-sitter first, indent second | `provider_selector = function(...) return { "treesitter", "indent" } end`; `close_fold_kinds_for_ft.default = { "import_statement" }`; old `nvim_treesitter#foldexpr()` comment remains in `lua/config.lua`. |
| Textobjects | `lua/plugins/treesitter.lua` | `nvim-treesitter-textobjects` | `select.enable = true`; `lookahead = true`; captures for function/class/code_block; move mappings `]]`, `[[`, `][`, `[]`, `]v`, `[m`, `]V`, `[M`. |
| Incremental selection | `lua/plugins/treesitter.lua` | `nvim-treesitter` module | `enable = true`; keymaps `vn`, `vnm`, `vm`. |
| Rainbow delimiters-style highlighting | `lua/plugins/treesitter.lua` | old `rainbow` module under current Tree-sitter setup | `enable = true`; `extended_mode = true`; not part of original checklist, but it is another Tree-sitter-dependent feature worth remembering. |
| Symbol/reference illumination | `lua/plugins/illuminate.lua` | `RRethy/vim-illuminate` | Providers ordered as `lsp`, `treesitter`, `regex`; Tree-sitter is not the only provider. |
| Embedded language support | `lua/plugins/otter-nvim.lua` | `jmbuhr/otter.nvim` | Only explicit config is dependency on `nvim-treesitter/nvim-treesitter`; no repo callsites found. |
| Test discovery / navigation | `lua/plugins/neotest.lua` | `neotest` + `neotest-vitest` | Explicit dependency on `nvim-treesitter/nvim-treesitter`; keymaps `ttr`, `ttf`, `ttw`, `tts`, `ttl`, `tto`, `ttO`, `ttt`, `ttj`, `ttk`. |
| Big-file Tree-sitter disable path | `lua/plugins/bigfile.lua` | `LunarVim/bigfile.nvim` | Disables `treesitter`, `illuminate`, `matchparen`; custom feature disables `ufo` and sets `foldmethod = "manual"`. |
| Tree-sitter error suppression hack | `lua/autocmd.lua` | local patch over `vim.api.nvim_buf_set_extmark` | Suppresses only `Invalid 'col': out of range`; does not address current `node:range()` crash. |

---

## Old Config Reference

Keep these snippets as reference while rebuilding.

### `lua/plugins/treesitter.lua`

```lua
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	dependencies = {
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
	},
	lazy = false,
	commit = "42fc28ba918343ebfd5565147a42a26580579482",
	build = ":TSUpdate",
	config = function()
		local ts_configs_ok, ts_configs = pcall(require, "nvim-treesitter")
		local not_ok = not ts_configs_ok and "nvim-treesitter" or false
		if not_ok then
			vim.notify("plugins/treesitter.configs.lua: missing requirements " .. not_ok, vim.log.levels.ERROR)
			return
		end

		ts_configs.setup({
			modules = {},
			ignore_install = {},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				use_languagetree = true,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "vn",
					node_incremental = "vn",
					scope_incremental = "vnm",
					node_decremental = "vm",
				},
			},
			indent = {
				enable = true,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ab"] = "@code_block.outer",
						["ib"] = "@code_block.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]]" ] = "@function.outer",
						["]v"] = "@class.outer",
					},
					goto_previous_start = {
						["[["] = "@function.outer",
						["[m"] = "@class.outer",
					},
					goto_next_end = {
						["]["] = "@function.outer",
						["]V"] = "@class.outer",
					},
					goto_previous_end = {
						["[]"] = "@function.outer",
						["[M"] = "@class.outer",
					},
				},
			},
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			},
		})
	end,
}
```

### `lua/plugins/tree-sitter-manager.lua`

```lua
return {
	"romus204/tree-sitter-manager.nvim",
	config = function()
		require("tree-sitter-manager").setup({
			ensure_installed = {
				"bash",
				"css",
				"go",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"toml",
				"tsx",
				"typescript",
				"yaml",
			},
			border = "rounded",
			auto_install = true,
			highlight = true,
		})
	end,
}
```

### `lua/plugins/comment.lua`

```lua
require("Comment").setup({
	pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
```

### `lua/plugins/render-markdown-nvim.lua`

```lua
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {
		file_types = { "markdown" },
		render_modes = { "n", "c", "t" },
		anti_conceal = { enabled = false },
		win_options = {
			concealcursor = { rendered = "n" },
		},
	},
	ft = { "markdown" },
}
```

### `lua/plugins/nvim-ufo.lua`

```lua
require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
})
```

### `lua/plugins/illuminate.lua`

```lua
illuminate.configure({
	providers = {
		"lsp",
		"treesitter",
		"regex",
	},
})
```

### `lua/plugins/neotest.lua`

```lua
dependencies = {
	"nvim-neotest/nvim-nio",
	"nvim-lua/plenary.nvim",
	"antoinemadec/FixCursorHold.nvim",
	"nvim-treesitter/nvim-treesitter",
	"marilari88/neotest-vitest",
}
```

### `lua/plugins/otter-nvim.lua`

```lua
return {
	"jmbuhr/otter.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
}
```

### `lua/plugins/bigfile.lua`

```lua
features = {
	"lsp",
	"treesitter",
	"illuminate",
	"indent_blankline",
}
```

### `lua/autocmd.lua`

```lua
local ts_ok = pcall(function()
	local ts_hl = require("vim.treesitter.highlighter")
	if ts_hl and ts_hl.active then
		local orig_nvim_buf_set_extmark = vim.api.nvim_buf_set_extmark
		vim.api.nvim_buf_set_extmark = function(...)
			local ok, result = pcall(orig_nvim_buf_set_extmark, ...)
			if not ok then
				local err = tostring(result)
				if not err:match("Invalid 'col': out of range") then
					error(result)
				end
			end
			return ok and result or nil
		end
	end
end)
```

---

## Keep / Replace / Remove Decision Table

Fill this in during execution.

| Feature | Old provider | 0.12-native replacement? | Decision | Verification |
| --- | --- | --- | --- | --- |
| Markdown rendering | `render-markdown.nvim` + old TS query path | likely yes, with reduced coupling | temporary remove during migration | open markdown with fenced code blocks |
| Syntax highlight | `nvim-treesitter` | likely built-in `vim.treesitter` | partial keep via native start except markdown | open representative files |
| Parser install | `tree-sitter-manager.nvim` | maybe keep separate | partial keep as parser installer only | parser available for key filetypes |
| Commentstring | `nvim-ts-context-commentstring` | maybe no direct core replacement | pending | comment TSX/JSX/HTML blocks |
| Folds | `nvim-ufo` treesitter provider | maybe indent/LSP fallback | temporary replace with `lsp` + `indent` | inspect fold open/close behavior |
| Textobjects | `nvim-treesitter-textobjects` | maybe no core replacement | pending | test mappings |
| Incremental selection | `nvim-treesitter` module | maybe no core replacement | pending | test `vn` / `vm` / `vnm` |
| Illuminate references | `vim-illuminate` TS provider | maybe LSP+regex only | temporary replace with `lsp` + `regex` | cursor on symbol |
| Embedded languages | `otter.nvim` + TS | unclear | pending | test markdown/quarto-like buffer |
| Neotest parsing | `neotest` + TS dep | unclear | pending | run nearest/file test |

---

## Migration Strategy

### Phase 1: Capture baseline

- [x] **Record current behavior for every Tree-sitter-dependent feature**
  - Write short notes for what works, what is broken, and how to test it later.

- [x] **Record exact old config ownership for each feature**
  - Map feature -> file -> plugin -> critical options.

### Phase 2: Reset to 0.12-native base

- [x] **Remove old Tree-sitter coupling from the markdown rendering path first**
  - Goal: stop `node:range()` crashes from old `query_predicates.lua` behavior.
  - 2026-07-13 result: set `enabled = false` in `lua/plugins/render-markdown-nvim.lua`.
  - Headless verification: `nvim --headless "+edit README.md" "+sleep 500m" +qa` and same for `AGENTS.md` both completed with no crash.
  - Conclusion: current markdown crash path is specifically tied to `render-markdown.nvim` using the old `nvim-treesitter` query/injection stack on Neovim 0.12.

- [x] **Build a minimal Neovim 0.12-native Tree-sitter base**
  - Use built-in `vim.treesitter` behavior first.
  - Avoid old plugin-specific query/runtime assumptions.
  - 2026-07-13 result: replaced `nvim-treesitter.setup()` module config in `lua/plugins/treesitter.lua` with a minimal `FileType` autocmd that calls `vim.treesitter.start(bufnr)`.
  - Kept `nvim-treesitter` plugin only as parser/query runtime while migrating.
  - Markdown is temporarily excluded from native start because plain markdown Tree-sitter still crashes on 0.12 in current parser/query state.

- [x] **Verify the clean base before reintroducing extras**
  - Confirm no markdown crash.
  - Confirm basic parsing/highlighting in representative languages.
  - 2026-07-13 verification: headless opens for `README.md`, `AGENTS.md`, and `lua/plugins/treesitter.lua` completed cleanly after excluding markdown from `vim.treesitter.start()`.
  - Limit: markdown currently opens without Tree-sitter highlighting because markdown filetype is intentionally skipped in the native base.

### Phase 3: Reintroduce missing features one by one

- [ ] **Reintroduce parser management only if the native base still needs external install workflow**
  - Keep `tree-sitter-manager.nvim` only if it still adds real value.
  - 2026-07-13 result: kept it only for parser installation and removed its stale `highlight = true` option so it no longer implies plugin-managed highlighting.

- [ ] **Reintroduce commentstring support if mixed-language commenting is lost**
  - Test TSX, JSX, HTML, markdown code regions if relevant.

- [ ] **Reintroduce folds in the safest order: indent, LSP, then Tree-sitter if still needed**
  - Prefer the least fragile provider that gives acceptable results.
  - 2026-07-13 result: switched `lua/plugins/nvim-ufo.lua` from `{ "treesitter", "indent" }` to `{ "lsp", "indent" }` as the migration-safe default.

- [ ] **Reintroduce textobjects and incremental selection only if they still work reliably**
  - These are optional power features, not baseline stability features.

- [ ] **Reintroduce Tree-sitter provider for `vim-illuminate` only if it improves over LSP+regex**
  - Remove complexity if benefit is small.
  - 2026-07-13 result: removed the `treesitter` provider from `lua/plugins/illuminate.lua`; active providers are now `lsp` then `regex`.

- [ ] **Audit `neotest` and `otter.nvim` dependencies after the base migration**
  - Check whether their explicit `nvim-treesitter` dependency can be removed or made optional.

### Phase 4: Cleanup and final documentation

- [ ] **Remove obsolete compatibility hacks only after the new stack is proven**
  - Especially the extmark suppression hack in `lua/autocmd.lua`.

- [ ] **Write final migration notes with old vs new behavior**
  - Document what stayed.
  - Document what changed.
  - Document what was intentionally dropped.
  - Keep reference snippets for any removed feature that may return later.

---

## Suggested Verification Set

Use the same small manual test set after each major change:

- `markdown` file with fenced `lua`, `ts`, and `bash` code blocks
- `tsx` file with JSX comments
- `lua` file for textobjects and incremental selection
- `typescript` or `go` file for folds
- a file where `vim-illuminate` normally highlights references
- one test file for `neotest`

If a feature fails, note:

- what broke
- whether it is blocker or optional
- which old snippet used to provide it
