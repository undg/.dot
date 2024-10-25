local path = require('utils.path')

describe('Path Utilities', function()
    describe('utils.path.shorten()', function()
        it('should NOT shorten paths', function()
            assert.are.equal('', path.shorten(''))
            assert.are.equal('file.lua', path.shorten('file.lua'))
            assert.are.equal('c/file.lua', path.shorten('c/file.lua'))
            assert.are.equal('n/l/file.lua', path.shorten('nested/longparrent/file.lua'))
            assert.are.equal('not/long/file.lua', path.shorten('not/long/file.lua', 100))
        end)
        it('should shorten paths correctly', function()
            assert.are.equal('n/l/file.lua', path.shorten('nested/longparrent/file.lua'))
            assert.are.equal('l/file.lua', path.shorten('long/file.lua', 10))
        end)
    end)
    describe('utils.path.shortenUnique()', function()
        it('should return only file name', function()
            local files = {
                'nested/parrent/file.lua',
                'different/parrent/different-fle.lua',
            }
            assert.are.equal('file.lua', path.shortenUnique(files[1], files))
        end)

        it('should add parrent', function()
            local files = {
                'nested/parrent/file.lua',
                'different-parrent/file.lua',
                'different/parrent/different-file.lua',
            }
            assert.are.equal('parrent/file.lua', path.shortenUnique(files[1], files))
        end)
    end)
end)
