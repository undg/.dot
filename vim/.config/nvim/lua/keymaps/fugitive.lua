local map = require('utils.map')

map.normal('<leader>gcd', ':Gcd<CR>')
map.normal('<leader>glcd', ':Glcd<CR>')

map.normal('<leader>gll', ':0Gclog<CR>')
map.normal('<leader>gld', ':Gclog -- %<CR>')

-- make shit consistent.
vim.api.nvim_create_user_command('Gblame', 'G blame', {})
