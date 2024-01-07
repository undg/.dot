-- https://github.com/alexghergh/nvim-tmux-navigation

local keymap = require('utils.keymap')

local M = {
    'alexghergh/nvim-tmux-navigation',
    opts = {
        disable_when_zoomed = true, -- defaults to false
    },
}

function M.config()
    local nvim_tmux_nav = require('nvim-tmux-navigation')

    keymap.normal('<M-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
    keymap.normal('<M-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
    keymap.normal('<M-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
    keymap.normal('<M-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
    keymap.normal('<M-Bslash>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
end

return M
