local twoslash_ok, twoslash = pcall(require, 'twoslash-queries')
if not twoslash_ok then
    print('plugins/twoslash-queries.lua: missing requirements')
    return
end

twoslash.setup({
    multi_line = true, -- to print types in multi line mode
    is_enabled = true, -- to keep disabled at startup and enable it on request with the EnableTwoslashQueries
    highlight = 'DevIconBat', -- to set up a highlight group for the virtual text
})
