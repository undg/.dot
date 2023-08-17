local map = require('utils.map')

local ok_getVisualSelectionFn, getVisualSelectionFn = pcall(require, 'custom.get-visual-selection')
if not ok_getVisualSelectionFn then
    print('custom/css2tw: failed to load custom.get-visual-selection')
    return
end

local function css2tw(cssStyles)
    if not string.match(vim.fn.getcwd(), '/Arahi/') then
        return
    end

    local script = 'pnpm tsx scripts/convert-styles-to-tailwindcss-class-names.script.ts'

    local handler = io.popen(script .. ' "' .. cssStyles .. '"')

    if handler == nil then
        print('Something fucked up. Handler not established, quit.')
        return
    end

    local read = handler:read('*a')
    local formated = read:gsub('[\n\r]', ' ')

    handler:close()

    return formated
end

local function copyToRegister()
    local tw = css2tw(getVisualSelectionFn())

    vim.fn.setreg('"', tw)
end

local function pasteFromRegister()
    local regiser = vim.fn.getreg('"')

    local tw = css2tw(regiser)

    vim.api.nvim_set_current_line(tw)
end

map.visual('<leader>tw', copyToRegister, { desc = 'Conver CSS to Arahi TW classes' })
map.normal('<leader>tw', pasteFromRegister, { desc = 'Conver CSS to Arahi TW classes' })

vim.api.nvim_create_user_command('ArahiToolsCss2tw', pasteFromRegister, {})
