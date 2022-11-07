local nvim_lsp = require("lspconfig")

return {
    root_dir = nvim_lsp.util.root_pattern("deno.json"),
    -- autostart = false,
    single_file_support = false,
    init_options = {
        lint = true,
    },
}
