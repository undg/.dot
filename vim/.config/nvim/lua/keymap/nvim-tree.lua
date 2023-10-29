local keymap = require('utils.keymap')

local function nvimTreeToggleFocus()
    if vim.bo.filetype == 'NvimTree' then
        vim.api.nvim_input('<C-W><C-P>')
    else
        vim.cmd('NvimTreeFindFile')
    end
end
vim.api.nvim_create_user_command('NvimTreeToggleFocus', nvimTreeToggleFocus, {})

keymap.normal('<F2>', ':NvimTreeFindFileToggle<CR>')
keymap.normal('<leader>2', ':NvimTreeFindFileToggle<CR>')
keymap.normal('<leader>ff', ':NvimTreeFindFileToggle<cr>')

keymap.normal('<F3>', ':NvimTreeToggleFocus<cr>')
keymap.normal('<leader>3', ':NvimTreeToggleFocus<cr>')

keymap.normal('<F4>', ':NvimTreeClose<cr>')
keymap.normal('<leader>4', ':NvimTreeClose<cr>')
