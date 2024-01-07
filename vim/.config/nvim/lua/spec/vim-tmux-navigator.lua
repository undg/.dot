local keymap = require('utils.keymap')
return {
    'christoomey/vim-tmux-navigator',
    config = function()
        -- This will execute the update command on leaving vim to a tmux pane. Default is Zero
        vim.g.tmux_navigator_save_on_switch = 1
        vim.g.tmux_navigator_no_mappings = 1
        vim.g.tmux_navigator_no_wrap = 1

        keymap.normal('<M-h>', ':TmuxNavigateLeft<cr>')
        keymap.normal('<M-j>', ':TmuxNavigateDown<cr>')
        keymap.normal('<M-k>', ':TmuxNavigateUp<cr>')
        keymap.normal('<M-l>', ':TmuxNavigateRight<cr>')
        keymap.normal('<M-Bslash>', ':TmuxNavigatePrevious<cr>')
    end,
}
