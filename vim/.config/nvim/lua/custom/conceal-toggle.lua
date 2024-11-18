local function toggleConceal()
	if vim.o.conceallevel == 0 then
		vim.cmd('RenderMarkdown enable')
		vim.fn.timer_start(100, function()
			vim.o.conceallevel = 3
		end)

		vim.notify(
			'Switched to: conceallevel=' .. vim.o.conceallevel .. ' and RenderMarkdown enable',
			vim.log.levels.INFO,
			{ title = 'ConcealToggle' }
		)
	else
		vim.cmd('RenderMarkdown disable')
		vim.fn.timer_start(100, function()
			vim.o.conceallevel = 0
		end)

		vim.notify(
			'Switched to: conceallevel=' .. vim.o.conceallevel .. ' and RenderMarkdown disable',
			vim.log.levels.INFO,
			{ title = 'ConcealToggle' }
		)
	end
	print(vim.o.conceallevel)
end

vim.api.nvim_create_user_command('ConcealToggle', toggleConceal, { desc = 'Toggle render markdown' })
Keymap.normal('<leader>sc', toggleConceal, { silent = false, desc = 'Toggle set=conceallevel (render markdown)' })
