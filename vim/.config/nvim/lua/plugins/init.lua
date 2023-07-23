return {
    -- { import = 'plugins' }, -- Import everything from plugins folder and merge with this table.

    -- Dependencies
    'nvim-lua/plenary.nvim', -- All the lua functions you don't want to write twice.
    'onsails/lspkind-nvim',  -- icons for lsp
    { import = 'plugins.devicons' },

    -- Productivity
    { import = 'plugins.comment' },
    'tpope/vim-sleuth', -- Auto-detect indentation style
    {
        'kylechui/nvim-surround',
        version = '*', -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            local ok_nvim_surround, nvim_surround = pcall(require, 'nvim-surround')
            if not ok_nvim_surround then
                print('plugins/nvim-surround.lua: missing requirements')
                return
            end

            nvim_surround.setup({
                -- Configuration here, or leave empty to use defaults
                -- :h nvim-surround.configuration.
            })
        end,
    },
    'jiangmiao/auto-pairs',
    {
        'folke/trouble.nvim',
        config = function()
            local ok_trouble, trouble = pcall(require, 'trouble')
            if not ok_trouble then
                print('plugins/trouble.lua: missing requirements')
                return
            end

            trouble.setup({
                position = 'bottom',            -- position of the list can be: bottom, top, left, right
                height = 10,                    -- height of the trouble list when position is top or bottom
                width = 50,                     -- width of the list when position is left or right
                icons = true,                   -- use devicons for filenames
                mode = 'workspace_diagnostics', -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
                fold_open = '',              -- icon used for open folds
                fold_closed = '',            -- icon used for closed folds
                group = true,                   -- group results by file
                padding = true,                 -- add an extra new line on top of the list
                action_keys = {                 -- key mappings for actions in the trouble list
                    -- map to {} to remove a mapping, for example:
                    -- close = {},
                    close = 'q',                   -- close the list
                    cancel = '<esc>',              -- cancel the preview and get back to your last window / buffer / cursor
                    refresh = 'r',                 -- manually refresh
                    jump = { '<cr>', '<tab>' },    -- jump to the diagnostic or open / close folds
                    open_split = { '<c-x>' },      -- open buffer in new split
                    open_vsplit = { '<c-v>' },     -- open buffer in new vsplit
                    open_tab = { '<c-t>' },        -- open buffer in new tab
                    jump_close = { 'o' },          -- jump to the diagnostic and close the list
                    toggle_mode = 'm',             -- toggle between "workspace" and "document" diagnostics mode
                    toggle_preview = 'P',          -- toggle auto_preview
                    hover = 'K',                   -- opens a small popup with the full multiline message
                    preview = 'p',                 -- preview the diagnostic location
                    close_folds = { 'zM', 'zm' },  -- close all folds
                    open_folds = { 'zR', 'zr' },   -- open all folds
                    toggle_fold = { 'zA', 'za' },  -- toggle fold of current file
                    previous = 'k',                -- preview item
                    next = 'j',                    -- next item
                },
                indent_lines = true,               -- add an indent guide below the fold icons
                auto_open = false,                 -- automatically open the list when you have diagnostics
                auto_close = false,                -- automatically close the list when you have no diagnostics
                auto_preview = true,               -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
                auto_fold = false,                 -- automatically fold a file trouble list at creation
                auto_jump = { 'lsp_definitions' }, -- for the given modes, automatically jump if there is only a single result
                signs = {
                    -- icons / text used for a diagnostic
                    error = '',
                    warning = '',
                    hint = '',
                    information = '',
                    other = '﫠',
                },
                use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
            })
        end,
    },
    { import = 'plugins.alpha' },
    {
        'Shatur/neovim-session-manager',
        config = function()
            local ok_session_manager, session_manager = pcall(require, 'session_manager')
            local ok_path, path = pcall(require, 'plenary.path')
            local ok_config, _ = pcall(require, 'session_manager.config')

            if not ok_session_manager or not ok_path or not ok_config then
                print('lua/plugins/neovim-session-manager.lua: missing requirements')
                return
            end

            ---@param mode 'Disabled'|'CurrentDir'|'LastSession'
            function AutoloadModeName(mode)
                return mode
            end

            session_manager.setup({
                sessions_dir = path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
                path_replacer = '__',                                        -- The character to which the path separator will be replaced for session files.
                colon_replacer = '++',                                       -- The character to which the colon symbol will be replaced for session files.
                autoload_mode = AutoloadModeName('Disabled'),                -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
                autosave_last_session = true,                                -- Automatically save last session on exit and on session switch.
                autosave_ignore_not_normal = true,                           -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
                autosave_ignore_dirs = { '.ssh' },                           -- A list of directories where the session will not be autosaved.
                autosave_ignore_filetypes = {                                -- All buffers of these file types will be closed before the session is saved.
                    'gitcommit',
                },
                autosave_ignore_buftypes = {},    -- All buffers of these bufer types will be closed before the session is saved.
                autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
                max_path_length = 80,             -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
            })
        end,
    },
    {
        'phaazon/hop.nvim',
        config = function()
            local ok_hop, hop = pcall(require, 'hop')
            local ok_hint, hint = pcall(require, 'hop.hint')
            if not ok_hop or not ok_hint then
                print('plugins/hop: missing requirements')
                return
            end

            hop.setup()
            local directions = hint.HintDirection
            vim.keymap.set('', 'f', function()
                hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
            end, { remap = true })
            vim.keymap.set('', 'F', function()
                hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
            end, { remap = true })
            vim.keymap.set('', 't', function()
                hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
            end, { remap = true })
            vim.keymap.set('', 'T', function()
                hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
            end, { remap = true })
        end,
    },
    {
        'lambdalisue/suda.vim',
        config = function()
            vim.g.suda_smart_edit = 1
        end,
    }, -- ask for sudo password
    {
        'rafcamlet/nvim-luapad',
        config = function()
            local ok_luapad, luapad = pcall(require, 'luapad')
            if not ok_luapad then
                print('plugins/luapad.lua: missing requirements')
                return
            end

            luapad.setup({
                count_limit = 150000,
                error_indicator = false,
                eval_on_move = true,
                error_highlight = 'WarningMsg',
                on_init = function()
                    print('Hello from Luapad!')
                end,
                context = {
                    the_answer = 42,
                    shout = function(str)
                        return (string.upper(str) .. '!')
                    end,
                },
            })
        end,
    }, -- lua scratch pad

    -- Git
    {
        'kdheepak/lazygit.nvim',
        config = function()
            vim.g.lazygit_floating_window_winblend = 0                          -- transparency of floating window
            vim.g.lazygit_floating_window_scaling_factor = 0.9                  -- scaling factor for floating window
            vim.g.lazygit_floating_window_border_chars =
            "['╭', '╮', '╰', '╯']"                                      -- customize lazygit popup window corner characters
            vim.g.lazygit_floating_window_use_plenary = 0                       -- use plenary.nvim to manage floating window if available
            vim.g.lazygit_use_neovim_remote = 0                                 -- fallback to 0 if neovim-remote is not installed
            vim.g.lazygit_use_custom_config_file_path = 0                       -- config file path is evaluated if this value is 1
            vim.g.lazygit_config_file_path = ''                                 -- custom config file path
        end,
    },
    'tpope/vim-fugitive',          -- Git commands in nvim
    { 'tpope/vim-rhubarb' },       -- Fugitive-companion to interact with github
    {
        'lewis6991/gitsigns.nvim', -- Git status for every line
        config = function()
            local ok_gitsigns, gitsigns = pcall(require, 'gitsigns')
            if not ok_gitsigns then
                print('plugins/gitsigns.lua: missing requirement')
                return
            end

            gitsigns.setup({
                signs = {
                    add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
                    change = {
                        hl = 'GitSignsChange',
                        text = '~',
                        numhl = 'GitSignsChangeNr',
                        linehl = 'GitSignsChangeLn',
                    },
                    delete = {
                        hl = 'GitSignsDelete',
                        text = '_',
                        numhl = 'GitSignsDeleteNr',
                        linehl = 'GitSignsDeleteLn',
                    },
                    topdelete = {
                        hl = 'GitSignsDelete',
                        text = '‾',
                        numhl = 'GitSignsDeleteNr',
                        linehl = 'GitSignsDeleteLn',
                    },
                    changedelete = {
                        hl = 'GitSignsChange',
                        text = '~',
                        numhl = 'GitSignsChangeNr',
                        linehl = 'GitSignsChangeLn',
                    },
                    untracked = { hl = 'GitSignsAdd', text = '┆', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
                },
                signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
                numhl = true,      -- Toggle with `:Gitsigns toggle_numhl`
                linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
                word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = function(status)
                    local added, changed, removed = status.added, status.changed, status.removed
                    local status_txt = {}
                    if added and added > 0 then
                        table.insert(status_txt, '+' .. added)
                    end
                    if changed and changed > 0 then
                        table.insert(status_txt, '~' .. changed)
                    end
                    if removed and removed > 0 then
                        table.insert(status_txt, '-' .. removed)
                    end
                    return table.concat(status_txt, ' ')
                end,
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1,
                },
                yadm = {
                    enable = false,
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']}', function()
                        if vim.wo.diff then
                            return ']}'
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return '<Ignore>'
                    end, { expr = true })

                    map('n', '[{', function()
                        if vim.wo.diff then
                            return '[{'
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return '<Ignore>'
                    end, { expr = true })

                    -- Actions
                    map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>')
                    -- map({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
                    map('n', '<leader>gs', gs.stage_hunk)
                    map('n', '<leader>gu', gs.reset_hunk)
                    map('n', '<leader>gp', gs.preview_hunk)
                    -- map('n', '<leader>hR', gs.reset_buffer)
                    -- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
                    -- map('n', '<leader>tb', gs.toggle_current_line_blame)
                    -- map('n', '<leader>hd', gs.diffthis)
                    -- map('n', '<leader>hD', function() gs.diffthis('~') end)
                    -- map('n', '<leader>td', gs.toggle_deleted)

                    -- Text object
                    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end,
            })
        end,
    },
    {
        'whiteinge/diffconflicts',
    },

    -- File managers
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        dependencies = {
            'MunifTanjim/nui.nvim',
        },
        config = function()
            local ok_neoTree, neoTree = pcall(require, 'neo-tree')
            if not ok_neoTree then
                print('plugins/neo-tree.lua: missing requirements')
                return
            end

            -- Unless you are still migrating, remove the deprecated commands from v1.x
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
            vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
            vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
            vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
            -- NOTE: this is changed from v1.x, which used the old style of highlight groups
            -- in the form "LspDiagnosticsSignWarning"

            neoTree.setup({
                -- If a user has a sources list it will replace this one.
                -- Only sources listed here will be loaded.
                -- You can also add an external source by adding it's name to this list.
                -- The name used here must be the same name you would use in a require() call.
                sources = {
                    'filesystem',
                    'buffers',
                    'git_status',
                },
                add_blank_line_at_top = false, -- Add a blank line at the top of the tree.
                close_if_last_window = false,  -- Close Neo-tree if it is the last window left in the tab
                -- popup_border_style is for input and confirmation dialogs.
                -- Configuration of floating window is done in the individual source sections.
                -- "NC" is a special style that works well with NormalNC set
                close_floats_on_escape_key = true,
                default_source = 'filesystem',
                enable_diagnostics = true,
                enable_git_status = true,
                enable_modified_markers = true, -- Show markers for files with unsaved changes.
                enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
                git_status_async = true,
                -- These options are for people with VERY large git repos
                git_status_async_options = {
                    batch_size = 1000, -- how many lines of git status results to process at a time
                    batch_delay = 10,  -- delay in ms between batches. Spreads out the workload to let other processes run.
                    max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
                    -- Anything before this will be used. The last items to be processed are the untracked files.
                },
                hide_root_node = false,            -- Hide the root node.
                retain_hidden_root_indent = false, -- IF the root node is hidden, keep the indentation anyhow.
                -- This is needed if you use expanders because they render in the indent.
                log_level = 'info',                -- "trace", "debug", "info", "warn", "error", "fatal"
                log_to_file = false,               -- true, false, "/path/to/file.log", use :NeoTreeLogs to show the file
                open_files_in_last_window = true,  -- false = open files in top left window
                popup_border_style = 'NC',         -- "double", "none", "rounded", "shadow", "single" or "solid"
                resize_timer_interval = 500,       -- in ms, needed for containers to redraw right aligned and faded content
                -- set to -1 to disable the resize timer entirely
                --                           -- NOTE: this will speed up to 50 ms for 1 second following a resize
                sort_case_insensitive = false, -- used when sorting files and directories in the tree
                sort_function = nil,           -- uses a custom function for sorting files and directories in the tree
                use_popups_for_input = true,   -- If false, inputs will use vim.ui.input() instead of custom floats.
                use_default_mappings = true,
                -- source_selector provides clickable tabs to switch between sources.
                source_selector = {
                    winbar = false,                        -- toggle to show selector on winbar
                    statusline = false,                    -- toggle to show selector on statusline
                    show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
                    -- of the top visible node when scrolled down.
                    sources = {                            -- falls back to source_name if nil
                        filesystem = '  Files ',
                        buffers = '  Buffers ',
                        git_status = '  Git ',
                        diagnostics = ' 裂Diagnostics ',
                    },
                    content_layout = 'start', -- only with `tabs_layout` = "equal", "focus"
                    --                start  : |/ 裡 bufname     \/...
                    --                end    : |/     裡 bufname \/...
                    --                center : |/   裡 bufname   \/...
                    tabs_layout = 'equal', -- start, end, center, equal, focus
                    --             start  : |/  a  \/  b  \/  c  \            |
                    --             end    : |            /  a  \/  b  \/  c  \|
                    --             center : |      /  a  \/  b  \/  c  \      |
                    --             equal  : |/    a    \/    b    \/    c    \|
                    --             active : |/  focused tab    \/  b  \/  c  \|
                    truncation_character = '…', -- character to use when truncating the tab label
                    tabs_min_width = nil,       -- nil | int: if int padding is added based on `content_layout`
                    tabs_max_width = nil,       -- this will truncate text even if `text_trunc_to_fit = false`
                    padding = 0,                -- can be int or table
                    -- padding = { left = 2, right = 0 },
                    -- separator = "▕", -- can be string or table, see below
                    separator = { left = '▏', right = '▕' },
                    -- separator = { left = "/", right = "\\", override = nil },     -- |/  a  \/  b  \/  c  \...
                    -- separator = { left = "/", right = "\\", override = "right" }, -- |/  a  \  b  \  c  \...
                    -- separator = { left = "/", right = "\\", override = "left" },  -- |/  a  /  b  /  c  /...
                    -- separator = { left = "/", right = "\\", override = "active" },-- |/  a  / b:active \  c  \...
                    -- separator = "|",                                              -- ||  a  |  b  |  c  |...
                    separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
                    show_separator_on_edge = false,
                    --                       true  : |/    a    \/    b    \/    c    \|
                    --                       false : |     a    \/    b    \/    c     |
                    highlight_tab = 'NeoTreeTabInactive',
                    highlight_tab_active = 'NeoTreeTabActive',
                    highlight_background = 'NeoTreeTabInactive',
                    highlight_separator = 'NeoTreeTabSeparatorInactive',
                    highlight_separator_active = 'NeoTreeTabSeparatorActive',
                },
                --
                --event_handlers = {
                --  {
                --    event = "before_render",
                --    handler = function (state)
                --      -- add something to the state that can be used by custom components
                --    end
                --  },
                --  {
                --    event = "file_opened",
                --    handler = function(file_path)
                --      --auto close
                --      require("neo-tree").close_all()
                --    end
                --  },
                --  {
                --    event = "file_opened",
                --    handler = function(file_path)
                --      --clear search after opening a file
                --      require("neo-tree.sources.filesystem").reset_search()
                --    end
                --  },
                --  {
                --    event = "file_renamed",
                --    handler = function(args)
                --      -- fix references to file
                --      print(args.source, " renamed to ", args.destination)
                --    end
                --  },
                --  {
                --    event = "file_moved",
                --    handler = function(args)
                --      -- fix references to file
                --      print(args.source, " moved to ", args.destination)
                --    end
                --  },
                --  {
                --    event = "neo_tree_buffer_enter",
                --    handler = function()
                --      vim.cmd 'highlight! Cursor blend=100'
                --    end
                --  },
                --  {
                --    event = "neo_tree_buffer_leave",
                --    handler = function()
                --      vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
                --    end
                --  },
                -- {
                --   event = "neo_tree_window_before_open",
                --   handler = function(args)
                --     print("neo_tree_window_before_open", vim.inspect(args))
                --   end
                -- },
                -- {
                --   event = "neo_tree_window_after_open",
                --   handler = function(args)
                --     vim.cmd("wincmd =")
                --   end
                -- },
                -- {
                --   event = "neo_tree_window_before_close",
                --   handler = function(args)
                --     print("neo_tree_window_before_close", vim.inspect(args))
                --   end
                -- },
                -- {
                --   event = "neo_tree_window_after_close",
                --   handler = function(args)
                --     vim.cmd("wincmd =")
                --   end
                -- }
                --},
                default_component_configs = {
                    container = {
                        enable_character_fade = true,
                        width = '100%',
                        right_padding = 0,
                    },
                    --diagnostics = {
                    --  symbols = {
                    --    hint = "H",
                    --    info = "I",
                    --    warn = "!",
                    --    error = "X",
                    --  },
                    --  highlights = {
                    --    hint = "DiagnosticSignHint",
                    --    info = "DiagnosticSignInfo",
                    --    warn = "DiagnosticSignWarn",
                    --    error = "DiagnosticSignError",
                    --  },
                    --},
                    indent = {
                        indent_size = 2,
                        padding = 1,
                        -- indent guides
                        with_markers = true,
                        indent_marker = '│',
                        last_indent_marker = '└',
                        highlight = 'NeoTreeIndentMarker',
                        -- expander config, needed for nesting files
                        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = '',
                        expander_expanded = '',
                        expander_highlight = 'NeoTreeExpander',
                    },
                    icon = {
                        folder_closed = '',
                        folder_open = '',
                        folder_empty = '',
                        folder_empty_open = '',
                        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                        -- then these will never be used.
                        default = '*',
                        highlight = 'NeoTreeFileIcon',
                    },
                    modified = {
                        symbol = '[+] ',
                        highlight = 'NeoTreeModified',
                    },
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true,
                        highlight = 'NeoTreeFileName',
                    },
                    git_status = {
                        symbols = {
                            -- Change type
                            added = '✚', -- NOTE: you can set any of these to an empty string to not show them
                            deleted = '✖',
                            modified = '',
                            renamed = '',
                            -- Status type
                            untracked = '',
                            ignored = '',
                            unstaged = '',
                            staged = '',
                            conflict = '',
                        },
                        align = 'right',
                    },
                },
                renderers = {
                    directory = {
                        { 'indent' },
                        { 'icon' },
                        { 'current_filter' },
                        {
                            'container',
                            content = {
                                { 'name',      zindex = 10 },
                                -- {
                                --   "symlink_target",
                                --   zindex = 10,
                                --   highlight = "NeoTreeSymbolicLinkTarget",
                                -- },
                                { 'clipboard', zindex = 10 },
                                {
                                    'diagnostics',
                                    errors_only = true,
                                    zindex = 20,
                                    align = 'right',
                                    hide_when_expanded = true,
                                },
                                { 'git_status', zindex = 20, align = 'right', hide_when_expanded = true },
                            },
                        },
                    },
                    file = {
                        { 'indent' },
                        { 'icon' },
                        {
                            'container',
                            content = {
                                {
                                    'name',
                                    zindex = 10,
                                },
                                -- {
                                --   "symlink_target",
                                --   zindex = 10,
                                --   highlight = "NeoTreeSymbolicLinkTarget",
                                -- },
                                { 'clipboard',   zindex = 10 },
                                { 'bufnr',       zindex = 10 },
                                { 'modified',    zindex = 20, align = 'right' },
                                { 'diagnostics', zindex = 20, align = 'right' },
                                { 'git_status',  zindex = 20, align = 'right' },
                            },
                        },
                    },
                    message = {
                        { 'indent', with_markers = false },
                        { 'name',   highlight = 'NeoTreeMessage' },
                    },
                    terminal = {
                        { 'indent' },
                        { 'icon' },
                        { 'name' },
                        { 'bufnr' },
                    },
                },
                nesting_rules = {},
                window = {                     -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
                    -- possible options. These can also be functions that return these options.
                    position = 'left',         -- left, right, top, bottom, float, current
                    width = 40,                -- applies to left and right positions
                    height = 15,               -- applies to top and bottom positions
                    auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
                    popup = {                  -- settings that apply to float position only
                        size = {
                            height = '80%',
                            width = '50%',
                        },
                        position = '50%', -- 50% means center it
                        -- you can also specify border here, if you want a different setting from
                        -- the global popup_border_style.
                    },
                    same_level = false,  -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
                    insert_as = 'child', -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
                    -- "child":   Insert nodes as children of the directory under cursor.
                    -- "sibling": Insert nodes  as siblings of the directory under cursor.
                    -- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
                    -- You can also create your own commands by providing a function instead of a string.
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ['-'] = {
                            'toggle_node',
                            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
                        },
                        ['<2-LeftMouse>'] = 'open',
                        ['<cr>'] = 'open',
                        ['<esc>'] = 'revert_preview',
                        ['P'] = { 'toggle_preview', config = { use_float = true } },
                        ['l'] = 'focus_preview',
                        ['S'] = 'open_split',
                        -- ["S"] = "split_with_window_picker",
                        ['s'] = 'open_vsplit',
                        -- ["s"] = "vsplit_with_window_picker",
                        ['t'] = 'open_tabnew',
                        -- ["<cr>"] = "open_drop",
                        -- ["t"] = "open_tab_drop",
                        ['w'] = 'open_with_window_picker',
                        ['C'] = 'close_node',
                        ['z'] = 'close_all_nodes',
                        --["Z"] = "expand_all_nodes",
                        ['R'] = 'refresh',
                        ['a'] = {
                            'add',
                            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                            config = {
                                show_path = 'none', -- "none", "relative", "absolute"
                            },
                        },
                        ['A'] = 'add_directory', -- also accepts the config.show_path and config.insert_as options.
                        ['d'] = 'delete',
                        ['r'] = 'rename',
                        ['y'] = 'copy_to_clipboard',
                        ['x'] = 'cut_to_clipboard',
                        ['p'] = 'paste_from_clipboard',
                        ['c'] = 'copy', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
                        ['m'] = 'move', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
                        ['e'] = 'toggle_auto_expand_width',
                        ['q'] = 'close_window',
                        ['?'] = 'show_help',
                        ['<'] = 'prev_source',
                        ['>'] = 'next_source',
                    },
                },
                filesystem = {
                    window = {
                        mappings = {
                            ['H'] = 'toggle_hidden',
                            ['/'] = 'fuzzy_finder',
                            ['D'] = 'fuzzy_finder_directory',
                            --["/"] = "filter_as_you_type", -- this was the default until v1.28
                            ['f'] = 'filter_on_submit',
                            ['<C-x>'] = 'clear_filter',
                            ['<bs>'] = 'navigate_up',
                            ['.'] = 'set_root',
                            ['[{'] = 'prev_git_modified',
                            [']}'] = 'next_git_modified',
                        },
                    },
                    async_directory_scan = 'auto', -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
                    -- "always" means directory scans are always async.
                    -- "never"  means directory scans are never async.
                    scan_mode = 'deep', -- "shallow": Don't scan into directories to detect possible empty directory a priori
                    -- "shallow": Don't scan into directories to detect possible empty directory a priori
                    -- "deep": Scan into directories to detect empty or grouped empty directories a priori.
                    bind_to_cwd = true,     -- true creates a 2-way binding between vim's cwd and neo-tree's root
                    cwd_target = {
                        sidebar = 'tab',    -- sidebar is when position = left or right
                        current = 'window', -- current is when position = current
                    },
                    -- The renderer section provides the renderers that will be used to render the tree.
                    --   The first level is the node type.
                    --   For each node type, you can specify a list of components to render.
                    --       Components are rendered in the order they are specified.
                    --         The first field in each component is the name of the function to call.
                    --         The rest of the fields are passed to the function as the "config" argument.
                    filtered_items = {
                        visible = false,                       -- when true, they will just be displayed differently than normal items
                        force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
                        show_hidden_count = true,              -- when true, the number of hidden items in each folder will be shown as the last entry
                        hide_dotfiles = false,
                        hide_gitignored = true,
                        hide_hidden = false, -- only works on Windows for hidden files/directories
                        hide_by_name = {
                            -- '.DS_Store',
                            -- 'thumbs.db',
                            --"node_modules",
                        },
                        hide_by_pattern = { -- uses glob style patterns
                            --"*.meta",
                            --"*/src/*/tsconfig.json"
                        },
                        always_show = { -- remains visible even if other settings would normally hide it
                            '.gitignored',
                            '*env',
                        },
                        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                            --".DS_Store",
                            --"thumbs.db"
                        },
                        never_show_by_pattern = { -- uses glob style patterns
                            --".null-ls_*",
                        },
                    },
                    find_by_full_path_words = true, -- `false` means it only searches the tail of a path.
                    -- `true` will change the filter into a full path
                    -- search with space as an implicit ".*", so
                    -- `fi init`
                    -- will match: `./sources/filesystem/init.lua
                    --find_command = "fd", -- this is determined automatically, you probably don't need to set it
                    --find_args = {  -- you can specify extra args to pass to the find command.
                    --  fd = {
                    --  "--exclude", ".git",
                    --  "--exclude",  "node_modules"
                    --  }
                    --},
                    ---- or use a function instead of list of strings
                    --find_args = function(cmd, path, search_term, args)
                    --  if cmd ~= "fd" then
                    --    return args
                    --  end
                    --  --maybe you want to force the filter to always include hidden files:
                    --  table.insert(args, "--hidden")
                    --  -- but no one ever wants to see .git files
                    --  table.insert(args, "--exclude")
                    --  table.insert(args, ".git")
                    --  -- or node_modules
                    --  table.insert(args, "--exclude")
                    --  table.insert(args, "node_modules")
                    --  --here is where it pays to use the function, you can exclude more for
                    --  --short search terms, or vary based on the directory
                    --  if string.len(search_term) < 4 and path == "/home/cseickel" then
                    --    table.insert(args, "--exclude")
                    --    table.insert(args, "Library")
                    --  end
                    --  return args
                    --end,
                    group_empty_dirs = false,               -- when true, empty folders will be grouped together
                    search_limit = 50,                      -- max number of search results when using filters
                    follow_current_file = true,             -- This will find and focus the file in the active buffer every time
                    -- the current file is changed while the tree is open.
                    hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
                    -- in whatever position is specified in window.position
                    -- "open_current",-- netrw disabled, opening a directory opens within the
                    -- window like netrw would, regardless of window.position
                    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
                    -- instead of relying on nvim autocmd events.
                },
                buffers = {
                    bind_to_cwd = true,
                    follow_current_file = true, -- This will find and focus the file in the active buffer every time
                    -- the current file is changed while the tree is open.
                    group_empty_dirs = true,    -- when true, empty directories will be grouped together
                    window = {
                        mappings = {
                            ['<bs>'] = 'navigate_up',
                            ['.'] = 'set_root',
                            ['bd'] = 'buffer_delete',
                        },
                    },
                },
                git_status = {
                    window = {
                        mappings = {
                            ['A'] = 'git_add_all',
                            ['gu'] = 'git_unstage_file',
                            ['ga'] = 'git_add_file',
                            ['gr'] = 'git_revert_file',
                            ['gc'] = 'git_commit',
                            ['gp'] = 'git_push',
                            ['gg'] = 'git_commit_and_push',
                        },
                    },
                },
                example = {
                    renderers = {
                        custom = {
                            { 'indent' },
                            { 'icon',  default = 'C' },
                            { 'custom' },
                            { 'name' },
                        },
                    },
                    window = {
                        mappings = {
                            ['<cr>'] = 'toggle_node',
                            ['<C-e>'] = 'example_command',
                            ['d'] = 'show_debug_info',
                        },
                    },
                },
            })
        end,
    },
    {
        'akinsho/bufferline.nvim',
        version = '*',
        config = function()
            local ok_bufferline, bufferline = pcall(require, 'bufferline')
            if not ok_bufferline then
                print('plugins/bufferline.lua: missing requirements')
                return
            end

            bufferline.setup({
                options = {
                    mode = 'buffers', -- set to "tabs" to only show tabpages instead
                    numbers = function(opts)
                        return opts.lower(opts.ordinal)
                    end,                                            -- "both", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
                    close_command = 'Bdelete! %d',                  -- can be a string | function, see "Mouse actions"
                    -- right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                    right_mouse_command = 'vertical sbuffer %d',    -- can be a string | function, see "Mouse actions"
                    middle_mouse_command = 'horizontal sbuffer %d', -- can be a string | function, see "Mouse actions"
                    left_mouse_command = 'buffer %d',               -- can be a string | function, see "Mouse actions"
                    indicator = {
                        icon = '▎',                               -- this should be omitted if indicator style is not 'icon'
                        style = 'icon',                             -- 'icon' | 'underline' | 'none',
                    },
                    buffer_close_icon = '',
                    modified_icon = '●',
                    close_icon = '',
                    left_trunc_marker = '',
                    right_trunc_marker = '',
                    --- name_formatter can be used to change the buffer's label in the bufferline.
                    --- Please note some names can/will break the
                    --- bufferline so use this at your discretion knowing that it has
                    --- some limitations that will *NOT* be fixed.
                    name_formatter = function(_) -- buf contains:
                        -- name                | str        | the basename of the active file
                        -- path                | str        | the full path of the active file
                        -- bufnr (buffer only) | int        | the number of the active buffer
                        -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
                        -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
                    end,
                    max_name_length = 18,
                    max_prefix_length = 15,   -- prefix used when a buffer is de-duplicated
                    truncate_names = true,    -- whether or not tab names should be truncated
                    tab_size = 18,
                    diagnostics = 'nvim_lsp', -- false | "nvim_lsp" | "coc",
                    diagnostics_update_in_insert = true,
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
                    -- custom_filter = function(buf_number, buf_numbers)
                    --     -- filter out filetypes you don't want to see
                    --     if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                    --         return true
                    --     end
                    --     -- filter out by buffer name
                    --     if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                    --         return true
                    --     end
                    --     -- filter out based on arbitrary rules
                    --     -- e.g. filter out vim wiki buffer from tabline in your work repo
                    --     if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "vimwiki" then
                    --         return true
                    --     end
                    --     -- filter out by it's index number in list (don't show first buffer)
                    --     if buf_numbers[1] ~= buf_number then
                    --         return true
                    --     end
                    -- end,
                    offsets = {
                        {
                            filetype = 'NvimTree',
                            -- text = "", -- "text" | function ,
                            text = '┌∩┐(⋟﹏⋞)┌∩┐',
                            -- text = "֍   ֍    ҈ ҈  ҈ ҈  ֎  ֎ ",
                            -- text = "'(◣_◢)'",
                            -- text = "┏(-_-)┛ ┗(-_-)┓ ┗(-_-)┛ ┏(-_-)┓",
                            -- text = "┗(-_-)┛  ┌∩┐(⋟﹏⋞)┌∩┐  ┗(-_-)┛",
                            -- text = "／人 ⌒ ‿‿ ⌒ 人＼",
                            -- text = "Yᵒᵘ Oᶰˡʸ Lᶤᵛᵉ Oᶰᶜᵉ",
                            -- text = "♚ ♛ ♜ ♝ ♞ ♟ ♔ ♕ ♖ ♗ ♘ ♙",
                            -- text = "<-|-'_'-|->",
                            -- text = "..\\ō͡≡o˞̶ ...\\ō͡≡o˞̶   ....\\ō͡≡o˞̶",
                            text_align = 'center', -- "left" -- | "center" | "right"
                            separator = true,
                        },
                    },
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
                    sort_by = 'id', --"insert_after_current" |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b) -- add custom logic
                    --     return buffer_a.modified > buffer_b.modified
                    -- end
                },
            })
        end,
        dependencies = {
            { 'moll/vim-bbye' }, -- :Bdelete and :Bwipeout to preserve window layout
        },
    },
    { import = 'plugins.telescope' },

    -- LSP
    { 'neovim/nvim-lspconfig' },                     -- Collection of configurations for built-in LSP client
    { 'williamboman/mason.nvim' },                   -- LSP servers installer
    { 'williamboman/mason-lspconfig.nvim' },         -- integration with lspconfig
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' }, -- auto install predefined packages
    { 'jose-elias-alvarez/null-ls.nvim' },           -- inject LSP diagnostics, code actions, and more
    { 'davidmh/cspell.nvim' },                       -- null-ls companion plugin for cspell. Built-in version is no longer maintained.
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            local ok_lspsaga, lspsaga = pcall(require, 'lspsaga')
            if not ok_lspsaga then
                print('plugins/lspsaga.lua: missing requirement')
                return
            end

            lspsaga.setup({
                debug = false,
                diagnostic = {
                    show_code_action = false,
                },
                definition = {
                    keys = {
                        edit = '<leader><enter>',
                    },
                },
            })
        end,
    },                                    -- LSP utils with performant UI
    'jose-elias-alvarez/typescript.nvim', -- few extra commands for ts. Uses LSP
    {
        'marilari88/twoslash-queries.nvim',

        config = {
            multi_line = true,        -- to print types in multi line mode
            is_enabled = true,        -- to keep disabled at startup and enable it on request with the EnableTwoslashQueries
            highlight = 'DevIconBat', -- to set up a highlight group for the virtual text
        },

        keys = {
            { '<leader>si', ':TwoslashQueriesInspect<CR>', desc = 'Twoslash Instpect' },
            { '<leader>sr', ':TwoslashQueriesRemove<CR>',  desc = 'Twoslash Remove' },
        },
    }, -- // live type checking with //  ^?

    -- Syntax
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            local ok_ts_configs, ts_configs = pcall(require, 'nvim-treesitter.configs')
            if not ok_ts_configs then
                print('plugins/treesitter.configs.lua: missing requirements')
                return
            end

            -- Treesitter configuration
            -- Parsers must be installed manually via :TSInstall
            ts_configs.setup({
                ensure_installed = {
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
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true, -- false will disable the whole extension
                    use_languagetree = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = 'gnn',
                        node_incremental = 'gnn',
                        scope_incremental = 'gnm',
                        node_decremental = 'gmm',
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
                            [']m'] = '@function.outer',
                            [']]'] = '@class.outer',
                        },
                        goto_next_end = {
                            [']M'] = '@function.outer',
                            [']['] = '@class.outer',
                        },
                        goto_previous_start = {
                            ['[m'] = '@function.outer',
                            ['[['] = '@class.outer',
                        },
                        goto_previous_end = {
                            ['[M'] = '@function.outer',
                            ['[]'] = '@class.outer',
                        },
                    },
                },
                context_commentstring = {
                    enable = true,
                    -- enable_autocmd = false,
                    -- config = { },
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
        end,
    },                                             -- Highlight, edit, and navigate code using a fast incremental parsing library
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional text objects for treesitter
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
    },
    -- Autocompletion
    {
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
                },
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
                    end,
                },
                formatting = {
                    format = lspkind.cmp_format({
                        with_text = true,
                        maxwidth = 50,
                        menu = {
                            nvim_lsp = '',
                            nvim_lua = '',
                            path = '',
                            ultisnips = '',
                            buffer = '',
                            spell = '',
                        },
                    }),
                },
            })
        end,
    },
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    -- snippets are integrated with autocompletion nvim-cmp
    'SirVer/ultisnips',
    'quangnguyen30192/cmp-nvim-ultisnips',

    -- Registers
    { 'simnalamburt/vim-mundo', cmd = { 'MundoShow', 'MundoToggle' } },
    { import = 'plugins.yanky' },

    -- Utils
    {
        'vimwiki/vimwiki',
        config = function()
            vim.g.vimwiki_list = { { path = '~/vimwiki/', syntax = 'markdown', ext = '.md' } }
        end,
    },
    {
        'iamcco/markdown-preview.nvim',
        build = 'cd app && npm install',
        setup = function()
            -- you need yarn or npm already installed in os
            vim.g.mkdp_filetypes = { 'markdown' }
        end,
        ft = { 'markdown' },
    },
    {
        'godlygeek/tabular',
        cmd = { 'Tabularize', 'Tab' },
    },
    { 'blindFS/vim-colorpicker', cmd = 'ColorPicker' },
    { import = 'plugins.vimux' },
    {
        'yssl/QFEnter', -- quickfix window (cw) open in split/tab...
        config = function()
            vim.cmd([[
                augroup myvimrc
                    autocmd!
                    autocmd QuickFixCmdPost [^l]* cwindow
                    autocmd QuickFixCmdPost l*    lwindow
                augroup END
            ]])
        end,
    },
    { import = 'plugins.winresizer' },
    { import = 'plugins.vim-tmux-navigator' },
    { import = 'plugins.which-key' },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local ok_s, s = pcall(require, 'plugins.utils.lualine-sections')

            if not ok_s then
                print('lua/plugins/lualine/sections: fail to load requirments')
                return
            end

            local sections = {
                lualine_a = { s.progress },
                lualine_b = { s.branch, s.fileformat },
                lualine_c = { s.cwd, '' },

                lualine_x = { s.location, s.relative_path, 'diagnostics', 'diff' },
                lualine_y = { s.filetype },
                lualine_z = { 'hostname' },
            }

            require('lualine').setup({
                options = {
                    icons_enabled = true,
                    component_separators = { left = '', right = '' },

                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        -- statusline = { 'alpha' },
                        -- winbar = { 'alpha' },
                    },
                    ignore_focus = {},
                    always_divide_middle = false,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                -- sections = sections,
                inactive_sections = sections,
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = { 'nvim-tree', 'fugitive', 'mundo', 'quickfix' },
            })
        end,
    },
    'stevearc/dressing.nvim',

    -- Look and feel
    {
        'morhetz/gruvbox',
        config = function()
            require('theme')
        end,
    },
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    {
        'blueyed/vim-diminactive',
        config = function()
            vim.g.diminactive_enable_focus = 1
        end,
    },
    {
        'lilydjwg/colorizer',
        config = function()
            vim.g.colorizer_startup = 0
            vim.g.colorizer_maxlines = 1000
        end,
        cmd = { 'ColorHighlight', 'ColorToggle' },
    },
    { import = 'plugins.illuminate' }, -- automatically highlighting other uses of the word under the cursor
}
