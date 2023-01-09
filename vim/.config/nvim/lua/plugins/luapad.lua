local  ok_luapad, luapad = pcall(require, 'luapad')
if not ok_luapad then
print('plugins/luapad.lua: missing requirements')
    return
end


luapad.setup{
  count_limit = 150000,
  error_indicator = false,
  eval_on_move = true,
  error_highlight = 'WarningMsg',
  on_init = function()
    print 'Hello from Luapad!'
  end,
  context = {
    the_answer = 42,
    shout = function(str) return(string.upper(str) .. '!') end
  }
}
