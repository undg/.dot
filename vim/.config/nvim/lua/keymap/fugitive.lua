local keymap = require('utils.keymap')

keymap.normal('<leader>gcd', ':Gcd<CR>')
keymap.normal('<leader>glcd', ':Glcd<CR>')

keymap.normal('<leader>gll', ':0Gclog<CR>')
vim.api.nvim_create_user_command('GfileLog', '0Gclog', { force = true, })
keymap.normal('<leader>gld', ':Gclog -- %<CR>')
vim.api.nvim_create_user_command('GfileLogDiff', 'Gclog -- %', { force = true })

-- MAKE DAT SHIT CONSISTENT. tpope sucks
-- vim.api.nvim_del_user_command('Gblame')
-- vim.api.nvim_del_user_command('Gbrowse')
vim.api.nvim_create_user_command('Gblame', 'G blame', { force = true })
vim.api.nvim_create_user_command('Gbrowse', 'GBrowse', { force = true })
