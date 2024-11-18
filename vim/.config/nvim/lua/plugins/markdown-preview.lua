return {
	'iamcco/markdown-preview.nvim', -- https://github.com/iamcco/markdown-preview.nvim
	cmd = {
		'MarkdownPreviewToggle',
		'MarkdownPreview',
		'MarkdownPreviewStop',
	},
	ft = { 'markdown' },
	build = function()
		local job_ok, job = pcall(require, 'plenary.job')

		local not_ok = not job_ok and 'plenary.job' --
			or false

		if not_ok then
			vim.notify('plugins/markdown-preview.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
		end

		local install_path = vim.fn.stdpath('data') .. '/lazy/markdown-preview.nvim/app'
		local cmd = 'bash'

		job:new({
			command = cmd,
			args = { '-c', 'npm install && git restore .' },
			cwd = install_path,
			on_exit = function()
				vim.notify('Finished installing markdown-preview.nvim', vim.log.levels.INFO)
			end,
			on_stderr = function(_, data)
				vim.notify(data, vim.log.levels.ERROR)
			end,
		}):start()

		-- Options
		vim.g.mkdp_auto_close = 0
	end,
}
