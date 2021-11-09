  return {
    root_dir = function(fname)
      return nvim_lsp.util.root_pattern("tsconfig.json")(fname) or
        nvim_lsp.util.root_pattern("package.json", "jsconfig.json", ".git")(
          fname
        ) or
        vim.fn.getcwd()
    end
  }
