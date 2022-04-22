-- https://github.com/mhartington/formatter.nvim/blob/master/CONFIG.md
local map = require("../utils/map")

local F = {}

function F.prettier()
    return {
        exe = "prettier",
        args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)) },
        stdin = true,
    }
end

function F.prettierNoSemi()
    return {
        exe = "prettierNoSemi",
        args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)) },
        stdin = true,
    }
end

function F.lua()
    -- https://github.com/johnnymorganz/stylua
    return {
        exe = "stylua",
        args = {
            "--config-path ~/.config/stylua/stylua.toml",
            "-",
        },
        stdin = true,
    }
end

function F.shell()
    return {
        exe = "shfmt",
        args = { "-i", 4 },
        stdin = true,
    }
end

function F.python()
    return {
        exe = "black", -- install python-black
        args = { "-" },
        stdin = true,
    }
end

require("formatter").setup({
    logging = true,
    filetype = {

        typescript = { F.prettier },
        typescriptreact = { F.prettier },
        javascript = { F.prettier },
        javascriptreact = { F.prettier },

        css = { F.prettier },
        scss = { F.prettier },
        sass = { F.prettier },
        less = { F.prettier },
        json = { F.prettier },
        markdown = { F.prettier },
        md = { F.prettier },
        vimwiki = { F.prettier },
        yaml = { F.prettier },

        lua = { F.lua },

        sh = { F.shell },
        zsh = { F.shell },

        python = { F.python },
    },
})

map.normal("<leader>p", ":Format<cr>")
map.normal("<leader>;;", ":Format prettier<cr>")
