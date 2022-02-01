_G = {}

R = function (package)
    require'package'.loaded = nil
   return require(package)
end

P = function (v)
    print(vim.inspect(v))
    return v
end

_G.print = P
_G.reload = R

