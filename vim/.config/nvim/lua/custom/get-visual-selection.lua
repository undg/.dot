-- Return text selected in visual mode.
-- @example
--     require("telescope.builtin").live_grep({ default_text = get_visual_selection() })
local function get_visual_selection()
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

return get_visual_selection
