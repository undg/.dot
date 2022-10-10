local map = require("utils.map")

-- Core
map.normal("<leader>m", ":Telescope<cr>")
map.normal(",.", ":Telescope find_files hidden=true<cr>")
map.normal("<leader>,", ":Telescope find_files hidden=true<cr>")
map.normal("<leader>.", ':lua require("telescope").extensions.file_browser.file_browser({hidden = true, path = "%:p:h", grouped = true, hide_parent_dir = true, select_buffer = true, respect_gitignore = true })<cr>')
map.normal("<leader>fb", ":Telescope buffers<cr>")
map.normal("<leader>fg", ":Telescope live_grep<cr>")
map.normal("<leader>fs", ":Telescope git_status<cr>")
map.normal("<leader>fq", ":Telescope quickfixhistory<cr>")

-- Custom commands
map.normal("<leader>fvf", ":GotoVimFind<cr>")
map.normal("<leader>fvb", ":GotoVimBrowse<cr>")
map.normal("<leader>fvs", ":GotoVimGit<cr>")
map.normal("<leader>fvg", ":GotoVimGrep<cr>")

map.normal("<leader>fzf", ":GotoZshFind<cr>")
map.normal("<leader>fzb", ":GotoZshBrowse<cr>")
map.normal("<leader>fzs", ":GotoZshGit<cr>")
map.normal("<leader>fzg", ":GotoZshGrep<cr>")

map.normal("<leader>fdf", ":GotoDotFind<cr>")
map.normal("<leader>fdb", ":GotoDotBrowse<cr>")
map.normal("<leader>fds", ":GotoDotGit<cr>")
map.normal("<leader>fdg", ":GotoDotGrep<cr>")

map.normal("<leader>fcf", ":GotoCodeFind<cr>")
map.normal("<leader>fcb", ":GotoCodeBrowse<cr>")
map.normal("<leader>fcs", ":GotoCodeGit<cr>")
map.normal("<leader>fcg", ":GotoCodeGrep<cr>")

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end


local keymap = vim.keymap.set
local tb = require('telescope.builtin')
local opts = { noremap = true, silent = true }

keymap('v', '<leader>fg', function()
	local text = vim.getVisualSelection()
	tb.live_grep({ default_text = text })
end, opts)
