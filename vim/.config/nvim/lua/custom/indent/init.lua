vim.api.nvim_create_user_command('ToggleIndent', "lua R('custom.indent.indent').toggle()", {})
