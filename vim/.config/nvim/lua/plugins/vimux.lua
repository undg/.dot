return {
	'benmills/vimux', -- https://github.com/benmills/vimux
	-- cmd = { 'VimuxPromptCommand', 'VimuxRunCommand' },
	init = function()
		vim.g.VimuxDebug = false
		vim.g.VimuxHeight = 40
		vim.g.VimuxOpenExtraArgs = ''
		vim.g.VimuxOrientation = 'h'
		vim.g.VimuxPromptString = 'Run? '
		vim.g.VimuxResetSequence = 'q C-u'
		vim.g.VimuxRunnerName = ''
		vim.g.VimuxRunnerType = 'pane'
		vim.g.VimuxRunnerQuery = {}
		vim.g.VimuxTmuxCommand = 'tmux'
		vim.g.VimuxUseNearest = true
		vim.g.VimuxExpandCommand = false
		vim.g.VimuxCloseOnExit = false
		vim.g.VimuxCommandShell = false -- enable shell completion (disable arrow up)

		-- Run...
		Keymap.normal('<Leader>vv', ':call VimuxRunCommand("./" . bufname("%"))<CR>')
		Keymap.normal('<Leader>vt', ':call VimuxRunCommand("ts-node " . bufname("%"))<CR>')
		Keymap.normal('<Leader>vn', ':call VimuxRunCommand("node " . bufname("%"))<CR>')
		Keymap.normal('<Leader>vd', ':call VimuxRunCommand("deno run --allow-all " . bufname("%"))<CR>')
		Keymap.normal('<Leader>vg', ':call VimuxRunCommand("go run " . bufname("%"))<CR>')

		-- Prompt for a command to run
		Keymap.normal('<Leader>vp', ':VimuxPromptCommand<CR>')

		-- Interrupt any command running in the runner pane
		Keymap.normal('<Leader>vc', ':VimuxInterruptRunner<CR>')

		-- Run last command executed by VimuxRunCommand
		Keymap.normal('<Leader>vl', ':VimuxRunLastCommand<CR>')

		-- !RESTART LAST COMMAND
		Keymap.normal(
			'<Leader>vr',
			':call VimuxInterruptRunner() <bar> :call VimuxInterruptRunner() <bar> :call VimuxRunLastCommand() <cr><cr>'
		)
	end,
}
