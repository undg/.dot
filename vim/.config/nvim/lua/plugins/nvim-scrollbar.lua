local  ok_scrollbar_handlers_search, scrollbar_handlers_search = pcall(require, 'scrollbar.handlers.search')
if not ok_scrollbar_handlers_search then
print('plugins/nvim-scrollbar.lua: missing scrollbar.handlers.search')
    return
end

local  ok_scrollbar, scrollbar = pcall(require, 'scrollbar')
if not ok_scrollbar then
print('plugins/nvim-scrollbar.lua: missing scrollbar')
    return
end

-- doc: https://github.com/petertriho/nvim-scrollbar
scrollbar.setup({})
scrollbar_handlers_search.setup()
