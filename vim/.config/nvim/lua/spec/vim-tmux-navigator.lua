-- local keymap = require('utils.keymap')

local M = {
    'christoomey/vim-tmux-navigator',
    cmd = {
        'TmuxNavigateLeft',
        'TmuxNavigateDown',
        'TmuxNavigateUp',
        'TmuxNavigateRight',
        'TmuxNavigatePrevious',
    },
}

function M.config()
    -- This will execute the update command on leaving vim to a tmux pane. Default is Zero
    -- 1	:update (write the current buffer, but only if changed)
    -- 2	:wall (write all buffers)
    vim.g.tmux_navigator_save_on_switch = 2
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_no_wrap = 1

    -- keymap.normal('<M-h>', ':TmuxNavigateLeft<cr>')
    -- keymap.normal('<M-j>', ':TmuxNavigateDown<cr>')
    -- keymap.normal('<M-k>', ':TmuxNavigateUp<cr>')
    -- keymap.normal('<M-l>', ':TmuxNavigateRight<cr>')
    -- keymap.normal('<M-Bslash>', ':TmuxNavigatePrevious<cr>')
end

M.keys = {
    { '<M-h>',      ':TmuxNavigateLeft<cr>' },
    { '<M-j>',      ':TmuxNavigateDown<cr>' },
    { '<M-k>',      ':TmuxNavigateUp<cr>' },
    { '<M-l>',      ':TmuxNavigateRight<cr>' },
    { '<M-Bslash>', ':TmuxNavigatePrevious<cr>' },
}

return M
