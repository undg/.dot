return {
	'akinsho/git-conflict.nvim', -- https://github.com/akinsho/git-conflict.nvim
	version = '*',
	config = function()
		require('git-conflict').setup({
			default_mappings = false,  -- disable buffer local mapping created by this plugin
			default_commands = true,   -- disable commands created by this plugin
			disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
			-- list_opener = 'copen', -- command or function to open the conflicts list
			list_opener = 'Telescope quickfix', -- command or function to open the conflicts list
			highlights = {             -- They must have background color, otherwise the default color will be used
				current = 'DiffChange',
				incoming = 'DiffChange',
			},
		})

		local wkey_ok, wk = pcall(require, "which-key")
		if not wkey_ok then
			vim.notify("plugins/git-conflict.lua: missing requirements - whick-key", vim.log.levels.ERROR)
			return
		end

		wk.add({
			{ "<leader>c",  gruop = 'git-conflict',         silent = true },
			{ "<leader>co", ":GitConflictChooseOurs<cr>",   desc = "(git-conflict) choose ours" },
			{ "<leader>ct", ":GitConflictChooseTheirs<cr>", desc = "(git-conflict) choose theirs" },
			{ "<leader>cb", ":GitConflictChooseBoth<cr>",   desc = "(git-conflict) choose both" },
			{ "<leader>cx", ":GitConflictChooseNone<cr>",   desc = "(git-conflict) choose none" },
			{ "<leader>cn", ":GitConflictNextConflict<cr>", desc = "(git-conflict) goto next" },
			{ "<leader>cp", ":GitConflictPrevConflict<cr>", desc = "(git-conflict) goto prev" },
			{ "<leader>cq", ":GitConflictListQf<cr>",       desc = "(git-conflict) add to quick fix list" },
		})
	end,
}

-- {
--   default_mappings = true, -- disable buffer local mapping created by this plugin
--   default_commands = true, -- disable commands created by this plugin
--   disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
--   list_opener = 'copen', -- command or function to open the conflicts list
--   highlights = { -- They must have background color, otherwise the default color will be used
--     incoming = 'DiffAdd',
--     current = 'DiffText',
--   }
-- }

-- GitConflictChooseOurs — Select the current changes.
-- GitConflictChooseTheirs — Select the incoming changes.
-- GitConflictChooseBoth — Select both changes.
-- GitConflictChooseNone — Select none of the changes.
-- GitConflictNextConflict — Move to the next conflict.
-- GitConflictPrevConflict — Move to the previous conflict.
-- GitConflictListQf — Get all conflict to quickfix
