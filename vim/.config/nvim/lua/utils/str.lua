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
---@param suffix string Text to check for occurrence at the end
---@return boolean
function M.ends_with(full_str, suffix)

    return full_str:sub(- #suffix) == suffix
end


---Wrap text with highlight group markers for colored output
---@param text string The text to be colored
---@param hl_group string The highlight group name to apply to the text
---@return string The text wrapped with highlight group markers
function M.color_text(text, hl_group)
    return string.format('%%#%s#%s%%#Normal#', hl_group, text)
end

---Format a number using the provided scripts
---
---@param n integer The number to format
---@param scripts table The table of 10 scripts to use for each digit {1,2,...9,0}
---@return string The formatted string representation of the number
local function formatWithScripts(n, scripts)
  local result = ""
  for i = 1, #tostring(n) do
    local digit = tonumber(string.sub(tostring(n), i, i))
    if digit == 0 then
      digit = 10
    end
    result = result .. scripts[digit]
  end
  return result
end

---Transform digit to subscript
---@param n integer The digit to convert to subscript
---@return string The subscript representation of the digit
function M.subscript(n)
  local subscripts = {"₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉", "₀"}
  return formatWithScripts(n, subscripts)
end

---Transform digit to transcript
---@param n integer The digit to convert to transcript
---@return string The transcript representation of the digit
function M.transcript(n)
  local transcripts = {"¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰"}
  return formatWithScripts(n, transcripts)
end

return M

