R = function(package)
    require("package").loaded = nil
    return require(package)
end

P = function(any)
    print(vim.inspect(any))
    return any
end

---@param t1 {}
---@param t2 {}
function TableConcat(t1, t2)
    local tOut = {}

    for i = 1, #t1 do
        tOut[i] = t1[i]
    end

    for i = #t1, #t1 + #t2 do
        tOut[i] = t2[i]
    end

    return tOut
end

local bootstrap_ok, ensure_packer = pcall(require, 'bootstrap')
if not bootstrap_ok then
    print('lua/utils/global.lua: bootstrap fail')
    return
end

PACKER_BOOTSTRAP = ensure_packer()
