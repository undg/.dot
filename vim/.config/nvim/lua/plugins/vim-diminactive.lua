local M = {
    'blueyed/vim-diminactive', -- https://github.com/blueyed/vim-diminactive
}

function M.init()
    vim.g.diminactive_enable_focus = 1
end

return M
