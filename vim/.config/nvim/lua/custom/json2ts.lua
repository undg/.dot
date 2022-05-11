-- @TODO auto install dependencies (`npm i -g json-ts`)
-- @TODO polite error handler, current is rude
vim.api.nvim_create_user_command('Json2ts', "r!xclip -o | json-ts --stdin", {})

