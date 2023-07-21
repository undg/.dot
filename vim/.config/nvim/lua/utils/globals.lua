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

