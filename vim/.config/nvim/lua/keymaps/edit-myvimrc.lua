local map = require'../utils/map'

-- Open vimrc with ',ev'
map.normal('<leader>ve', '<CMD>tabnew ' .. vim.env.MYVIMRC .. ' | lcd %:p:h<CR>')
map.normal('<leader>vc', '<CMD>source %<CR>:echom "SOURCE current file"<CR>')

