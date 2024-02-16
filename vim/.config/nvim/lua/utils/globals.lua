--- R reloads the given Lua package
---
--- @param package string: The name of the package to reload
--- @return unknown|nil The reloaded package
---
--- @usage
--- local utils = R('utils')
R = function(package)
    require('package').loaded = nil
    return require(package)
end

--- P prints the given value and returns it
---
--- @param any unknown: The value to print and return
--- @return unknown: The input value
---
--- @usage
--- local x = P({a=1, b=2})
---
--- @usage
--- P({a=1, b=2})
P = function(any)
    print(vim.inspect(any))
    return any
end

LAZY_PLUGIN_SPEC = {}

---Load plugin spec from file
---@param path string @path to spec file
function Spec(path)
    table.insert(LAZY_PLUGIN_SPEC, { import = path })
end

---@param url string Plugin github url
function Git(url)
    local item = url:gsub('https://github.com/', '')
    table.insert(LAZY_PLUGIN_SPEC, item)
end
