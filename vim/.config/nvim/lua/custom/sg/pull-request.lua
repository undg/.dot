local map = require('utils.table').map

local function get_table()
    local json = vim.fn.system('gh pr view --json title,body,commits,files')
    local table = vim.fn.json_decode(json)

    local title = table['title']

    local description = table['body']

    local commits = map(table['commits'], function(commit)
        return commit['messageHeadline']
    end)

    local files = map(table['files'], function(file)
        return file['path']
    end)

    return {
        title = title,
        description = description,
        commits = commits,
        files = files,
    }
end

local function get_description()
    vim.api.nvim_command(
        'CodyTask '
        .. ' - Write a detailed PR description.'
        .. ' - The PR description should explain what the changes were made and why they were made.'
        .. ' - Here you have json with  title, description, commits titles and files that were changed in the PR.'
        .. '```diff'
        .. vim.fn.json_encode(get_table())
        .. '```'
    )
end

return {
    description = {
        get = get_description,
        desc = 'PR description generated with gh-cli and cody',
    },

    title = {
        get = function() end,
        desc = 'Not implemented',
    },

    labels = {
        get = function() end,
        desc = 'Not implemented',
    },
}
