local M = {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring', -- helper plugin for comment str,
        -- Highlight, edit, and navigate code using a fast incremental parsing library
        'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects for treesitter
    },
    build = ':TSUpdate',
}

M.config = function()
    local ensure_installed = {
        'html',
        'css',
        'scss',
        'graphql',
        'javascript',
        'jsdoc',
        'jsonc',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'tsx',
        'typescript',
        'vim',
        'yaml',
    }

    local ok_ts_configs, ts_configs = pcall(require, 'nvim-treesitter.configs')
    if not ok_ts_configs then
        print('plugins/treesitter.configs.lua: missing requirements')
        return
    end

    -- Treesitter configuration
    ts_configs.setup({
        modules = {},
        ignore_install = {},
        ensure_installed = ensure_installed,
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true, -- false will disable the whole extension
            use_languagetree = true,
            additional_vim_regex_highlighting = true,
            -- seen that on teej_dv stream, some magical extra powers to treesitter.
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-v>nm',
                node_incremental = '<c-v>n',
                scope_incremental = '<c-v>nn',
                node_decremental = '<c-v>m',
            },
        },
        indent = {
            enable = true,
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']]'] = '@function.outer',
                    [']v'] = '@class.outer',
                },
                goto_previous_start = {
                    ['[['] = '@function.outer',
                    ['[m'] = '@class.outer',
                },
                goto_next_end = {
                    [']['] = '@function.outer',
                    [']V'] = '@class.outer',
                },
                goto_previous_end = {
                    ['[]'] = '@function.outer',
                    ['[M'] = '@class.outer',
                },
            },
        },
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
        },
    })
end

return M
