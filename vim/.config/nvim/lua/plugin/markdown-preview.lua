return {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    setup = function()
        -- you need yarn or npm already installed in os
        vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
}