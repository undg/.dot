local  ok_tb, tb = pcall(require, 'telescope.builtin')
if not ok_tb then
    print('plugins/telescope/goto: missing require')
    return
end

local  telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
    print('plugins/telescope/goto: missing require')
    return
end

local M = {}
local T = {}

function T.find() tb.find_files({hidden = true}) end
function T.browse() telescope.extensions.file_browser.file_browser({hidden = true}) end
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
