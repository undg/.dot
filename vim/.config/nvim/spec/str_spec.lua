local str = require('utils.str')

describe('String Utilities', function()
	it('str.starts_with()', function()
		assert.is_true(str.starts_with('hello world', 'hello'))
		assert.is_false(str.starts_with('hello world', 'world'))
	end)

	it('str.ends_with()', function()
		assert.is_true(str.ends_with('hello world', 'world'))
		assert.is_false(str.ends_with('hello world', 'hello'))
	end)

	it('str.color_text()', function()
		assert.are.equal('%#MyHighlight#test%#Normal#', str.color_text('test', 'MyHighlight'))
	end)

	it('utils.str.subscript()', function()
		assert.are.equal('₀', str.subscript(0))
		assert.are.equal('₁', str.subscript(1))
		assert.are.equal('₁₂₃', str.subscript(123))
	end)

	it('str.transcript()', function()
		assert.are.equal('⁰', str.transcript(0))
		assert.are.equal('¹', str.transcript(1))
		assert.are.equal('¹²³', str.transcript(123))
	end)
end)
