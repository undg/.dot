-- https://github.com/mhartington/formatter.nvim/blob/master/CONFIG.md

local format = {}

function format.prettier()
    return {
        exe = "prettier",
        args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
        stdin = true
    }
end
function format.lua()
        return {
          exe = "stylua",
          args = {
            "--config-path "
              .. os.getenv("XDG_CONFIG_HOME")
              .. "/stylua/stylua.toml",
            "-",
          },
          stdin = true,
        }
      end

require('formatter').setup {
  logging = true,
  filetype = {
    typescript = { format.prettier },
    typescriptreact = { format.prettier },
    javascript = { format.prettier },
    javascriptreact = { format.prettier },
    css = { format.prettier },
    scss = { format.prettier },
    sass = { format.prettier },
    less = { format.prettier },
    json = { format.prettier },
    markdown = { format.prettier },
    md = { format.prettier },
    vimwiki = { format.prettier },
    yaml = { format.prettier },
    lua = { format.lua }
     }
}
