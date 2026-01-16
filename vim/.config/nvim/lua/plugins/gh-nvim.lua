return {
	"ldelossa/gh.nvim",
	dependencies = {
		{
			"ldelossa/litee.nvim",
			config = function()
				require("litee.lib").setup()
			end,
		},
	},
	config = function()
		require("litee.gh").setup({
			icon_set = "codicons", -- Use codicons instead of default Unicode symbols
		})


		local wk_ok, wk = pcall(require, "which-key")

		local not_ok = not wk_ok and "which-key" --
			or false

		if not_ok then
			vim.notify("plugins/gh-nvim.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
			return
		end

		wk.add {
			{ '<leader>g',    group = 'Git' },
			{ '<leader>gh',   group = 'Github' },
			{ '<leader>ghc',  group = 'Commits' },
			{ '<leader>ghcc', ':GHCloseCommit<cr>',    desc = '(gh.nvim) Close' },
			{ '<leader>ghce', ':GHExpandCommit<cr>',   desc = '(gh.nvim) Expand' },
			{ '<leader>ghco', ':GHOpenToCommit<cr>',   desc = '(gh.nvim) Open To' },
			{ '<leader>ghcp', ':GHPopOutCommit<cr>',   desc = '(gh.nvim) Pop Out' },
			{ '<leader>ghcz', ':GHCollapseCommit<cr>', desc = '(gh.nvim) Collapse' },
			{ '<leader>ghi',  group = 'Issues' },
			{ '<leader>ghip', ':GHPreviewIssue<cr>',   desc = '(gh.nvim) Preview' },
			{ '<leader>ghl',  group = 'Litee' },
			{ '<leader>ghlt', ':LTPanel<cr>',          desc = '(gh.nvim) Toggle Panel' },
			{ '<leader>ghp',  group = 'Pull Request' },
			{ '<leader>ghpc', ':GHClosePR<cr>',        desc = '(gh.nvim) Close' },
			{ '<leader>ghpd', ':GHPRDetails<cr>',      desc = '(gh.nvim) Details' },
			{ '<leader>ghpe', ':GHExpandPR<cr>',       desc = '(gh.nvim) Expand' },
			{ '<leader>ghpo', ':GHOpenPR<cr>',         desc = '(gh.nvim) Open' },
			{ '<leader>ghpp', ':GHPopOutPR<cr>',       desc = '(gh.nvim) PopOut' },
			{ '<leader>ghpr', ':GHRefreshPR<cr>',      desc = '(gh.nvim) Refresh' },
			{ '<leader>ghpt', ':GHOpenToPR<cr>',       desc = '(gh.nvim) Open To' },
			{ '<leader>ghpz', ':GHCollapsePR<cr>',     desc = '(gh.nvim) Collapse' },
			{ '<leader>ghr',  group = 'Review' },
			{ '<leader>ghrb', ':GHStartReview<cr>',    desc = '(gh.nvim) Begin' },
			{ '<leader>ghrc', ':GHCloseReview<cr>',    desc = '(gh.nvim) Close' },
			{ '<leader>ghrd', ':GHDeleteReview<cr>',   desc = '(gh.nvim) Delete' },
			{ '<leader>ghre', ':GHExpandReview<cr>',   desc = '(gh.nvim) Expand' },
			{ '<leader>ghrs', ':GHSubmitReview<cr>',   desc = '(gh.nvim) Submit' },
			{ '<leader>ghrz', ':GHCollapseReview<cr>', desc = '(gh.nvim) Collapse' },
			{ '<leader>ght',  group = 'Threads' },
			{ '<leader>ghtc', ':GHCreateThread<cr>',   desc = '(gh.nvim) Create' },
			{ '<leader>ghtn', ':GHNextThread<cr>',     desc = '(gh.nvim) Next' },
			{ '<leader>ghtt', ':GHToggleThread<cr>',   desc = '(gh.nvim) Toggle' },
		}
	end,
}
