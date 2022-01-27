local nvim_lsp = require("lspconfig")

return {
    -- autostart = false

    -- Omitting some options
    root_dir = nvim_lsp.util.root_pattern("deno.json"),
}
