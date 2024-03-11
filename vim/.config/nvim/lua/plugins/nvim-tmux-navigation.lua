local M = {
    'alexghergh/nvim-tmux-navigation', -- https://github.com/alexghergh/nvim-tmux-navigation
}

M.opts = {
    disable_when_zoomed = true, -- defaults to false
}

function M.init()
    local nvim_tmux_nav = require('nvim-tmux-navigation')

    Keymap.normal('<M-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
    Keymap.normal('<M-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
    Keymap.normal('<M-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
    Keymap.normal('<M-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
    Keymap.normal('<M-Bslash>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
end

return M
