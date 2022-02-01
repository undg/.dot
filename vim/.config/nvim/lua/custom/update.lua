local M = {}

function UpdatePacker()
    vim.api.nvim_command('PackerSync')
    vim.api.nvim_command('TSUpdate')
    -- vim.cmd [[ :!npm install -g json-ts<cr> ]]
end
-- vim.cmd [[ command! UpdatePacker :PackerSync&TSUpdate ]]
vim.cmd [[command! UpdatePacker :lua UpdatePacker()]]

return M
