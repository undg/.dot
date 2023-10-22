local map = require('utils.map')

local function is_lua_buffer()
    local bufpath = vim.api.nvim_buf_get_name(0)
    return bufpath:match('.*/nvim/lua/plugin/.*') ~= nil
end

local function open_plugin_page()
    if is_lua_buffer() then
        local uri = 'https://github.com/' .. vim.fn.getreg('"')
        vim.api.nvim_command('silent !brave ' .. uri)
    else
        print('You are not in nvim/lua/plugin/. You are in: ' .. vim.api.nvim_buf_get_name(0))
    end
end

vim.api.nvim_create_user_command('OpenPluginPage', open_plugin_page, {})
map.normal('<leader>op', "yi':OpenPluginPage<cr>")
