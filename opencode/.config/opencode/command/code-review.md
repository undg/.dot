---
description: Review changes with parallel @code-review subagents
agent: plan
---

Review the code changes using THREE (3) @code-review subagents and correlate results into a summary ranked by severity. Use the provided user guidance to steer the review and focus on specific code paths, changes, and/or areas of concern.

Guidance: $ARGUMENTS

Review uncommitted changes by default only when the user did not point to a PR/MR and there is no open PR/MR for the current branch. If the user provides a pull request/merge request number or link, including shorthand like `#243`, `PR 243`, or `MR 243`, use CLI tools to resolve that PR/MR and review the full diff. Otherwise, check whether the current branch already has an open PR/MR and review that full PR/MR diff. If no PR/MR can be resolved and there are no uncommitted changes, review the full branch diff against its merge-base with the base branch. Review only the last commit as a final fallback.

When you are reviewing a PR/MR and you create or reuse a dedicated review worktree, first run `tmux display-message -p '#{window_id}'` and remember that `window_id`. Then call the `rename-tmux-window` tool exactly once from this orchestrator before launching the three `@code-review` subagents, passing that `window_id` together with the window name. Use the window name format `#<pr-number> <relative-worktree-path>` with the actual relative path of the review worktree you are using, for example `#69 .opencode/worktrees/pr-69-review-misty-garden`. If there is no work tree created, then use only pr number e.g. `#69`. If the rename does not apply, continue normally. Do not ask the subagents to rename tmux windows.
