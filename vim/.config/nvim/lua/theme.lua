vim.o.background = 'dark'

-- Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme gruvbox]]
vim.cmd('highlight Cursorline guibg=#2f2f2f')

-- Set statusbar (lightline)
vim.g.lightline = {
    colorscheme = 'gruvbox',
    active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
    component_function = { gitbranch = 'fugitive#head' },
}


-- Undo underline that's set by default (RRethy/vim-illuminate)
vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "" })
-- Set highlight color (RRethy/vim-illuminate)
vim.cmd('hi IlluminatedWordRead guibg=#191919');
vim.cmd('hi IlluminatedWordText guibg=#191919');
vim.cmd('hi IlluminatedWordWrite guibg=#191919');

-- Map (lukas-reineke/indent-blankline.nvim)
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_show_trailing_blankline_indent = false

