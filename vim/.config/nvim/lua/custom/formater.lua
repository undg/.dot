-- @TODO auto install dependencies (`jq`)
-- @TODO polite error handler, current is rude
vim.api.nvim_create_user_command('FormatJson', ':%!jq', {})
vim.api.nvim_create_user_command('MinimiseJson', ':%!jq -c', {})

vim.api.nvim_create_user_command('FormatHtml', ':%!jh', {})
vim.api.nvim_create_user_command('MinimiseHtml', ':%!jh -c', {})
