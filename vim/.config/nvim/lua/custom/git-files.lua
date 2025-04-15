-- Git Branch Diff Commands
-- Shows modified files between current HEAD and specified branch in quickfix
-- Usage:
--   :GFmain   - compare with main branch
--   :GFdev    - compare with dev branch
--   :GFmaster - compare with master branch
-- Each file appears in quickfix with ":1:1: modified" suffix

vim.api.nvim_create_user_command('GFmain',
	[[cexpr system('git diff --name-only $(git merge-base HEAD main) | sed "s/$/:1:1: modified/"')]],
	{ desc = "add qfix git diff main files" })

vim.api.nvim_create_user_command('GFdev',
	[[cexpr system('git diff --name-only $(git merge-base HEAD dev) | sed "s/$/:1:1: modified/"')]],
	{ desc = "add qfix git diff dev files" })

vim.api.nvim_create_user_command('GFmaster',
	[[cexpr system('git diff --name-only $(git merge-base HEAD master) | sed "s/$/:1:1: modified/"')]],
	{ desc = "add qfix git diff master files" })
