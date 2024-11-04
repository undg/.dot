local function IndentCycle()
	local states = {
		{ name = '2 spaces',    expandtab = true,  width = 2 },
		{ name = '4 spaces',    expandtab = true,  width = 4 },
		{ name = '2-wide tabs', expandtab = false, width = 2 },
		{ name = '4-wide tabs', expandtab = false, width = 4 },
	}

	vim.g.indent_state = (vim.g.indent_state or 0) % #states + 1
	local new_state = states[vim.g.indent_state]

	vim.opt.expandtab = new_state.expandtab
	vim.opt.tabstop = new_state.width
	vim.opt.softtabstop = new_state.width
	vim.opt.shiftwidth = new_state.width

	vim.notify('Switched to: ' .. new_state.name, vim.log.levels.INFO, { title = 'IndentCycle' })
end

vim.api.nvim_create_user_command('IndentCycle', IndentCycle, {})
Keymap.normal('<leader>st', IndentCycle, { silent = false, desc = 'Toggle indentation style' })
