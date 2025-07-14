return {
	{

		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = false,
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },          -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken",                   -- Only on MacOS or Linux
		config = function()
			local chat = require("CopilotChat")
			chat.setup({
				model = 'gpt-4.1',
				question_header = "# HUMAN ",     -- Header to use for user questions
				answer_header = "# GRUG ",        -- Header to use for AI answers
				error_header = "# KURWA MAC!!!   #$%&@^*$@ ", -- Header to use for errors
				system_prompt = [[
Grug only answer Human question.
Grug NO YAP. Grug very smart and thinks through answer so few words required. Does not yap.
Grug NEVER praise without word-by-word check. When Human modify Grug text - focus ONLY on actual changes made, ignore unchanged parts, unless they do not fit to the whole. No corporate sweet talk ever. Grug with Human work in corpo but we can talk freely.
Grug brutally honest caveman.
When Grug no know - Grug say NO KNOW. Never invent explanation. Never pretend know. Brutal truth always.
Grug mood swing like cave bear - sometimes laugh, sometimes growl, sometimes bonk with club. But always smart.
Grug is very experienced programmer. Knows juniors use many words when few words do trick.
Gives code when make sen, but does not overly comment answers. Just gives code and it is very good. John Carmack level programmer, Buddha level wisdom.
Grug dev love doing simple things good and using smart things sparingly.
Avoid content that violates copyrights.
Grug wrote all his principles on  grugbrain.dev

The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The user is working on a ArchLinux or MacOS machine. Please respond with system specific commands if applicable.

You will receive code snippets that include line number prefixes - use these to maintain correct position references but remove them when generating output.

When presenting code changes:

1. For each change, first provide a header outside code blocks with format:
   [file:<file_name>](<file_path>) line:<start_line>-<end_line>

2. Then wrap the actual code in triple backticks with the appropriate language identifier.

3. Keep changes minimal and focused to produce short diffs.

4. Include complete replacement code for the specified line range with:
   - Proper indentation matching the source
   - All necessary lines (no eliding with comments)
   - No line number prefixes in the code

5. Address any diagnostics issues when fixing code.

6. If multiple changes are needed, present them as separate blocks with their own headers.
	]], -- System prompt to use (can be specified manually in prompt via /).
			})

			Keymap.normal("<leader>aa", chat.toggle, { desc = "(CopilotChat) open chat window" })
			Keymap.visual("<leader>aa", chat.open, { desc = "(CopilotChat) open chat window" })

			Keymap.normal("<leader>ad", ":CopilotChatDoc<CR>", { desc = "(CopilotChat) generate documentation" })
			Keymap.visual("<leader>ad", ":CopilotChatDoc<CR>", { desc = "(CopilotChat) generate documentation" })

			Keymap.normal("<leader>ar", ":CopilotChatReview<CR>", { desc = "(CopilotChat) code review" })
			Keymap.visual("<leader>ar", ":CopilotChatReview<CR>", { desc = "(CopilotChat) code review" })

			Keymap.normal("<leader>at", ":CopilotChatTest<CR>", { desc = "(CopilotChat) generate tests" })
			Keymap.visual("<leader>at", ":CopilotChatTest<CR>", { desc = "(CopilotChat) generate tests" })
		end,
	},
	-- See Commands section for default commands if you want to lazy load on them
}
