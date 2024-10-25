local M = {}

---shortens path by turning apple/orange -> a/orange
---@param path string
---@param max_len? integer maximum length of the full filename string
---@param sep? string path separator
---@return string
function M.shorten(path, max_len, sep)
    sep = sep or '/'
    max_len = max_len or 20

    local len = #path
    if len <= max_len then
        return path
    end

    local segments = vim.fn.split(path, sep)
    for idx = 1, #segments - 1 do
        if len <= max_len then
            break
        end

        local segment = segments[idx]
        local shortened = segment:sub(1, vim.startswith(segment, '.') and 2 or 1)
        segments[idx] = shortened
        len = len - (#segment - #shortened)
    end

    return table.concat(segments, sep)
end

function M.shortenUnique(path, paths)
    local sep = '/'
    local segments = vim.split(path, sep)
    local fname = segments[#segments]
    local parrent = segments[#segments - 1]
    local unique = true

    for _, t in ipairs(paths) do
        if t ~= path then -- Skip the current path
            local t_segments = vim.split(t, sep)
            local t_fname = t_segments[#t_segments]

            if t_fname == fname then
                unique = false
                break
            end
        end
    end

    return unique and fname or parrent .. sep .. fname
end

M.from_home = function()
    return string.gsub(vim.fn.getcwd(), '/home/%w+/', '~/')
end

return M
