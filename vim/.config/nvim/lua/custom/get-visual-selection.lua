-- Return text selected in visual mode.
-- @example
--     local tb = require("telescope/builtin")
--     tb.live_grep({ default_text = getVisualSelectionFn() })

local function getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ""
    end
end

return getVisualSelection

