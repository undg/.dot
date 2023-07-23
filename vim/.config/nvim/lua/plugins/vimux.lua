return {
    'benmills/vimux', -- build comand(test) in split tmux pane
    config = function()
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
    end,
}
