local map = require('utils.map')

local function nvimTreeToggleFocus()
    if vim.bo.filetype == 'NvimTree' then
        vim.api.nvim_input('<C-W><C-P>')
    else
        vim.cmd('NvimTreeFindFile')
    end
end
vim.api.nvim_create_user_command('NvimTreeToggleFocus', nvimTreeToggleFocus, {})

map.normal('<F2>', ':NvimTreeFindFileToggle<CR>')
map.normal('<leader>2', ':NvimTreeFindFileToggle<CR>')
map.normal('<leader>ff', ':NvimTreeFindFileToggle<cr>')

map.normal('<F3>', ':NvimTreeToggleFocus<cr>')
map.normal('<leader>3', ':NvimTreeToggleFocus<cr>')

map.normal('<F4>', ':NvimTreeClose<cr>')
map.normal('<leader>4', ':NvimTreeClose<cr>')
