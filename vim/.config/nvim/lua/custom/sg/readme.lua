local function get_body()
    vim.api.nvim_command(
        'CodyTask '
        .. 'Write a detailed README.md file to document the code located in the same directory as my current selection.'
        .. 'Summarize what the code in this directory is meant to accomplish.'
        .. 'Explain the key files, functions, classes, and features.'
        .. 'Use Markdown formatting for headings, code blocks, lists, etc. to make the it organized and readable.'
        ..
        'Aim for a beginner-friendly explanation that gives a developer unfamiliar with the code a good starting point to understand it.'
        .. 'Make sure to include:'
        .. ' - Overview of directory purpose'
        .. ' - Functionality explanations'
        ..
        ' - Relevant diagrams or visuals if helpful. Write the README content clearly and concisely using complete sentences and paragraphs based on the shared context.'
        .. 'Use proper spelling, grammar, and punctuation throughout.'
        .. 'Do not make assumptions or fabricating additional details.'
        .. vim.fn.system('ls %:p:h')
    )
end

return {
    body = {
        get = get_body,
        desc = 'Generate content for a README.md file',
    },
}
