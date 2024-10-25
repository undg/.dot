local tbl = require "utils.tbl"

describe('slice tests', function()
    it('slices table correctly', function()
        local t = {1, 2, 3, 4, 5}
        local result = tbl.slice(t, 2, 4)
        assert.are.same(result, {2, 3, 4})
    end)

    it('handles out of bounds', function()
        local t = {1, 2, 3}
        local result = tbl.slice(t, 1, 5)
        assert.are.same(result, {1, 2, 3})
    end)

    it('returns empty table for invalid range', function()
        local t = {1, 2, 3}
        local result = tbl.slice(t, 4, 5)
        assert.are.same(result, {})
    end)
end)
