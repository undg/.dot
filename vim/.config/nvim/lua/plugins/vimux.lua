return {
    'benmills/vimux', -- https://github.com/benmills/vimux
    cmd = { 'VimuxPromptCommand', 'VimuxRunCommand' },
    init = function()
        vim.g.VimuxDebug = false
        vim.g.VimuxHeight = 40
        vim.g.VimuxOpenExtraArgs = ''
        vim.g.VimuxOrientation = 'h'
        vim.g.VimuxPromptString = 'Run? '
        vim.g.VimuxResetSequence = 'q C-u'
        vim.g.VimuxRunnerName = ''
        vim.g.VimuxRunnerType = 'pane'
        vim.g.VimuxRunnerQuery = {}
        vim.g.VimuxTmuxCommand = 'tmux'
        vim.g.VimuxUseNearest = true
        vim.g.VimuxExpandCommand = false
        vim.g.VimuxCloseOnExit = false
        vim.g.VimuxCommandShell = false -- enable shell completion (disable arrow up)

        -- keys
        local keymap = require('utils.keymap')

        -- Run...
        keymap.normal('<Leader>vv', ':call VimuxRunCommand("./" . bufname("%"))<CR>')
        -- keymap.normal('<Leader>vt', ':call VimuxRunCommand("tsc " . bufname("%"))<CR>')
        -- keymap.normal('<Leader>vn', ':call VimuxRunCommand("node " . bufname("%"))<CR>')
        -- keymap.normal('<Leader>vd', ':call VimuxRunCommand("deno run --allow-all " . bufname("%"))<CR>')

        -- Prompt for a command to run
        keymap.normal('<Leader>vp', ':VimuxPromptCommand<CR>')

        -- Interrupt any command running in the runner pane
        keymap.normal('<Leader>vc', ':VimuxInterruptRunner<CR>')

        -- Run last command executed by VimuxRunCommand
        keymap.normal('<Leader>vl', ':VimuxRunLastCommand<CR>')

        -- !RESTART LAST COMMAND
        keymap.normal(
            '<Leader>vr',
            ':call VimuxInterruptRunner() <bar> :call VimuxInterruptRunner() <bar> :call VimuxRunLastCommand() <cr><cr>'
        )
    end,
}