return {
    {
        'huynle/ogpt.nvim', -- https://github.com/huynle/ogpt.nvim/blob/main/lua/ogpt/config.lua
        event = 'VeryLazy',
        opts = {
            default_provider = 'ollama',
            edgy = true,           -- enable this!
            single_window = false, -- set this to true if you want only one OGPT window to appear at a time
            providers = {
                ollama = {
                    api_host = os.getenv('OLLAMA_API_HOST') or 'http://localhost:11434',
                    api_key = os.getenv('OLLAMA_API_KEY') or '',
                    model = 'wizard-vicuna-uncensored:latest',
                    models = {
                        coder = 'deepseek-coder:6.7b',
                        uncensored = 'wizard-vicuna-uncensored:latest',
                        coodelama = 'codellama:7b-instruct',
                        codetypescript = 'codegpt/deepseek-coder-1.3b-typescript:latest',
                    },
                },
            },
        },
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
    },
    {
        'folke/edgy.nvim',
        event = 'VeryLazy',
        init = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = 'screen' -- or "topline" or "screen"
        end,
        opts = {
            exit_when_last = false,
            animate = {
                enabled = false,
            },
            wo = {
                winbar = true,
                winfixwidth = true,
                winfixheight = false,
                winhighlight = 'WinBar:EdgyWinBar,Normal:EdgyNormal',
                spell = false,
                signcolumn = 'no',
            },
            keys = {
                -- -- close window
                ['q'] = function(win)
                    win:close()
                end,
                -- close sidebar
                ['Q'] = function(win)
                    win.view.edgebar:close()
                end,
                -- increase width
                ['<S-Right>'] = function(win)
                    win:resize('width', 3)
                end,
                -- decrease width
                ['<S-Left>'] = function(win)
                    win:resize('width', -3)
                end,
                -- increase height
                ['<S-Up>'] = function(win)
                    win:resize('height', 3)
                end,
                -- decrease height
                ['<S-Down>'] = function(win)
                    win:resize('height', -3)
                end,
            },
            right = {
                {
                    title = 'OGPT Popup',
                    ft = 'ogpt-popup',
                    size = { width = 0.2 },
                    wo = {
                        wrap = true,
                    },
                },
                {
                    title = 'OGPT Parameters',
                    ft = 'ogpt-parameters-window',
                    size = { height = 6 },
                    wo = {
                        wrap = true,
                    },
                },
                {
                    title = 'OGPT Template',
                    ft = 'ogpt-template',
                    size = { height = 6 },
                },
                {
                    title = 'OGPT Sesssions',
                    ft = 'ogpt-sessions',
                    size = { height = 6 },
                    wo = {
                        wrap = true,
                    },
                },
                {
                    title = 'OGPT System Input',
                    ft = 'ogpt-system-window',
                    size = { height = 6 },
                },
                {
                    title = 'OGPT',
                    ft = 'ogpt-window',
                    size = { height = 0.5 },
                    wo = {
                        wrap = true,
                    },
                },
                {
                    title = 'OGPT {{{selection}}}',
                    ft = 'ogpt-selection',
                    size = { width = 80, height = 4 },
                    wo = {
                        wrap = true,
                    },
                },
                {
                    title = 'OGPt {{{instruction}}}',
                    ft = 'ogpt-instruction',
                    size = { width = 80, height = 4 },
                    wo = {
                        wrap = true,
                    },
                },
                {
                    title = 'OGPT Chat',
                    ft = 'ogpt-input',
                    size = { width = 80, height = 4 },
                    wo = {
                        wrap = true,
                    },
                },
            },
        },
    },
}
