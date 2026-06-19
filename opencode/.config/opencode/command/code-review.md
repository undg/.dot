---
description: Review changes with parallel @code-review subagents
agent: plan
---

Review the code changes using THREE (3) @code-review subagents and correlate results into a summary ranked by severity. Use the provided user guidance to steer the review and focus on specific code paths, changes, and/or areas of concern.

Guidance: $ARGUMENTS

If user did not point to a PR number use `gh pr view` and then `gh pr diff`.

If the user provides a pull request request number or link, including shorthand like `#243`, `PR 243`, or `MR 243`, use CLI tool to resolve that PR and review the full diff e.g. `gh pr view 243` and then `gh pr diff 243`.

Provide output of those findings into subagents, so it doesn't need to repeat this step.

If no PR can be resolved and there are no uncommitted changes, review the full branch diff against its merge-base with the base branch.
