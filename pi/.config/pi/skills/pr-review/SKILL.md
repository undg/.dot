---
name: pr-review
description: Review a GitHub pull request for actionable correctness, security, and maintainability issues
---

# Pull Request Review

Review the pull request without modifying files unless explicitly asked.
Focus on improving code health, not on achieving perfect code.

## Setup

Gather the pull request context with:

1. `gh pr view` - read the PR number, title, description, linked requirements, and metadata.
2. `gh pr diff` - inspect the complete change.
3. `gh pr checks` - inspect the current status of GitHub checks. Do not wait for pending checks.

Also read relevant repository guidance before reviewing, including `AGENTS.md`,
`CLAUDE.md`, contribution guides, and project-specific documentation.

## Review process

1. Understand the intended behavior, scope, and affected interfaces.
2. Review every meaningful changed line.
3. Read surrounding code, callers, interfaces, migrations, and tests when the diff alone is insufficient.
4. Prioritize correctness and security before style:
   - authentication, authorization, secrets, and input validation
   - functional correctness, edge cases, and error handling
   - data loss, concurrency, and resource cleanup
   - API, schema, and backwards compatibility
   - tests and regression coverage
   - performance and operational behavior
   - unnecessary complexity and maintainability
5. Check whether the PR's tests and validation are sufficient.
6. Report only actionable findings supported by evidence.

## Review rules

- Do not block on personal style preferences.
- Do not report speculative problems without a plausible failure scenario.
- Do not duplicate findings or suggest unrelated refactoring.
- Distinguish failed checks, pending checks, skipped checks, and checks that were not run.
- Keep the review focused. Prefer a few high-confidence findings over many weak suggestions.
- Do not silently fix issues or change the working tree.

## Finding format

For each finding, include:

- **Severity:** `BLOCKER`, `IMPORTANT`, or `MINOR`
- **Location:** exact `path/to/file:line`
- **Problem:** precise explanation of what is wrong
- **Impact:** what can fail and under which conditions
- **Fix:** the smallest practical remediation
- **Confidence:** `HIGH`, `MEDIUM`, or `LOW`

Only report low-confidence findings when they represent a serious security or
data-loss risk.

## Output

### Verdict

Use one of:

- `APPROVE` - no actionable issues found.
- `APPROVE_WITH_NOTES` - no blocking issues, but optional observations remain.
- `REQUEST_CHANGES` - a credible correctness, security, compatibility, data-loss, or regression issue must be fixed.

### Summary

Briefly describe:

- what the PR changes
- the main risk areas
- validation performed and its result

### Findings

List findings ordered by severity. If there are none, write:

> No actionable findings.

### Unverified

List tests, environments, requirements, or behavior that could not be checked.
