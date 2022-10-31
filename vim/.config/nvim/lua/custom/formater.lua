-- @TODO auto install dependencies (`jq`)
-- @TODO polite error handler, current is rude
vim.api.nvim_create_user_command("JsonPrettier", ":%!jq", {})
vim.api.nvim_create_user_command("JsonMinimise", ":%!jq -c", {})

vim.api.nvim_create_user_command("HtmlPrettier", ":%!jh", {})
vim.api.nvim_create_user_command("HtmlMinimise", ":%!jh -c", {})
