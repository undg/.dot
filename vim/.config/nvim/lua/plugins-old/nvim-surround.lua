local ok_nvim_surround, nvim_surround = pcall(require, 'nvim-surround')
if not ok_nvim_surround then
    print('plugins/nvim-surround.lua: missing requirements')
    return
end

nvim_surround.setup({
    -- Configuration here, or leave empty to use defaults
    -- :h nvim-surround.configuration.
})
