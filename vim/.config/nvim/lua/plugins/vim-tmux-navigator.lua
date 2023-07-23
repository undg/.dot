local map = require('utils.map')
return {
    'christoomey/vim-tmux-navigator',
    config = function()
        -- This will execute the update command on leaving vim to a tmux pane. Default is Zero
        vim.g.tmux_navigator_save_on_switch = 1
        vim.g.tmux_navigator_no_mappings = 1
        vim.g.tmux_navigator_no_wrap = 1

        map.normal('<M-h>', ':TmuxNavigateLeft<cr>')
        map.normal('<M-j>', ':TmuxNavigateDown<cr>')
        map.normal('<M-k>', ':TmuxNavigateUp<cr>')
        map.normal('<M-l>', ':TmuxNavigateRight<cr>')
        map.normal('<M-Bslash>', ':TmuxNavigatePrevious<cr>')
    end,
}
