return {
    'ellisonleao/gruvbox.nvim', -- https://github.com/ellisonleao/gruvbox.nvim
    priority = 1000,
    config = function()
        require('gruvbox').setup({
            terminal_colors = true, -- add neovim terminal colors
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = 'hard',  -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = false,
        })
        vim.cmd([[colorscheme gruvbox]])

        -- vim.o.background = 'dark'

        -- Set colorscheme (order is important here)
        -- vim.o.termguicolors = true
        -- vim.g.onedark_terminal_italics = 2
        -- vim.cmd([[colorscheme gruvbox]])
        vim.cmd('highlight Cursorline guibg=#2f2f2f')

        -- Set statusbar (lightline)
        vim.g.lightline = {
            colorscheme = 'gruvbox',
            active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
            component_function = { gitbranch = 'fugitive#head' },
        }

        -- Undo underline that's set by default (RRethy/vim-illuminate)
        vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = '' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = '' })
        vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = '' })
        -- Set highlight color (RRethy/vim-illuminate)
        vim.cmd('hi IlluminatedWordRead guibg=#191919')
        vim.cmd('hi IlluminatedWordText guibg=#191919')
        vim.cmd('hi IlluminatedWordWrite guibg=#191919')
        vim.cmd('hi DiagnosticError guifg=#ee6666')
        --
        -- Map (lukas-reineke/indent-blankline.nvim)
        vim.g.indent_blankline_char = '┊'
        vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
        vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
        vim.g.indent_blankline_char_highlight = 'LineNr'
        vim.g.indent_blankline_show_trailing_blankline_indent = false

        -- Style and layout for diagnostic/hover floating windows
        local styled = {
            border = 'rounded',
            style = 'minimal',
            noautocmd = true,
        }
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, styled)

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, styled)

        vim.diagnostic.config({
            float = {
                border = styled.border,
                header = 'diagnostic:',
                source = true,
                prefix = '  ', -- padding left
                suffix = '  ', -- padding right
            },
        })
    end,
}
