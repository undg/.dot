return {
    'yetone/avante.nvim', -- https://github.com/yetone/avante.nvim
    event = 'VeryLazy',
    build = 'make',       -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
    opts = {
        ---@alias Provider "openai" | "claude" | "azure"  | "copilot" | "cohere" | [string]
        provider = 'claude',
        claude = {
            endpoint = 'https://api.anthropic.com',
            model = 'claude-3-5-sonnet-20240620',
            temperature = 0,
            max_tokens = 4096,
        },
        windows = {
            wrap = true,          -- similar to vim.o.wrap
            width = 50,           -- default % based on available width
            sidebar_header = {
                align = 'center', -- left, center, right for title
                rounded = true,
            },
        },
    },
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
        'stevearc/dressing.nvim',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        --- The below is optional, make sure to setup it properly if you have lazy=true
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { 'markdown', 'Avante' },
            },
            ft = { 'markdown', 'Avante' },
        },
    },
}
