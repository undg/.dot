return {
    settings = {
        yaml = {
            schemas = {
                ['http://json.schemastore.org/gitlab-ci.json'] = { '.gitlab-ci.yml' },
                ['https://json.schemastore.org/bamboo-spec.json'] = { 'bamboo-specs/*.{yml,yaml}' },
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = {
                    'docker-compose*.{yml,yaml}',
                },
                ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
                ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
                ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/*.{yml,yaml}',
                ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
                ['http://json.schemastore.org/stylelintrc'] = '.stylelintrc.{yml,yaml}',
                ['http://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}',
                ['https://goreleaser.com/static/schema.json'] = '.goreleaser.{yml,yaml}',
                ['https://json.schemastore.org/lazygit.json'] = 'config.{yml,yaml}',
            },
        },
    },
}
