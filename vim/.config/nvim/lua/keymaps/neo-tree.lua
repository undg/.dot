local map = require('utils.map')

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

map.normal('<leader>ff', ':TreeFileToggleFocus<cr>')
map.normal('<leader>fb', ':TreeBuffToggleFocus<cr>')
map.normal('<leader>fs', ':TreeGitToggleFocus<cr>')

map.normal('<F2>', ':TreeFileToggleFocus<CR>')
map.normal('<leader>2', ':TreeFileToggleFocus<CR>')

map.normal('<F3>', ':Neotree filesystem toggle left<cr>')
map.normal('<leader>3', ':Neotree filesystem toggle left<cr>')

-- map.normal('<F4>', ':TreeBuffToggleFocus<cr>')
-- map.normal('<leader>4', ':TreeBuffToggleFocus<cr>')

-- map.normal('<F5>', ':Neotree buffers toggle right<cr>')
-- map.normal('<leader>5', ':Neotree buffers toggle right<cr>')

map.normal('<F4>', ':TreeGitToggleFocus<cr>')
map.normal('<leader>4', ':TreeGitToggleFocus<cr>')

map.normal('<F5>', ':Neotree git_status toggle right<cr>')
map.normal('<leader>5', ':Neotree git_status toggle right<cr>')
