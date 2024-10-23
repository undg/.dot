local harpoon_ok, harpoon = pcall(require, 'harpoon')
local path = require('utils.path')

local not_ok = not harpoon_ok and 'harpoon' --
    or false

if not_ok then
    vim.notify('custom/lucaline/harpoon.lua: missing requirement - ' .. not_ok, vim.log.levels.ERROR)
    return
end

return function()
    local menu_items = harpoon.get_mark_config().marks ---@diagnostic disable-line: undefined-field
    local menu_string = ''
    for _, item in ipairs(menu_items) do
        menu_string = menu_string .. path.shorten(item.filename) .. ''
    end
    return menu_string
end
