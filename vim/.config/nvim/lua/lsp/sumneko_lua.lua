return {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- this is some bullshit.
-- @TODO (undg) 2022-11-07: check if anything from here is needed and DELETE IT
-- local os_name
-- if vim.fn.has("mac") == 1 then
--     os_name = "macOS"
-- elseif vim.fn.has("unix") == 1 then
--     os_name = "Linux"
-- -- elseif vim.fn.has('win32') == 1 then
-- --     os_name = "Windows"
-- else
--     print("Unsupported system for sumneko")
-- end

-- local sumneko_root_path = '/home/undg/.local/share/nvim/lsp_servers/sumneko_lua/extension/server/bin/' .. os_name
-- local sumneko_binary = sumneko_root_path .. '/lua-language-server'
-- local sumneko_main = sumneko_root_path .. '/main.lua'
--
-- local runtime_path = vim.split(package.path, ';')
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
--
-- return {
--   cmd = {sumneko_binary, "-E", sumneko_main};
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT',
--         -- Setup your lua path
--         path = runtime_path,
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = {'vim'},
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }
--
