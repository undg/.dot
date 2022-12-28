local lualine_ok, lualine = pcall(require, 'lualine')
if not lualine_ok then
    print('lua/plugins/lualine.lua: fail to load lualine ')
    return
end

local path_ok, my_path = pcall(require, 'utils.path')
if not path_ok then
    print('lua/plugins/lualine.lua: fail to load utils.path')
    return
end

local window_ok, my_window = pcall(require, 'utils.window')
if not window_ok then
    print('lua/plugins/lualine.lua: fail to load utils.window')
    return
end

local path_type = {
    relative = 1,
    absolute = 2,
    absolute_home = 3,
}

local shorting_target = 30

local cwd = {
    'filename',
    file_status = false,
    newfile_status = false,
    color = 'USER1',
    fmt = function()
        local estimated_space_available = my_window.width() - shorting_target
        return my_path.shorten(my_path.from_home(), '/', estimated_space_available)
    end,
}

local relative_path = {
    'filename',
    file_status = true, -- Displays file status (readonly status, modified status)
    newfile_status = true, -- Display new file status (new file means no write after created)
    path = path_type.relative,
    color = 'USER1',
    shorting_target = shorting_target, -- Shortens path to leave 40 spaces in the window
    -- for other components. (terrible name, any suggestions?)
    symbols = {
        modified = '[+]', -- Text to show when the file is modified.
        readonly = '[-]', -- Text to show when the file is non-modiiable or readonly.
        unnamed = '[No Name]', -- Text to show for unnamed buffers.
        newfile = '[New]', -- Text to show for new created file before first writting
    },
}

local branch = {
    'branch',
    color = 'USER3',
    icons_enabled = true,
    separator = { left = '', right = '' },
}

local filetype = {
    'filetype',
    icons_enabled = true,
    separator = { left = '', right = '' },
    fmt = function(str)
        if str == 'typescriptreact' then
            return 'tsx'
        elseif str == 'javascriptreact' then
            return 'jsx'
        else
            return str
        end
    end,
}
local fileformat = {
    'fileformat',
    color = 'USER1',
    icons_enabled = true,
    separator = { left = '', right = '' },
}

local sections = {
    lualine_a = { cwd },
    lualine_b = { branch, fileformat },
    lualine_c = { relative_path },

    lualine_x = { 'diagnostics', 'diff' },
    lualine_y = { filetype },
    lualine_z = { 'progress', 'location' },
}

lualine.setup({
    options = {
        icons_enabled = true,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = { 'alpha' },
            winbar = { 'alpha' },
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
