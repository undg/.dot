local M = {}

function UpdatePacker()
    vim.api.nvim_command('PackerSync')
    vim.api.nvim_command('TSUpdate')
    -- vim.cmd [[ :!npm install -g json-ts<cr> ]]
end
vim.api.nvim_create_user_command('UpdatePacker', 'lua UpdatePacker()', {})

return M
