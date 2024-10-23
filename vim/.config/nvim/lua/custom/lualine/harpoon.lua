local harpoon_ok, harpoon = pcall(require, 'harpoon')
local path_ok, path = pcall(require, 'utils.path')
local str_ok, str = pcall(require, 'utils.str')

local not_ok = not harpoon_ok and 'harpoon' --
    or not path_ok and 'utils.path'
    or not str_ok and 'utils.str'
    or false

if not_ok then
    vim.notify('custom/lucaline/harpoon.lua: missing requirement - ' .. not_ok, vim.log.levels.ERROR)
    return
end

local M = function()
    local separator = str.color_text(' ', 'Normal')
    local buf_curr = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(buf_curr)
    local menu_items = harpoon.get_mark_config().marks ---@diagnostic disable-line: undefined-field

    local items = {}

    table.insert(items, separator)

    for _, item in ipairs(menu_items) do
        local is_curr = string.find(buf_name, item.filename)
        local hl_group = is_curr and 'lualine_a_visual' or 'lualine_b_normal'
        local shortened_path = str.color_text(' ' .. path.shorten(item.filename) .. ' ', hl_group)

        table.insert(items, shortened_path)
    end

    return table.concat(items, separator)
end

return M
