local notify_ok, notify = pcall(require, 'notify')


local not_ok = not notify_ok and "notify" --
	or false

if not_ok then
	vim.notify("conceal-toggle.lua: requirement's missing - " .. not_ok, vim.log.levels.ERROR)
end

local renderMarkdown_ok, _ = pcall(require, 'render-markdown')
local function renderMarkdown(on)
	if vim.bo.filetype ~= 'markdown' or not renderMarkdown_ok then
		return
	end

	if on then
		vim.cmd('RenderMarkdown enable')
	end

	if not on then
		vim.cmd('RenderMarkdown disable')
	end
end

local timer_ms = 0
if renderMarkdown_ok then timer_ms = 100 end

local function toggleConceal()
	notify.dismiss()
	if vim.o.conceallevel > 0 then
		renderMarkdown(false)
		vim.fn.timer_start(timer_ms, function()
			vim.o.conceallevel = 0

			local and_RenderMarkdown = ''
			if renderMarkdown_ok then and_RenderMarkdown = ' and RenderMarkdown disable' end

			vim.notify(
				'Switched to: conceallevel=' .. vim.o.conceallevel .. and_RenderMarkdown,
				vim.log.levels.INFO,
				{ title = 'ConcealToggle' }
			)
		end)
	else
		renderMarkdown(true)
		vim.fn.timer_start(timer_ms, function()
			vim.o.conceallevel = 3

			local and_RenderMarkdown = ''
			if renderMarkdown_ok then and_RenderMarkdown = ' and RenderMarkdown enable' end

			vim.notify(
				'Switched to: conceallevel=' .. vim.o.conceallevel .. and_RenderMarkdown,
				vim.log.levels.INFO,
				{ title = 'ConcealToggle' }
			)
		end)
	end
end

vim.api.nvim_create_user_command('ConcealToggle', toggleConceal, { desc = 'Toggle render markdown' })
Keymap.normal('<leader>sc', toggleConceal, { silent = false, desc = 'Toggle set=conceallevel (render markdown)' })
