local M = {}
---@param mode string
---@param keybind string
---@param cmd string | function
---@param opt? {}
local function keymap(mode, keybind, cmd, opt)
	-- assert(type(keybind) == "string", "keybind is not a string: \n" .. cmd)
	assert(type(cmd) == 'string' or type(cmd) == 'function', 'cmd is not a string nor function: \n' .. keybind)

	opt = opt or {}
	-- Anything that not `false` (empty nil, string, true...) should be `true`
	-- It's twisted... I know... This way I'm sure to not override false value from `opt`.
	-- default to true
	if opt.noremap ~= false then
		opt.noremap = true
	end

	vim.keymap.set(mode, keybind, cmd, opt)
end

---@param keybind string
---@param cmd string | function
---@param opt? {}
function M.normal(keybind, cmd, opt)
	keymap('n', keybind, cmd, opt)
end

---@param keybind string
---@param cmd string | function
---@param opt? {}
function M.insert(keybind, cmd, opt)
	keymap('i', keybind, cmd, opt)
end

---@param keybind string
---@param cmd string | function
---@param opt? {}
function M.visual(keybind, cmd, opt)
	keymap('v', keybind, cmd, opt)
end

---@param keybind string
---@param cmd string | function
---@param opt? {}
function M.xisual(keybind, cmd, opt)
	keymap('x', keybind, cmd, opt)
end

return M
