local function nvimTreeToggleFocus()
    if vim.bo.filetype == 'NvimTree' then
        vim.api.nvim_input('<C-W><C-P>')
    else
        vim.cmd('NvimTreeFindFile')
    end
end
vim.api.nvim_create_user_command('NvimTreeToggleFocus', nvimTreeToggleFocus, {})

Keymap.normal('<F2>', ':NvimTreeFindFileToggle<CR>')
Keymap.normal('<leader>2', ':NvimTreeFindFileToggle<CR>')
Keymap.normal('<leader>ff', ':NvimTreeFindFileToggle<cr>')

Keymap.normal('<F3>', ':NvimTreeToggleFocus<cr>')
Keymap.normal('<leader>3', ':NvimTreeToggleFocus<cr>')

Keymap.normal('<F4>', ':NvimTreeClose<cr>')
Keymap.normal('<leader>4', ':NvimTreeClose<cr>')
