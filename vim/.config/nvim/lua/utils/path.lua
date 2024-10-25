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
    local filename = segments[#segments]
    local unique = true

    for _, p in ipairs(paths) do
        if p ~= path and p:match(filename .. '$') then
            unique = false
            break
        end
    end

    if unique then
        return filename
    else
        table.remove(segments) -- Remove filename
        return table.concat(segments, sep) .. sep .. filename
    end
end


M.from_home = function()
    return string.gsub(vim.fn.getcwd(), '/home/%w+/', '~/')
end

return M
