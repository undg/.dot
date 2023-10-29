local keymap = require('utils.keymap')

-- Run...
keymap.normal('<Leader>vv', ':call VimuxRunCommand("./" . bufname("%"))<CR>')
keymap.normal('<Leader>vt', ':call VimuxRunCommand("tsc " . bufname("%"))<CR>')
keymap.normal('<Leader>vn', ':call VimuxRunCommand("node " . bufname("%"))<CR>')
keymap.normal('<Leader>vd', ':call VimuxRunCommand("deno run --allow-all " . bufname("%"))<CR>')

-- Prompt for a command to run
keymap.normal('<Leader>vp', ':VimuxPromptCommand<CR>')

-- Inspect runner pane
keymap.normal('<Leader>vi', ':VimuxInspectRunner<CR>')

-- Close vim tmux runner opened by VimuxRunCommand
keymap.normal('<Leader>vq', ':VimuxCloseRunner<CR>')

-- Interrupt any command running in the runner pane
keymap.normal('<Leader>vx', ':VimuxInterruptRunner<CR>')

-- Zoom the runner pane (use <bind-key> z to restore runner pane)
keymap.normal('<Leader>vz', ':call VimuxZoomRunner()<CR>')

-- Run last command executed by VimuxRunCommand
keymap.normal('<Leader>vl', ':VimuxRunLastCommand<CR>')

-- !RESTART LAST COMMAND
keymap.normal(
    '<Leader>vr',
    ':call VimuxInterruptRunner() <bar> :call VimuxInterruptRunner() <bar> :call VimuxRunLastCommand() <cr>'
)
