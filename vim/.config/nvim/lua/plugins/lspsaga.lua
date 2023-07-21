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
