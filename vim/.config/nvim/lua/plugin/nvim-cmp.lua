return {
    'hrsh7th/nvim-cmp',
    config = function()
        local ok_cmp, cmp = pcall(require, 'cmp')
        local ok_lspkind, lspkind = pcall(require, 'lspkind')
        local ok_cmp_ultisnips_mappings, cmp_ultisnips_mappings = pcall(require, 'cmp_nvim_ultisnips.mappings')

        if not ok_cmp or not ok_lspkind or not ok_cmp_ultisnips_mappings then
            print('plugins/nvim-cmp.lua: missing requirements')
            return
        end

        -- Set completeopt to have a better completion experience
        vim.o.completeopt = 'menuone,noselect'

        cmp.setup({
            mapping = {
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<Up>'] = cmp.mapping.select_prev_item(),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<Down>'] = cmp.mapping.select_next_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-u>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.close(),
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true,
                }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                    end
                end),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    end
                end),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'nvim_lua' },
                { name = 'path' },
                { name = 'ultisnips' },
                { name = 'buffer',   keyword_length = 4 },
                { name = 'spell' },
                { name = 'codeium' },
                -- { name = 'cody' },
            },
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
                end,
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol',
                    ellipsis_char = '...',

                    with_text = false,
                    maxwidth = 50,
                    menu = {
                        nvim_lsp = '',
                        nvim_lua = '',
                        path = '',
                        ultisnips = '✂',
                        buffer = '',
                        spell = '',
                        codeium = '',
                        -- cody = '',
                    },
                }),
            },
        })
    end,
    dependencies = {
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-nvim-lsp',
        'quangnguyen30192/cmp-nvim-ultisnips',
    },
}
