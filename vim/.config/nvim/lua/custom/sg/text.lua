local function get_fix()
	vim.api.nvim_command('CodyTask ' .. 'CodyProofread')
end

return {
	proofread = {
		get = get_fix,
		desc = 'Text: Proofread the selected text for spelling, grammar, and English correctness.',
	},
}
