return {
    'iamcco/markdown-preview.nvim', -- https://github.com/iamcco/markdown-preview.nvim
    cmd = {
        'MarkdownPreviewToggle',
        'MarkdownPreview',
        'MarkdownPreviewStop',
    },
    ft = { 'markdown' },
    build = function()
        local job = require('plenary.job')
        local install_path = vim.fn.stdpath('data') .. '/lazy/markdown-preview.nvim/app'
        local cmd = 'bash'

        job:new({
            command = cmd,
            args = { '-c', 'npm install && git restore .' },
            cwd = install_path,
            on_exit = function()
                print('Finished installing markdown-preview.nvim')
            end,
            on_stderr = function(_, data)
                print(data)
            end,
        }):start()

        -- Options
        vim.g.mkdp_auto_close = 0
    end,
}
