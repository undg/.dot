local function get_pull_request_as_table()
    local gh_json_res = vim.fn.system('gh pr view --json title,body,commits,files')
    return vim.fn.json_decode(gh_json_res)
end

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
