return {
    'lilydjwg/colorizer',
    config = function()
        vim.g.colorizer_startup = 0
        vim.g.colorizer_maxlines = 1000
    end,
    cmd = { 'ColorHighlight', 'ColorToggle' },
}
