local function go_get_diagnostic_message() 
    vim.diagnostic.goto_prev()
    local diagnostic_message = vim.diagnostic.get_next().message
    vim.diagnostic.goto_next()
    return diagnostic_message
end


local function shorten()
    local diagnostic_message = go_get_diagnostic_message()

    vim.api.nvim_command(
        'CodyAsk'
        .. 'Explain this diagnostic in shortest possible way. Remove all unnecesary noise, make it short and sweet.'
        .. diagnostic_message
    )
end

local function explain()
    local diagnostic_message = go_get_diagnostic_message()

    vim.api.nvim_command('CodyAsk' .. 'Explain this diagnostic in informative way. Make it more clear.' .. diagnostic_message)
end

return {
    shorten = {
        get = shorten,
        desc = 'Shorten diagnostic, keep cursor on or before error',
    },

    explain = {
        get = explain,
        desc = 'Explain diagnostic, keep cursor on or before error',
    },
}
