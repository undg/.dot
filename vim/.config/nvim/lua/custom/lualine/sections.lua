local path_ok, my_path = pcall(require, 'utils.path')
local window_ok, my_window = pcall(require, 'utils.window')
local str_ok, str = pcall(require, 'utils.str')
local harpoon_ok, harpoon = pcall(require, 'custom.lualine.harpoon')

local not_ok = not path_ok and 'utils.path' --
    or not window_ok and 'utils.window'
    or not str_ok and 'utils.string'
    or not harpoon_ok and 'lualine.harpoon'
    or false

if not_ok then
    vim.notify('lua/custom/lualine/sections: missing - ' .. not_ok, vim.log.levels.ERROR)
end

local M = {}

local path_type = {
    relative = 1,
    absolute = 2,
    absolute_home = 3,
}
local shorting_target = 60
local insert_mode = vim.fn.mode() == 'i'
local normal_mode = vim.fn.mode() == 'n'
local sudo -- suda plugin required
local is_git
-- @TODO (undg) 2022-12-31: fix it,
-- logic is temporary flipped around.
local branch_color = function(is_git_arg)
    if is_git_arg then
        return { bg = '#A8A8A8', fg = '#706965' }
    else
        return { bg = '#A8A8A8', fg = '#222222' }
    end
end
local section_a_color = { bg = '#504945', fg = '#191919' }

M.harpoon = harpoon

M.cwd = {
    'filename',
    file_status = false,
    newfile_status = false,
    fmt = function()
        local estimated_space_available = my_window.width() - shorting_target
        return my_path.shorten(my_path.from_home(), '/', estimated_space_available)
    end,
}

M.relative_path = {
    'filename',
    file_status = true,    -- Displays file status (readonly status, modified status)
    newfile_status = true, -- Display new file status (new file means no write after created)
    path = path_type.relative,
    color = function(arg)
        local bg
        local fg

        if sudo then
            bg = '#551100'
        else
            local line
            if insert_mode then
                line = 'lualine_' .. arg.section .. '_insert'
            elseif normal_mode then
                line = 'lualine_' .. arg.section .. '_normal'
            else
                line = 'lualine_' .. arg.section .. '_visual'
            end
            bg = line.bg
        end

        if vim.bo.modified then
            fg = '#89d957'
        else
            fg = '#fe8019'
        end

        return { fg = fg, bg = bg }
    end,
    fmt = function(filename)
        if str.starts_with(filename, 'suda:///') or str.starts_with(filename, 's///') then
            sudo = true
        else
            sudo = false
        end

        return filename
    end,

    shorting_target = shorting_target, -- Shortens path to leave 40 spaces in the window
    -- for other components. (terrible name, any suggestions?)
    symbols = {
        modified = '[+]',      -- Text to show when the file is modified.
        readonly = '[-]',      -- Text to show when the file is non-modiiable or readonly.
        unnamed = '[No Name]', -- Text to show for unnamed buffers.
        newfile = '[New]',     -- Text to show for new created file before first writting
    },
}

M.branch = {
    'branch',
    color = branch_color(is_git),
    icons_enabled = true,
    separator = { left = '', right = '' },
    fmt = function(branch)
        if branch == '' then
            is_git = false
            return 'noop'
        else
            is_git = true
            return branch
        end
    end,
}
M.fileformat = {
    'fileformat',
    color = branch_color(is_git),
    icons_enabled = true,
    separator = { left = '', right = '' },
}

M.filetype = {
    'filetype',
    icons_enabled = true,
    separator = { left = '', right = '' },
    fmt = function(filetype)
        if filetype == 'typescriptreact' then
            return 'tsx'
        elseif filetype == 'javascriptreact' then
            return 'jsx'
        else
            return filetype
        end
    end,
}

-- @TODO (undg) 2022-12-30: merge it, create custom one
M.progress = {
    'progress',
    color = section_a_color,
}

M.location = {
    'location',
    color = section_a_color,
}

return M
