local keymap = require('utils.keymap')

-- Toggle spell check
keymap.normal('<F9>', ':setlocal spell! spell?<CR>')
keymap.insert('<F9>', '<ESC>:setlocal spell! spell?<CR>a')

-- More consistent movement.
keymap.normal('z]', ']s')
keymap.normal(']z', ']s')

keymap.normal('z[', '[s')
keymap.normal('[z', '[s')

keymap.normal('z=', ':Telescope spell_suggest<cr>')
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

keymap.normal('zs', '"zyiw :echon TransDefine()<cr>')
keymap.visual('zs', '"zy   :echon TransDefine()<cr>')

keymap.normal('zx', '"zyiw :call TransTranslate()<cr>')
keymap.visual('zx', '"zy   :call TransTranslate()<cr>')
--]]
