local keymap = require('utils.keymap')

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

-- keymap.normal('<leader>ff', ':TreeFileToggleFocus<cr>')
-- keymap.normal('<leader>fs', ':TreeGitToggleFocus<cr>')

keymap.normal('<leader>ff', ':Neotree filesystem toggle left<cr>')
keymap.normal('<leader>fs', ':Neotree git_status toggle right<cr>')

keymap.normal('<F2>', ':TreeFileToggleFocus<CR>')
keymap.normal('<leader>2', ':TreeFileToggleFocus<CR>')

keymap.normal('<F3>', ':Neotree filesystem toggle left<cr>')
keymap.normal('<leader>3', ':Neotree filesystem toggle left<cr>')

keymap.normal('<F4>', ':TreeBuffToggleFocus<cr>')
keymap.normal('<leader>4', ':TreeBuffToggleFocus<cr>')

keymap.normal('<F5>', ':Neotree buffers toggle right<cr>')
keymap.normal('<leader>5', ':Neotree buffers toggle right<cr>')

-- keymap.normal('<F4>', ':TreeGitToggleFocus<cr>')
-- keymap.normal('<leader>4', ':TreeGitToggleFocus<cr>')
--
-- keymap.normal('<F5>', ':Neotree git_status toggle right<cr>')
-- keymap.normal('<leader>5', ':Neotree git_status toggle right<cr>')
