local map = require('utils.map')

-- This will execute the update command on leaving vim to a tmux pane. Default is Zero
vim.g.tmux_navigator_save_on_switch = 1
vim.g.tmux_navigator_no_mappings = 1

map.normal('<M-h>', ':<C-U>TmuxNavigateLeft<cr>')
map.normal('<M-j>', ':<C-U>TmuxNavigateDown<cr>')
map.normal('<M-k>', ':<C-U>TmuxNavigateUp<cr>')
map.normal('<M-l>', ':<C-U>TmuxNavigateRight<cr>')
map.normal('<M-Bslash>', ':<C-U>TmuxNavigatePrevious<cr>')
