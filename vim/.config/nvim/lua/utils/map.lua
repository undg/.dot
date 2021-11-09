local M = {}
---@param mode string
---@param keybind string
---@param cmd string
---@param opt? {}
local function keymap(mode, keybind, cmd, opt)
    -- assert(type(mode) == 'string', 'mode is not a string: ' + mode)
    if cmd then
        assert(type(keybind) == 'string', 'keybind is not a string: \n' .. cmd)
    end
    if keybind then
        assert(type(cmd) == 'string', 'cmd is not a string: \n' .. keybind)
    end

    opt = opt or {}
    opt.noremap = opt.noremap or true
    opt.silent = opt.silent or true

    vim.api.nvim_set_keymap(mode, keybind, cmd, opt)
end

---@param keybind string
---@param cmd string
---@param opt? {}
function M.normal(keybind, cmd, opt)
    keymap('n', keybind, cmd, opt)
end

---@param keybind string
---@param cmd string
---@param opt? {}
function M.insert(keybind, cmd, opt)
    keymap('i', keybind, cmd, opt)
end

---@param keybind string
---@param cmd string
---@param opt? {}
function M.visual(keybind, cmd, opt)
    keymap('v', keybind, cmd, opt)
end

---@param keybind string
---@param cmd string
---@param opt? {}
function M.xisual(keybind, cmd, opt)
    keymap('x', keybind, cmd, opt)
end

return M
