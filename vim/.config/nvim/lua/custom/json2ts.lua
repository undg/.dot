-- @TODO auto install dependencies (`npm i -g json-ts`)
vim.cmd [[command Json2ts :r!xclip -o | json-ts --stdin<cr>]]

