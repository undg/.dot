return {
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    config = function()
        local ok_devicons, devicons = pcall(require, 'nvim-web-devicons')
        if not ok_devicons then
            print('plugins/nvim-web-devicons.lua: missing requirements')
            return
        end

        devicons.setup({
            -- your personnal icons can go here (to override)
            -- DevIcon will be appended to `name`
            override = {
                zsh = {
                    icon = '',
                    color = '#428850',
                    name = 'Zsh',
                },
            },
            -- globally enable default icons (default to false)
            -- will get overriden by `get_icons` option
            default = true,
        })
    end,
} -- icons for telescope and Neotree and all sorts of plugins
