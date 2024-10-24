local str = require('utils.str')

describe('String Utilities', function()
    it('checks if string starts with another string', function()
        assert.is_true(str.starts_with('hello world', 'hello'))
        assert.is_false(str.starts_with('hello world', 'world'))
    end)

    it('checks if string ends with another string', function()
        assert.is_true(str.ends_with('hello world', 'world'))
        assert.is_false(str.ends_with('hello world', 'hello'))
    end)

    it('wraps text with highlight group markers', function()
        assert.are.equal('%#MyHighlight#test%#Normal#', str.color_text('test', 'MyHighlight'))
    end)

    it('transforms digit to subscript', function()
        assert.are.equal('₀', str.subscript(0))
        assert.are.equal('₁', str.subscript(1))
        assert.are.equal('₁₂₃', str.subscript(123))
    end)

    it('transforms digit to transcript', function()
        assert.are.equal('⁰', str.transcript(0))
        assert.are.equal('¹', str.transcript(1))
        assert.are.equal('¹²³', str.transcript(123))
    end)
end)
