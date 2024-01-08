return {
    'vimwiki/vimwiki', -- https://github.com/vimwiki/vimwiki
    cmd = {
        'VimwikiIndex',
        'VimwikiTabIndex',
        'VimwikiTabMakeDiaryNote',
        'VimwikiUiSelect',
        'VimwikiDiaryIndex',
    },
    init = function()
        vim.g.vimwiki_list = {
            {
                path = '~/Dropbox/vimwiki',
                syntax = 'markdown',
                ext = '.md',
            },
        }

        vim.g.vimwiki_key_mappings = { ['links'] = 0 }
    end,
}
