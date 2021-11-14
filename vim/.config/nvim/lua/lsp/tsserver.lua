  return {
  -- cmd = { "typescript-language-server", "--stdio" },
  -- filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  -- init_options = {
  --   hostInfo = "neovim"
  -- },
  -- root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
  -- OR
  -- root_dir = function(fname)
  --   return nvim_lsp.util.root_pattern("tsconfig.json")(fname) or
  --     nvim_lsp.util.root_pattern("package.json", "jsconfig.json", ".git")(
  --       fname
  --     ) or
  --     vim.fn.getcwd()
  -- end
}
