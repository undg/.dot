local map = require('utils.map')

-- Toggle spell check
map.normal('<F7>', ':setlocal spell! spell?<CR>')
map.insert('<F7>', '<ESC>:setlocal spell! spell?<CR>a')

-- More consistent movement.
map.normal('z]', ']s')
map.normal(']z', ']s')

map.normal('z[', '[s')
map.normal('[z', '[s')

map.normal('z=', ':Telescope spell_suggest<cr>')
--[[
vim.cmd[[
function! Getreg()
┊   return substitute(getreg('z'), '[^a-zA-Z0-9 .,:]', ' ' , 'g')
endfunction

function! TransDefine()
┊   return system('trans -no-ansi -speak -join-sentence ' . Getreg())
endfunction

function! TransTranslate()
┊   return system('trans en:pl --play --brief -join-sentence ' . Getreg())
endfunction

map.normal('zs', '"zyiw :echon TransDefine()<cr>')
map.visual('zs', '"zy   :echon TransDefine()<cr>')

map.normal('zx', '"zyiw :call TransTranslate()<cr>')
map.visual('zx', '"zy   :call TransTranslate()<cr>')
--]]
