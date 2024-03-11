-- Run...
Keymap.normal('<Leader>vv', ':call VimuxRunCommand("./" . bufname("%"))<CR>')
Keymap.normal('<Leader>vt', ':call VimuxRunCommand("tsc " . bufname("%"))<CR>')
Keymap.normal('<Leader>vn', ':call VimuxRunCommand("node " . bufname("%"))<CR>')
Keymap.normal('<Leader>vd', ':call VimuxRunCommand("deno run --allow-all " . bufname("%"))<CR>')

-- Prompt for a command to run
Keymap.normal('<Leader>vp', ':VimuxPromptCommand<CR>')

-- Inspect runner pane
Keymap.normal('<Leader>vi', ':VimuxInspectRunner<CR>')

-- Close vim tmux runner opened by VimuxRunCommand
Keymap.normal('<Leader>vq', ':VimuxCloseRunner<CR>')

-- Interrupt any command running in the runner pane
Keymap.normal('<Leader>vx', ':VimuxInterruptRunner<CR>')

-- Zoom the runner pane (use <bind-key> z to restore runner pane)
Keymap.normal('<Leader>vz', ':call VimuxZoomRunner()<CR>')

-- Run last command executed by VimuxRunCommand
Keymap.normal('<Leader>vl', ':VimuxRunLastCommand<CR>')

-- !RESTART LAST COMMAND
Keymap.normal(
    '<Leader>vr',
    ':call VimuxInterruptRunner() <bar> :call VimuxInterruptRunner() <bar> :call VimuxRunLastCommand() <cr>'
)
