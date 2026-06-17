---
name: github
description: Load before running any gh commands to ensure correct CLI syntax. Use when creating/viewing PRs, checking pipelines, managing issues, or any Github operations.
---

## Tools

Prefer dedicated `github_pr_*` tools over raw `gh` for pull request workflows. Use `gh` when no dedicated tool fits. Use `gh api` only as a last resort.

Examples:

- `github_pr_comments` to read all PR review comments, including inline and review-level comments
- `github_pr_diff` to inspect the PR diff, optionally narrowed to one file
- `github_pr_ci` to inspect PR CI status and fetch failing job logs

Apply the same preference to other `github_pr_*` tools when they clearly match the request.
