local nvim_lsp = require('lspconfig')

local ok_twoslash, twoslash = pcall(require, 'twoslash-queries')
if not ok_twoslash then
    print('lua/lsp/tsserver.lua: twoslash-queries fail')
    return
end

return {
    root_dir = nvim_lsp.util.root_pattern('deno.json'),
    -- autostart = false,
    single_file_support = false,
    init_options = {
        lint = true,
    },
    on_attach = function(client, bufnr)
        twoslash.attach(client, bufnr)
    end,
}
