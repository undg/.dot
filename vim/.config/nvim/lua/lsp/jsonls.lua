return {
    filetypes = { 'json', 'jsonc' },
    cmd = { '/home/undg/.local/share/nvim/lsp_servers/jsonls/node_modules/.bin/vscode-json-language-server', '--stdio' },
    settings = {
        json = {
            schemas = {
                tsconfig = {
                    description = 'TypeScript compiler configuration file',
                    fileMatch = {'tsconfig.json', 'tsconfig.*.json'},
                    url = 'http://json.schemastore.org/tsconfig'
                },
                lerna = {
                    description = 'Lerna config',
                    fileMatch = {'lerna.json'},
                    url = 'http://json.schemastore.org/lerna'
                },
                babel = {
                    description = 'Babel configuration',
                    fileMatch = {'.babelrc.json', '.babelrc', 'babel.config.json'},
                    url = 'http://json.schemastore.org/lerna'
                },
                eslint = {
                    description = 'ESLint config',
                    fileMatch = {'.eslintrc.json', '.eslintrc'},
                    url = 'http://json.schemastore.org/eslintrc'
                },
                bucklescript = {
                    description = 'Bucklescript config',
                    fileMatch = {'bsconfig.json'},
                    url = 'https://bucklescript.github.io/bucklescript/docson/build-schema.json'
                },
                prettier = {
                    description = 'Prettier config',
                    fileMatch = {'.prettierrc', '.prettierrc.json', 'prettier.config.json'},
                    url = 'http://json.schemastore.org/prettierrc'
                },
                vercel = {
                    description = 'Vercel Now config',
                    fileMatch = {'now.json'},
                    url = 'http://json.schemastore.org/now'
                },
                stylelint = {
                    description = 'Stylelint config',
                    fileMatch = {'.stylelintrc', '.stylelintrc.json', 'stylelint.config.json'},
                    url = 'http://json.schemastore.org/stylelintrc'
                },
            }
        },
    }
}
