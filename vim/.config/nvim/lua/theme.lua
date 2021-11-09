vim.o.background = 'dark'

-- vim.cmd([[
--     syntax enable
--     colorscheme gruvbox
--     hi Normal               ctermbg=0 guibg=#131313
--     hi ColorColumn          ctermbg=0 guibg=#303030
--     hi LineNr               ctermbg=0 guibg=#3C3836

--     set t_ut=
-- ]])

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme gruvbox]]

-- Set statusbar (lightline)
vim.g.lightline = {
    colorscheme = 'gruvbox',
    active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
    component_function = { gitbranch = 'fugitive#head' },
}

-- Map lukas-reineke/indent-blankline.nvim
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

