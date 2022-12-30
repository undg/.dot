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
    -- color = 'USER1',
    fmt = function()
        local estimated_space_available = my_window.width() - shorting_target
        return my_path.shorten(my_path.from_home(), '/', estimated_space_available)
    end,
}

-- suda plugin required

local sudo = false
local relative_path = {
    'filename',
    file_status = true, -- Displays file status (readonly status, modified status)
    newfile_status = true, -- Display new file status (new file means no write after created)
    path = path_type.relative,
    color = function(section)
        local bg
        if sudo then
            bg = '#551100'
        else
            local line
            if vim.fn.mode() == 'i' then
                line = 'lualine_a_insert'
            elseif vim.fn.mode() == 'n' then
                line = 'lualine_a_normal'
            else
                line = 'lualine_a_visual'
            end
                bg = line.bg
        end

        if vim.bo.modified then
            return { fg = '#89d957', bg = bg }
        else
            return { fg = '#fe8019', bg = bg }
        end
    end,
    fmt = function(str)
        local function starts(String, Start)
            return string.sub(String, 1, string.len(Start)) == Start
        end

        if starts(str, 'suda:///') then
            sudo = true
        else
            sudo = false
        end
        return str
    end,

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
    fmt = function(str)
        if str == '' then
            return 'noop'
        else
            return str
        end
    end,
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
    color = 'USER3',
    icons_enabled = true,
    separator = { left = '', right = '' },
}

-- @TODO (undg) 2022-12-30: merge it, create custom one
local progress = {
    'progress',
    color = 'USER2',
}
local location = {
    'location',
    color = 'USER2',
}

local sections = {
    lualine_a = { location, progress },
    lualine_b = { branch, fileformat },
    lualine_c = { cwd, '' },

    lualine_x = { relative_path, 'diagnostics', 'diff' },
    lualine_y = { filetype },
    lualine_z = { 'hostname' },
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
