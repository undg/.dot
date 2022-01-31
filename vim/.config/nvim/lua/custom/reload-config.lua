local map = require '../utils/map'

function _G.ReloadConfig()
    local hls_status = vim.v.hlsearch
    for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
    if hls_status == 0 then
        vim.opt.hlsearch = false
    end
end

map.normal('<Leader>vw', '<Cmd>lua ReloadConfig()<CR>'..'<CMD>source ' .. vim.env.MYVIMRC .. '<cr>:echom "Source MYVIMRC"<CR>')
vim.cmd('command! ReloadConfig lua ReloadConfig()')

-- @TODO this magic is not working as expected.
-- main part of whole config edit utility is in ../keymaps/edit-myvimrc.lua
