local keymap = require('utils.keymap')

local get_visual_selection = require('custom.get-visual-selection')

local tb = require('telescope.builtin')

local tb_opt = {
    fname_width = 0.5,
    trim_text = false,
    show_line = false,
    include_current_line = true,
}

-- Core
keymap.normal('<leader>m', ':Telescope<cr>')
keymap.normal(',.', ':Telescope find_files hidden=false<cr>')
keymap.normal('<leader>,', ':Telescope find_files hidden=true<cr>')
keymap.normal(
    '<leader>.',
    ':lua require("telescope").extensions.file_browser.file_browser({hidden = true, path = "%:p:h", grouped = false, hide_parent_dir = false, select_buffer = true, respect_gitignore = true })<cr>'
)


keymap.normal('<leader>fb', ':Telescope buffers<cr>')
keymap.normal('<leader>fg', ':Telescope live_grep<cr>')
keymap.normal('<leader>fr', ':Telescope resume<cr>')

local open_quick_fix_window_in_telescope = function()
    vim.cmd('cclose')
    tb.quickfix({ fname = 0.5, trim_text = false, show_line = false })
end
keymap.normal('fq', open_quick_fix_window_in_telescope)
keymap.normal('<leader>gq', open_quick_fix_window_in_telescope)
keymap.normal('<leader>gc', open_quick_fix_window_in_telescope)

keymap.normal('<leader>fQ', ':Telescope quickfixhistory<cr>')
keymap.normal('<leader>fp', ':Telescope project<cr>')
keymap.normal('<leader>fo', ':Telescope oldfiles cwd_only=true<cr>')
keymap.normal('<leader>fh', ':Telescope help_tags<cr>')
keymap.normal('<leader>fm', ':Telescope keymaps<cr>')
keymap.normal('<leader>f;', ':Telescope commands<cr>')

-- Custom goto commands
keymap.normal('<leader>ve', ':GotoVimFind<cr>')
keymap.normal('<leader>fvf', ':GotoVimFind<cr>')
keymap.normal('<leader>fvb', ':GotoVimBrowse<cr>')
keymap.normal('<leader>fvs', ':GotoVimGit<cr>')
keymap.normal('<leader>fvg', ':GotoVimGrep<cr>')

keymap.normal('<leader>fzf', ':GotoZshFind<cr>')
keymap.normal('<leader>fzb', ':GotoZshBrowse<cr>')
keymap.normal('<leader>fzs', ':GotoZshGit<cr>')
keymap.normal('<leader>fzg', ':GotoZshGrep<cr>')

keymap.normal('<leader>fdf', ':GotoDotFind<cr>')
keymap.normal('<leader>fdb', ':GotoDotBrowse<cr>')
keymap.normal('<leader>fds', ':GotoDotGit<cr>')
keymap.normal('<leader>fdg', ':GotoDotGrep<cr>')

keymap.normal('<leader>fcf', ':GotoCodeFind<cr>')
keymap.normal('<leader>fcb', ':GotoCodeBrowse<cr>')
keymap.normal('<leader>fcs', ':GotoCodeGit<cr>')
keymap.normal('<leader>fcg', ':GotoCodeGrep<cr>')

keymap.visual('<leader>fg', function()
    tb.live_grep({ default_text = get_visual_selection() })
end, { noremap = true, silent = true })
