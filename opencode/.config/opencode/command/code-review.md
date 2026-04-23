---
description: Review changes with parallel @code-review subagents
agent: plan
---

Review the code changes using THREE (3) @code-review subagents and correlate results into a summary ranked by severity. Use the provided user guidance to steer the review and focus on specific code paths, changes, and/or areas of concern.

Guidance: $ARGUMENTS

Review uncommitted changes by default only when the user did not point to a PR/MR and there is no open PR/MR for the current branch. If the user provides a pull request/merge request number or link, including shorthand like `#243`, `PR 243`, or `MR 243`, use CLI tools to resolve that PR/MR and review the full diff. Otherwise, check whether the current branch already has an open PR/MR and review that full PR/MR diff. If no PR/MR can be resolved and there are no uncommitted changes, review the full branch diff against its merge-base with the base branch. Review only the last commit as a final fallback.
