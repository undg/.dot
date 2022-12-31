local M = {}

---Check if string is starts with another string
---@param full_str string Text to test
---@param starts_with string Text to check for occurrence
---@return boolean
function M.starts_with(full_str, starts_with)
    return string.sub(full_str, 1, string.len(starts_with)) == starts_with
end

return M
