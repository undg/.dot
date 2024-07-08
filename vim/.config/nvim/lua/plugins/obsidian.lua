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
    local obsidian_util_ok, obsidian_util = pcall(require, 'plugins.obsidian-utils')
    local wk_ok, wk = pcall(require, 'which-key')

    local not_ok = not wk_ok and 'which-key'     --
        or not obsidian_util_ok and 'plugins.obsidian-utils'
        or false

    if not_ok then
      vim.notify('plugins/obsidian.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
      return
    end

    require('obsidian').setup({
      ui = {
        enable = true,
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          -- [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          -- ['x'] = { char = '', hl_group = 'ObsidianDone' },
          -- ['>'] = { char = '', hl_group = 'ObsidianTodo' },
          -- ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
          ['!'] = { char = '', hl_group = 'ObsidianImportant' },
          -- Replace the above with this if you don't have a patched font:
          [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          ["x"] = { char = "✔", hl_group = "ObsidianDone" },

          -- You can also add more custom ones...
        },
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = '•', hl_group = 'ObsidianBullet' },
      },
      workspaces = {
        obsidian_util.workspaces.work,
        obsidian_util.workspaces.personal,
        obsidian_util.workspaces.wiki,
      },
      follow_url_func = function(url)
        vim.fn.jobstart({ 'xdg-open', url })         -- Linux <3

        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({ 'open', url })    -- Mac OS 💩
      end,

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
