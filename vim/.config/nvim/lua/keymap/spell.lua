-- Toggle spell check
Keymap.normal('<F9>', ':setlocal spell! spell?<CR>')
Keymap.insert('<F9>', '<ESC>:setlocal spell! spell?<CR>a')

-- More consistent movement.
Keymap.normal('z]', ']s')
Keymap.normal(']z', ']s')

Keymap.normal('z[', '[s')
Keymap.normal('[z', '[s')

Keymap.normal('z=', ':Telescope spell_suggest<cr>')
