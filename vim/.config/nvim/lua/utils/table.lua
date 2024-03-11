local M = {}

---Appends a table t2 to the end of a table t1
---
---@param t1 table first table
---@param t2 table second table to append
---@return table A new table with the mapped values
function M.concat(t1, t2)
    local tOut = {}

    for i = 1, #t1 do
        tOut[i] = t1[i]
    end

    for i = #t1, #t1 + #t2 do
        tOut[i] = t2[i]
    end

    return tOut
end

---Maps a function fn over the values of a table, returning a new table
---with the results.
---
---@generic T: table, K, V
---@param input_table T The input table
---@param mapper fun(value: V, key?: K): T The function to map over the values
---@return T A new table with the mapped values
function M.map(input_table, mapper)
    local new_table = {}

    if type(input_table) ~= 'table' then
        vim.notify('Error: input_table must be a table', vim.log.levels.ERROR)
        P(input_table)
        return new_table
    end

    for key, value in pairs(input_table) do
        new_table[key] = mapper(value, key)
    end
    return new_table
end

---serialize first level of table.
---
---@param input_table table The input table
function M.serialize(input_table)
    for i, v in ipairs(input_table) do
        print(i, ':', v)
    end
end

return M
