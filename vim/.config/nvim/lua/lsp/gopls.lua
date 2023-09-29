local nvim_lsp = require('lspconfig')

return {
    root_dir = nvim_lsp.util.root_pattern('go.work', 'go.mod', '.git'),
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
}
