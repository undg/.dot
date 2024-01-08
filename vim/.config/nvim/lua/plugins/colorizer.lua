return {
    'lilydjwg/colorizer', -- https://github.com/lilydjwg/colorizer
    cmd = { 'ColorHighlight', 'ColorToggle' },
    init = function()
        vim.g.colorizer_startup = 0
        vim.g.colorizer_maxlines = 1000
    end,
}
