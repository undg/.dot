local keymap = require('utils.keymap')

local getVisualSelectionFn_ok, getVisualSelectionFn = pcall(require, 'custom.get-visual-selection')

local not_ok = not getVisualSelectionFn_ok and 'custom.get-visual-selection' --
    or false

if not_ok then
    vim.notify('custom/css2tw: failed to load custom.get-visual-selection', vim.log.levels.ERROR)
    return
end

local function css2tw(cssStyles)
    if not string.match(vim.fn.getcwd(), '/Arahi/') then
        return
    end

    local script = 'pnpm tsx scripts/convert-styles-to-tailwindcss-class-names.script.ts'

    local handler = io.popen(script .. ' "' .. cssStyles .. '"')

    if handler == nil then
        vim.notify('Something fucked up. Handler not established, quit.', vim.log.levels.ERROR)
        return
    end

    local read = handler:read('*a')
    local formated = read:gsub('[\n\r]', ' ')

    handler:close()

    return formated
end

local function copyToRegister()
    local lines = css2tw(getVisualSelectionFn())

    vim.fn.setreg('"', lines)
end

local function pasteFromRegister()
    local regiser = vim.fn.getreg('"')

    local lines = css2tw(regiser)

    vim.api.nvim_put({ lines }, 'c', true, false)
end

keymap.visual('<leader>tw', copyToRegister, { desc = 'Conver CSS to Arahi TW classes' })
keymap.normal('<leader>tw', pasteFromRegister, { desc = 'Conver CSS to Arahi TW classes' })

vim.api.nvim_create_user_command('ArahiToolsCss2tw', pasteFromRegister, {})
