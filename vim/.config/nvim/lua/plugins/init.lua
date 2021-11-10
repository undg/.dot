-- Install packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec(
    [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost packer-startup.lua source <afile> | PackerCompile
    augroup end
    ]]
    ,false
)

