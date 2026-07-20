local M = {
	"moll/vim-bbye", -- https://github.com/moll/vim-bbye
	-- :Bdelete and :Bwipeout, close buffer without messing up window layout
}

--- Close all listed buffers except the current one, preserving window layout.
local function close_other_buffers()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if buf.bufnr ~= current then
			vim.cmd("Bdelete " .. buf.bufnr)
		end
	end
end

local CMD_CLOSE_GP_CHATS =
":execute 'bufdo if expand(\"%:p\") =~ \"^' . expand('~/.local/share/nvim/gp/chats/') . '.*.md$\" | bd! | endif'<cr>"

function M.config()
	Keymap.normal("<C-Q>", ":Bdelete<cr>", { desc = "Close Buffer" })
	Keymap.normal("<leader>qq", ":Bdelete<cr>", { desc = "Close Buffer" })
	Keymap.normal("<leader>bD", ":Bdelete<cr>", { desc = "Close Buffer" })
	Keymap.normal("<leader>bn", ":bnext<cr>", { desc = "Buffer next" })
	Keymap.normal("<leader>bp", ":bprevious<cr>", { desc = "Buffer prev" })
	Keymap.normal("<leader>bdd", close_other_buffers, { desc = "Close Buffers other than current" })
	Keymap.normal("<leader>bda", CMD_CLOSE_GP_CHATS, { desc = "Close Buffer with gp.nvim chats" })

	local wkey_ok, wk = pcall(require, "which-key")
	if wkey_ok then
		wk.add({
			{ "<leader>b",  group = "Buffer" },
			{ "<leader>bd", group = "Buffer Close" },
		})
	end
end

return M
