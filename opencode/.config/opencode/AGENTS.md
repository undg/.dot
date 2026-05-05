# OpenCode Agent Guidelines

## Reading Files from Other Branches or PRs

Never use `gh api` + `base64 -d` pipelines to read files from remote branches. Use a worktree instead:

1. Create a worktree for the branch: `use-git-worktree` with `action: create`
2. Read files directly with the `read` tool from the worktree directory
3. Remove the worktree when done: `use-git-worktree` with `action: remove`

This applies even for quick one-off lookups. The `gh api` approach is fragile, pipes through shell decoding, and requires unnecessary permissions.

## Browser Testing & Debugging

For browser debugging, use the Chrome DevTools MCP server. Launch Chrome via `chrome-dev`, then include `use chrome-devtools` in your prompt.
