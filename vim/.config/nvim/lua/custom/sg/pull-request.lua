local map = require('utils.map')

local function get_json()
    return vim.fn.system('gh pr view --json title,body,commits,files')
end

local table = vim.fn.json_decode(get_json())

local title = table['title']
local body = table['body']
local commits = map(table['commits'], function(commit)
    return commit['messageHeadline']
end)

local files = map(table['files'], function(file)
    return file['path']
end)

local function get_description()
    local pr_diff = vim.fn.system('gh pr diff')

    -- @TODO (undg) 2023-10-29: improve. Use gh-cli to get json. Then skim json and provide (reduced to only neccessary data) context.
    vim.api.nvim_command(
        'CodyTask '
        .. ' - Write a detailed PR description.'
        .. ' - The PR description should explain what the changes were made and why they were made.'
        .. ' - Check the output of `gh diff` to ensure the PR description accurately reflects the changes. '
        .. '```diff'
        .. pr_diff
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
