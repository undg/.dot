return {
  'epwalsh/obsidian.nvim',   -- https://github.com/epwalsh/obsidian.nvim
  version = '*',
  -- lazy = true,
  -- ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
  --   "BufReadPre path/to/my-vault/**.md",
  --   "BufNewFile path/to/my-vault/**.md",
  -- },
  dependencies = {
    'nvim-lua/plenary.nvim',     -- https://github.com/nvim-lua/plenary.nvim
  },
  -- https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#configuration-options
  config = function()
    local ok_obsidian_util, obsidian_util = pcall(require, 'plugins.obsidian-utils')
    local ok_wk, wk = pcall(require, 'which-key')

    if not ok_obsidian_util or not ok_wk then
      print('plugins/obsidian.lua: missing requirements')
      print('obsidian_util: ', ok_obsidian_util)
      print('which-key: ', ok_wk)
      return
    end

    require('obsidian').setup({
      ui = {
        enable = false,
      },
      workspaces = {
        obsidian_util.workspaces.work,
        obsidian_util.workspaces.personal,
        obsidian_util.workspaces.wiki,
      },

      notes_subdir = 'notes',
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = 'notes/daily',
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = '%Y-%m-%d',
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = '%B %-d, %Y',
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
      },
    })

    local keymaps = {
      d = { ':ObsidianToday<cr>', 'Open/Create daily' },
      n = { ':ObsidianNew<cr>', 'Create new note' },
      q = { ':ObsidianQuickSwitch<cr>', 'Quick switch' },
      s = { ':ObsidianSearch<cr>', 'Search' },
    }

    wk.register({
      name = 'Obsidian',

      i = { ':ObsidianPasteImg<cr>', 'Paste image' },
      r = { ':ObsidianRename<cr>', 'Rename note' },

      w = { name = 'Work', keymaps },
      p = { name = 'Personal', keymaps },
      v = { name = 'Wiki', keymaps },
    }, { prefix = '<leader>o', mode = { 'n' }, silent = false })

    wk.register({
      name = 'Obsidian',
      l = { ':ObsidianLinkNew', 'Create new link' },
    }, { prefix = '<leader>o', mode = { 'v' }, silent = false })
  end,
}
