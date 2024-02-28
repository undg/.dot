return {
  'princejoogie/dir-telescope.nvim',     -- https://github.com/princejoogie/dir-telescope.nvim
  dependencies = {
    'nvim-telescope/telescope.nvim',     -- https://github.com/nvim-telescope/telescope.nvim
  },
  config = function()
    require('dir-telescope').setup({
      -- these are the default options set
      hidden = true,
      no_ignore = false,
      show_preview = true,
    })
  end,
}
