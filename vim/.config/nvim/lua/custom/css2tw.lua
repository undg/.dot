local map = require('utils.map')

local ok_getVisualSelectionFn, getVisualSelectionFn = pcall(require, 'custom.get-visual-selection')
if not ok_getVisualSelectionFn then
    print('custom/css2tw: failed to load custom.get-visual-selection')
    return
end

local function css2tw()
    if not string.match(vim.fn.getcwd(), '/Arahi/') then
        return
    end

    local script = 'pnpm tsx scripts/convert-styles-to-tailwindcss-class-names.script.ts'

    local handler = io.popen(script .. ' "' .. getVisualSelectionFn() .. '"')

    if handler == nil then
        print('Something fucked up. Handler not established, quit.')
        return
    end

    local read = handler:read('*a')
    local formated = read:gsub('[\n\r]', ' ')

    handler:close()

    vim.fn.setreg('"', formated)
end

map.visual('<leader>tw', css2tw, { desc = 'Conver CSS to Arahi TW classes' })
-- vim.api.nvim_create_user_command('ArahiToolsCss2tw', css2tw, {})
