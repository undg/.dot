local M = {}

function M.toogle_IlluminateWordRead(current_value)
    -- @TODO (undg) 2023-10-16: get that from hl and store on the side, it's default only for gruvbox, or this plugin in dark mode
    local normal_hex = '191919'
    -- @TODO (undg) 2023-10-16: find nice color for flashlighting
    local bold_hex = 'ffffff'

    local bold_dec = tonumber(bold_hex, 16)
    -- local bold_dec = 16777215 -- ffffff

    local normal_color = '#' .. normal_hex
    local bold_color = '#' .. bold_hex

    if current_value == bold_dec then
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = normal_color })
        print(
            'hl toogle_IlluminateWordRead(bold) |',
            'hex: #' .. string.format('%06x', current_value),
            '| dec:',
            current_value
        )
    else
        vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = bold_color })
        print(
            'hl toogle_IlluminateWordRead(norm) |',
            'hex: #' .. string.format('%06x', current_value),
            '| dec:',
            current_value
        )
    end
end

return M
