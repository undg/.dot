local harpoon_ok, harpoon = pcall(require, 'harpoon')
local path = require('utils.path')
local highlight = require('lualine.highlight')
local color = { norm = { bg = '#228B22' }, curr = { bg = '#C70039' } }

local not_ok = not harpoon_ok and 'harpoon' --
    or false

if not_ok then
    vim.notify('custom/lucaline/harpoon.lua: missing requirement - ' .. not_ok, vim.log.levels.ERROR)
    return
end

local function colorize(text, hl_group)
    return string.format("%%#%s#%s%%#Normal#", hl_group, text)
end

vim.api.nvim_set_hl(0, "CustomHarpoonCurrentBuffer", { fg = "Blue", bold = true })

return function()
    local separator = ''
    local buf_curr = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(buf_curr)

    local menu_items = harpoon.get_mark_config().marks ---@diagnostic disable-line: undefined-field

    local menu_string = separator

    local items = {}
    for _, item in ipairs(menu_items) do

        local is_curr = string.find(buf_name, item.filename)
        local star = is_curr and '✴' or ''
        local shortened_path = colorize(path.shorten(path.shorten(item.filename)), "CustomHarpoonCurrentBuffer")
        table.insert(items, string.format("%s%s%s", star, shortened_path, star))

        menu_string = menu_string .. star .. path.shorten(item.filename) .. star .. separator
    end
    menu_string = table.concat(items, separator)
    return menu_string
end
-- {s.harpoon, color = {fg = '#ff0000'}} 
