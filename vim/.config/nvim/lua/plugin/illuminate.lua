local map = require('utils.map')
return {
    'RRethy/vim-illuminate', -- automatically highlighting other uses of the word under the cursor
    config = function()
        local ok_illuminate, illuminate = pcall(require, 'illuminate')
        if not ok_illuminate then
            print('plugins/illuminate.lua: missing requirements')
            return
        end

        illuminate.configure({
            -- providers: provider used to get references in the buffer, ordered by priority
            providers = {
                'lsp',
                'treesitter',
                'regex',
            },
            -- delay: delay in milliseconds
            delay = 100,
            -- filetype_overrides: filetype specific overrides.
            -- The keys are strings to represent the filetype while the values are tables that
            -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
            filetype_overrides = {},
            -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
            filetypes_denylist = {
                'dirvish',
                'fugitive',
            },
            -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
            filetypes_allowlist = {},
            -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
            -- See `:help mode()` for possible values
            modes_denylist = {},
            -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
            -- See `:help mode()` for possible values
            modes_allowlist = {},
            -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_denylist = {},
            -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
            -- Only applies to the 'regex' provider
            -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
            providers_regex_syntax_allowlist = {},
            -- under_cursor: whether or not to illuminate under the cursor
            under_cursor = true,
            -- large_file_cutoff: number of lines at which to use large_file_config
            -- The `under_cursor` option is disabled when this cutoff is hit
            large_file_cutoff = nil,
            -- large_file_config: config to use for large files (based on large_file_cutoff).
            -- Supports the same keys passed to .configure
            -- If nil, vim-illuminate will be disabled for large files.
            large_file_overrides = nil,
            -- min_count_to_highlight: minimum number of matches required to perform highlighting
            min_count_to_highlight = 1,
        })

        local function toogle_IlluminateWordRead(current_value)
            -- @TODO (undg) 2023-10-16: get that from hl and store on the side, it's default only for gruvbox, or this plugin in dark mode
            local normal_hex = '191919'
            -- @TODO (undg) 2023-10-16: find nice color for flashlighting 
            local bold_hex = 'ffffff'

            local bold_dec = tonumber(bold_hex, 16)
            -- local bold_dec = 16777215 -- ffffff

            local normal_color = '#' .. normal_hex
            local bold_color = '#' .. bold_hex

            if current_value == bold_dec then
                vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = normal_color })
                print('hl toogle_IlluminateWordRead(bold) |', 'hex: #' .. string.format('%06x', current_value), '| dec:', current_value)
            else
                vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = bold_color })
                print('hl toogle_IlluminateWordRead(norm) |', 'hex: #' .. string.format('%06x', current_value), '| dec:', current_value)
            end
        end

        map.normal('<leader>*', function()
            toogle_IlluminateWordRead(vim.api.nvim_get_hl_by_name('IlluminatedWordRead', true).background)
        end)
        map.normal('<leader>8', function()
            toogle_IlluminateWordRead(vim.api.nvim_get_hl_by_name('IlluminatedWordRead', true).background)
        end)
    end,
}
