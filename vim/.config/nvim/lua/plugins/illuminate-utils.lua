--- @class IlluminateUtils
local M = {}

--- Buffer number for highlight operations
--- @type number
M.buf_nr = 0

--- Toggle background color of IlluminatedWordRead highlight group
--- @param current_value number Current decimal value of background color
--- @return nil
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
		vim.api.nvim_set_hl(M.buf_nr, 'IlluminatedWordRead', { bg = normal_color })
		vim.notify(
			'BOLD\t' .. '\thex: #' .. string.format('%06x', current_value) .. '\tdec:' .. current_value,
			vim.log.levels.INFO,
			{ title = 'IlluminateWordRead' }
		)
	else
		vim.api.nvim_set_hl(M.buf_nr, 'IlluminatedWordRead', { bg = bold_color })
		vim.notify(
			'NORMAL' .. '\thex: #' .. string.format('%06x', current_value) .. '\tdec:' .. current_value,
			vim.log.levels.INFO,
			{ title = 'IlluminateWordRead' }
		)
	end
end

return M
