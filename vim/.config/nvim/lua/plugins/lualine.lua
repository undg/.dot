return {
    'nvim-lualine/lualine.nvim', -- https://github.com/nvim-lualine/lualine.nvim
    config = function()
        local ok_s, s = pcall(require, 'custom.lualine.sections')
        if not ok_s then
            return
        end

        local sections = {
            lualine_a = { s.branch, s.progress },
            lualine_b = { s.harpoon },
            lualine_c = {},

            lualine_x = { 'diagnostics', 'diff' },
            lualine_y = { s.cwd, s.fileformat, s.filetype },
            lualine_z = {},
        }

        require('lualine').setup({
            options = {
                icons_enabled = true,
                component_separators = { left = '', right = '' },

                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    -- statusline = { 'alpha' },
                    -- winbar = { 'alpha' },
                },
                ignore_focus = {},
                always_divide_middle = false,
                globalstatus = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = sections,
            inactive_sections = sections,
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = { 'nvim-tree', 'fugitive', 'mundo', 'quickfix' },
        })
    end,
}
