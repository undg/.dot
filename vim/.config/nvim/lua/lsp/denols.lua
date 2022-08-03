local nvim_lsp = require("lspconfig")

return {
    -- autostart = false

    single_file_support = false,
    -- Omitting some options
    root_dir = nvim_lsp.util.root_pattern("mod.ts", "deno.json"),
}
