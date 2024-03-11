-- https://github.com/rafcamlet/nvim-luapad

return {
    'rafcamlet/nvim-luapad',
    opts = {
        count_limit = 150000,
        error_indicator = false,
        eval_on_move = true,
        error_highlight = 'WarningMsg',
        on_init = function()
            vim.notify('Hello from Luapad!', vim.log.levels.INFO)
        end,
        context = {
            the_answer = 42,
            shout = function(str)
                return (string.upper(str) .. '!')
            end,
        },
    },
}
