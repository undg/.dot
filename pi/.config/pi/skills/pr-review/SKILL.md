---
name: pr-review
description: Delegate GitHub pull request review to the pr-review subagent and return only its actionable findings. Use when asked to review a PR.
---

# Pull Request Review Delegation

Do not review the pull request directly. Delegate it to the `pr-review`
subagent with the user's pull request number, URL, or review request as the
task. Use the `subagent` tool with the default user agent scope.

The subagent is read-only and returns only actionable findings. Pass its output
back to the user without adding a verdict, summary, style suggestions, or other
review narrative. If it returns `No actionable findings.`, relay that exactly.
