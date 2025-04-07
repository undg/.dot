return {
	'akinsho/git-conflict.nvim', -- https://github.com/akinsho/git-conflict.nvim
	version = '*',
	config = {
		default_mappings = true, -- disable buffer local mapping created by this plugin
		default_commands = true, -- disable commands created by this plugin
		disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
		list_opener = 'copen', -- command or function to open the conflicts list
		highlights = {         -- They must have background color, otherwise the default color will be used
			current = 'DiffChange',
			incoming = 'DiffChange',
		},
	}
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
