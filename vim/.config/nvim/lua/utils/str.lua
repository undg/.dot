local M = {}

---Check if string starts with another string
---@param full_str string Text to test
---@param starts_with string Text to check for occurrence
---@return boolean
function M.starts_with(full_str, starts_with)
    return string.sub(full_str, 1, string.len(starts_with)) == starts_with
end

---Check if string ends with another string
---@param full_str string Text to test
---@param ends_with string Text to check for occurrence at the end
---@return boolean
function M.ends_with(full_str, ends_with)
    return string.sub(full_str, -#ends_with, string.len(ends_with)) == ends_with
end


---Wrap text with highlight group markers for colored output
---@param text string The text to be colored
---@param hl_group string The highlight group name to apply to the text
---@return string The text wrapped with highlight group markers
function M.color_text(text, hl_group)
    return string.format('%%#%s#%s%%#Normal#', hl_group, text)
end

return M

