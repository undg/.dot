local function renderMarkdown(on)
	if vim.filetype ~= 'markdown' then
		return
	end

	if on then
		vim.cmd('RenderMarkdown enable')
	end

	if not on then
		vim.cmd('RenderMarkdown disable')
	end
end

local function toggleConceal()
	if vim.o.conceallevel == 0 then
		renderMarkdown(true)
		vim.fn.timer_start(100, function()
			vim.o.conceallevel = 3
		end)

		vim.notify(
			'Switched to: conceallevel=' .. vim.o.conceallevel .. ' and RenderMarkdown enable',
			vim.log.levels.INFO,
			{ title = 'ConcealToggle' }
		)
	else
		renderMarkdown(false)
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
