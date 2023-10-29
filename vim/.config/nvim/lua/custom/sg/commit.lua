local function get_git_diff()
    return vim.fn.system('git diff --cached')
end

local function get_commit()
    local git_diff = get_git_diff()

    vim.api.nvim_command(
        'CodyTask '
        ..
        ' - Start with a short title that explains the main purpose of the commit. This should be on the first line. Prefix with text in current line.'
        ..
        ' - Add a blank line after the title, then provide a longer description of the changes if needed. The description should explain why the changes were made and any relevant context. '
        ..
        ' - Use the imperative mood when describing what the commit does. For example: "Update README" rather than "Updated README". '
        ..
        ' - Keep commit messages short but informative. About 50-72 characters for the title, and no more than 72 characters per line in description. '
        .. ' - Check the output of `git diff --cached` to ensure the commit message accurately reflects the changes. '
        .. '```diff'
        .. git_diff
        .. '```'
    )
end

local function get_title()
    local git_diff = get_git_diff()

    vim.api.nvim_command(
        'CodyTask '
        ..
        ' - Start with a short title that explains the main purpose of the commit. This should be only the first line. Prefix with text in current line.'
        .. ' - Keep commit title short but informative. About 50-72 characters. '
        .. ' - Check the output of `git diff --cached` to ensure the commit message accurately reflects the changes. '
        .. '```diff'
        .. git_diff
        .. '```'
    )
end

local function get_description()
    local git_diff = get_git_diff()

    vim.api.nvim_command(
        'CodyTask '
        .. ' - Skip title provide only description that explains the main purpose of the commit.'
        ..
        ' - Provide a longer description of the changes. The description should explain why the changes were made and any relevant context. '
        ..
        ' - Use the imperative mood when describing what the commit does. For example: "Update README" rather than "Updated README". '
        .. ' - Keep commit messages short but informative, no more than 72 characters per line in description. '
        .. ' - Check the output of `git diff --cached` to ensure the commit message accurately reflects the changes. '
        .. '```diff'
        .. git_diff
        .. '```'
    )
end

return {
    message = {
        get = get_commit,
        desc = 'Generate full commit message',
    },

    open_with_message = {
        get = function()
            vim.api.nvim_command('G commit')
            get_commit()
        end,
        desc = 'Open git commit then generate full message',
    },

    title = {
        get = get_title,
        desc = 'Generate commit title',
    },

    description = {
        get = get_description,
        desc = 'Generate commit description',
    },
}
