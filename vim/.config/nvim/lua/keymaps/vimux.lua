local map = require'../utils/map'

-- Run...
map.normal('<Leader>vv', ':call VimuxRunCommand("./" . bufname("%"))<CR>')
map.normal('<Leader>vt', ':call VimuxRunCommand("tsc " . bufname("%"))<CR>')
map.normal('<Leader>vn', ':call VimuxRunCommand("node " . bufname("%"))<CR>')
map.normal('<Leader>vd', ':call VimuxRunCommand("deno run " . bufname("%"))<CR>')

-- Prompt for a command to run
map.normal('<Leader>vp', ':VimuxPromptCommand<CR>')

-- Inspect runner pane
map.normal('<Leader>vi', ':VimuxInspectRunner<CR>')

-- Close vim tmux runner opened by VimuxRunCommand
map.normal('<Leader>vq', ':VimuxCloseRunner<CR>')

-- Interrupt any command running in the runner pane
map.normal('<Leader>vx', ':VimuxInterruptRunner<CR>')

-- Zoom the runner pane (use <bind-key> z to restore runner pane)
map.normal('<Leader>vz', ':call VimuxZoomRunner()<CR>')

-- Run last command executed by VimuxRunCommand
map.normal('<Leader>vl', ':VimuxRunLastCommand<CR>')

-- !RESTART LAST COMMAND
map.normal('<Leader>vr', ':call VimuxInterruptRunner() <bar> :call VimuxInterruptRunner() <bar> :call VimuxRunLastCommand() <cr>')

