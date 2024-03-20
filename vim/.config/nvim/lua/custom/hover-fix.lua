-- This is fix for false positive vim.notify "No information available" that is not true.
-- Other issues with same problem:
-- https://www.reddit.com/r/neovim/comments/xw9d4h/i_keep_getting_no_information_available_messages/
-- https://github.com/neovim/nvim-lspconfig/issues/1931

-- https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization

-- Border that will match styles that are set in other floating windows
local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
}

-- Replace hover function with custom implementation
vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
  config = config or {border = border}
  config.focus_id = ctx.method
  if not (result and result.contents) then
    return
  end
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    return
  end
  return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
end


