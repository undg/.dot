local M = {}

local T = {}

local tb = require('telescope.builtin')
local t = require('telescope')

function T.find() tb.find_files({hidden = true}) end
function T.browse() t.extensions.file_browser.file_browser({hidden = true}) end
function T.git() tb.git_status({hidden = true}) end
function T.grep() tb.live_grep({hidden = true}) end

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
