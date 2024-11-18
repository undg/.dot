local function treeFileToggleFocus()
	if vim.bo.filetype == 'neo-tree' then
		vim.api.nvim_input('<C-W><C-P>')
	else
		vim.cmd('Neotree reveal left')
	end
end

local function treeBuffToggleFocus()
	if vim.bo.filetype == 'neo-tree' then
		vim.api.nvim_input('<C-W><C-P>')
	else
		vim.cmd('Neotree buffers right')
	end
end

local function treeGitToggleFocus()
	if vim.bo.filetype == 'neo-tree' then
		vim.api.nvim_input('<C-W><C-P>')
	else
		vim.cmd('Neotree git_status right')
	end
end

vim.api.nvim_create_user_command('TreeFileToggleFocus', treeFileToggleFocus, {})
vim.api.nvim_create_user_command('TreeBuffToggleFocus', treeBuffToggleFocus, {})
vim.api.nvim_create_user_command('TreeGitToggleFocus', treeGitToggleFocus, {})

-- Keymap.normal('<leader>ff', ':TreeFileToggleFocus<cr>')
-- Keymap.normal('<leader>fs', ':TreeGitToggleFocus<cr>')

Keymap.normal('<leader>ff', ':Neotree filesystem toggle left<cr>')
Keymap.normal('<leader>fs', ':Neotree git_status toggle right<cr>')

Keymap.normal('<F2>', ':TreeFileToggleFocus<CR>')
Keymap.normal('<leader>2', ':TreeFileToggleFocus<CR>')

Keymap.normal('<F3>', ':Neotree filesystem toggle left<cr>')
Keymap.normal('<leader>3', ':Neotree filesystem toggle left<cr>')

Keymap.normal('<F4>', ':TreeBuffToggleFocus<cr>')
Keymap.normal('<leader>4', ':TreeBuffToggleFocus<cr>')

Keymap.normal('<F5>', ':Neotree buffers toggle right<cr>')
Keymap.normal('<leader>5', ':Neotree buffers toggle right<cr>')

-- keymap.normal('<F4>', ':TreeGitToggleFocus<cr>')
-- keymap.normal('<leader>4', ':TreeGitToggleFocus<cr>')
--
-- keymap.normal('<F5>', ':Neotree git_status toggle right<cr>')
-- keymap.normal('<leader>5', ':Neotree git_status toggle right<cr>')
