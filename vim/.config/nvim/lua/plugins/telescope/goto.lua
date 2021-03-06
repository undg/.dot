local M = {}

local T = {}
function T.find() require('telescope.builtin').find_files({hidden = true}) end
function T.browse() require('telescope').extensions.file_browser.file_browser({hidden = true}) end
function T.git() require('telescope.builtin').git_status({hidden = true}) end
function T.grep() require('telescope.builtin').live_grep({hidden = true}) end

function M.vim()
    vim.cmd [[ :cd  ~/.dot/vim/.config/nvim/ ]]
    return T
end

function M.zsh()
    vim.cmd [[ :cd  ~/.dot/zsh/ ]]
    return T
end

function M.dot()
    vim.cmd [[ :cd  ~/.dot/ ]]
    return T
end

function M.code()
    vim.cmd [[ :cd  ~/Code/ ]]
    return T
end

function M.hmrc()
    vim.cmd [[ :cd  ~/Code/Pega/hmrc-react/ ]]
    return T
end

return M
