local cmp = require("cmp") -- completion
local lspkind = require("lspkind") -- icons
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings") -- UltiSnips

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

cmp.setup({
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            end
        end),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                cmp_ultisnips_mappings.jump_backwards(fallback)
            end
        end),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "ultisnips" },
        { name = "buffer", keyword_length = 4 },
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            maxwidth = 50,
            menu = {
                buffer = "[©]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[lua]",
                path = "[📂]",
                ultisnips = "[✂]",
            },
        }),
    },
    -- experimental = {
    --     native_menu = false,
    -- },
})
