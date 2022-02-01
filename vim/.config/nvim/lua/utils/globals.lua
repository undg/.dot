R = function (package)
    require'package'.loaded = nil
   return require(package)
end

P = function (any)
    print(vim.inspect(any))
    return any
end

