local M = {}

function UpdatePacker()
    vim.api.nvim_command('source ~/.config/nvim/lua/plugins/init.lua')
    vim.api.nvim_command('PackerCompile')
    vim.api.nvim_command('PackerSync')
    vim.api.nvim_command('TSUpdate')
    -- vim.cmd [[ :!npm install -g json-ts<cr> ]]
end
vim.api.nvim_create_user_command('Update', 'lua UpdatePacker()', {})

return M
