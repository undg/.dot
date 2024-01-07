return {
    'vimwiki/vimwiki',
    init = function()
        vim.g.vimwiki_list = {
            {
                path = '~/vimwiki',
                syntax = 'markdown',
                ext = '.md',
            },
        }

        vim.g.vimwiki_key_mappings = { ['links'] = 0 }
    end,
}
