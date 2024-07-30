local M = {
    'akinsho/bufferline.nvim', -- https://github.com/akinsho/bufferline.nvim
    dependencies = {
        -- :Bdelete and :Bwipeout to preserve window layout
        { 'moll/vim-bbye' },               -- https://github.com/moll/vim-bbye
        { 'nvim-tree/nvim-web-devicons' }, -- https://github.com/nvim-tree/nvim-web-devicons
    },
    version = '*',
}

local opts = {
    options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        numbers = function(opts)
            return opts.lower(opts.ordinal)
        end, -- "both", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = 'Bdelete! %d', -- can be a string | function, see "Mouse actions"
        right_mouse_command = 'vertical sbuffer %d', -- can be a string | function, see "Mouse actions"
        middle_mouse_command = 'horizontal sbuffer %d', -- can be a string | function, see "Mouse actions"
        left_mouse_command = 'buffer %d', -- can be a string | function, see "Mouse actions"
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon', -- 'icon' | 'underline' | 'none',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,   -- prefix used when a buffer is de-duplicated
        truncate_names = true,    -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = 'nvim_lsp', -- false | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count, level) --, diagnostics_dict, context
            local icon = ' ℹ'
            if level == 'error' then
                icon = ' '
            end
            if level == 'warning' then
                icon = ' '
            end

            return count .. icon
        end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = nil,
        color_icons = true,             -- true | false, -- whether or not to add the filetype icon highlights
        show_buffer_icons = true,       -- true | false, -- disable filetype icons for buffers
        show_buffer_close_icons = true, -- true | false,
        show_close_icon = true,         -- true | false,
        show_tab_indicators = true,     -- true | false,
        show_duplicate_prefix = true,   -- true | false, -- whether to show duplicate buffer prefix
        persist_buffer_sort = true,     -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = 'slant', -- "slant" | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
            enabled = false,
            delay = 200,
            reveal = { 'close' },
        },
        sort_by = 'id', --"insert_after_current" |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' |
        -- sort_by = function(buffer_a, buffer_b) -- add custom logic
        --     return buffer_a.modified > buffer_b.modified
        -- end
    },
}

function M.config()
    local bufferline_ok, bufferline = pcall(require, 'bufferline')
    local wkey_ok, wk = pcall(require, 'which-key')

    local not_ok = not bufferline_ok and 'bufferline' --
        or not wkey_ok and 'which-key'
        or false

    if not_ok then
        vim.notify('plugins/bufferline.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
        return
    end

    bufferline.setup(opts)

    -- Select/Goto
    Keymap.normal('<leader>bp', ':BufferLineCyclePrev<cr>')
    Keymap.normal('<leader>bn', ':BufferLineCycleNext<cr>')

    Keymap.normal('<leader>j', function()
        bufferline.go_to_buffer(1, true)
    end)
    Keymap.normal('<leader>k', function()
        bufferline.go_to_buffer(2, true)
    end)
    Keymap.normal('<leader>l', function()
        bufferline.go_to_buffer(3, true)
    end)
    Keymap.normal('<leader>;', function()
        bufferline.go_to_buffer(4, true)
    end)
    Keymap.normal("<leader>'", function()
        bufferline.go_to_buffer(5, true)
    end)
    Keymap.normal('<leader>$', function()
        bufferline.go_to_buffer(-1, true)
    end)

    -- Pin
    Keymap.normal('<leader>bb', ':BufferLineTogglePin<cr>')

    -- Move
    Keymap.normal('<C-j>', ':BufferLineMovePrev<cr>')
    Keymap.normal('<C-k>', ':BufferLineMoveNext<cr>')
    Keymap.normal('<C-h>', ':BufferLineCyclePrev<cr>')
    Keymap.normal('<C-l>', ':BufferLineCycleNext<cr>')

    -- Close
    local CMD_CLOSE_GO_NEXT = ':BufferLineCycleNext<CR>:BufferLineCyclePrev<CR>:Bdelete<cr>'
    local CMD_CLOSE_GO_PREV = ':Bdelete<cr>'
    Keymap.normal('<leader>qq', CMD_CLOSE_GO_NEXT)

    Keymap.normal('<C-Q>', CMD_CLOSE_GO_PREV)

    wk.add({
        { '<leader>b',   group = 'Buffer' },
        { '<leader>bc',  group = 'Buffer Close' },
        { '<leader>bcc', CMD_CLOSE_GO_PREV,           desc = 'Close Buffer go prev' },
        { '<C-Q>',       CMD_CLOSE_GO_PREV,           desc = 'Close Buffer go prev' },
        { '<leader>bC',  CMD_CLOSE_GO_NEXT,           desc = 'Close Buffer go next' },
        { '<leader>qq',  CMD_CLOSE_GO_NEXT,           desc = 'Close Buffer go next' },
        { '<leader>bch', ':BufferLineCloseLeft<CR>',  desc = 'BufferLineCloseLeft' },
        { '<leader>bcl', ':BufferLineCloseRight<CR>', desc = 'BufferLineCloseRight' },
    })
end

return M
