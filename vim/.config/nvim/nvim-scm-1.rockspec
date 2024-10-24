rockspec_format = '3.0'
package = 'nvim'
version = 'scm-1'

test_dependencies = {
  'lua >= 5.1',
  'nlua',
  'nui.nvim',
}

source = {
  url = 'git://github.com/undg/' .. package,
}

build = {
  type = 'builtin',
}
