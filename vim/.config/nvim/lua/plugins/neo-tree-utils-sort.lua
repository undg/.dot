local priorities = {
    ['index.js'] = 6,
    ['index.jsx'] = 6,
    ['index.ts'] = 6,
    ['index.tsx'] = 6,
    ['init.lua'] = 6,
    ['mod.ts'] = 6,
    ['main.go'] = 6,
    ['__init__.py'] = 6,
}

local function remove_extension(a)
    if a.type == 'file' then
        local ext = a.ext or ''
        local ext_pattern = '%.' .. ext .. '$'
        return a.path:gsub(ext_pattern, '')
    else
        return a.path
    end
end

return function(a, b)
    -- sort by priority if it possible
    if priorities[a.name] and priorities[b.name] then
        return priorities[a.name] > priorities[b.name]
    end
    -- if the priority is set for only one, then the
    -- one who has it set will be the first
    if priorities[a.name] or priorities[b.name] then
        return priorities[a.name] ~= nil
    end

    if not a then
        return false
    end
    if not a.name then
        return false
    end
    if not a.path then
        return false
    end
    if not a.type then
        return false
    end

    if not b then
        return true
    end
    if not b.name then
        return true
    end
    if not b.path then
        return true
    end
    if not b.type then
        return true
    end

    -- put directory after file under same basename
    if remove_extension(a) == remove_extension(b) then
        if b.type == 'directory' then
            return true
        else
            return false
        end
    end

    -- default path sort
    return a.path < b.path
end
