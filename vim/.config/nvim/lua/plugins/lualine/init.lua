local lualine_ok, lualine = pcall(require, 'lualine')
if not lualine_ok then
    print('lua/plugins/lualine.lua: fail to load lualine ')
    return
end

local s_ok, s = pcall(require, 'plugins.lualine.sections')
if not s_ok then
    print('lua/plugins/lualine.lua: fail to load sections ')
    return
end

local sections = {
    lualine_a = { s.progress },
    lualine_b = { s.branch, s.fileformat },
    lualine_c = { s.cwd, '' },

    lualine_x = { s.relative_path, 'diagnostics', 'diff' },
    lualine_y = { s.filetype },
    lualine_z = { 'hostname' },
}

lualine.setup({
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
        globalstatus = false,
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
