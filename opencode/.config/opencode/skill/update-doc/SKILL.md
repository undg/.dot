---
name: update-doc
description: Updates or Create Go, JavaScript, TypeScript, Python, and Lua documentation. Use when working with godoc, JSDoc, TSDoc, Python docstrings, or EmmyLua annotations.
---

# Update Documentation

Use this skill for doc comments, docstrings, and annotation-based API docs.

## Workflow

1. Identify the language and read the matching reference.
2. Edit only the affected docs.
3. Keep wording short and behavior-focused.
4. Verify with the local formatter, linter, or doc tool.

## Shared Rules

- Follow the surrounding project convention first.
- Document intent, behavior, errors, side effects, and constraints.
- Do not repeat type information unless the language needs it.
- Skip trivial docs when the signature is already clear.
- Prefer the smallest correct change.

## References

| Language   | Reference              |
| ---------- | ---------------------- |
| Go         | `references/godoc.md`  |
| JavaScript | `references/jsdoc.md`  |
| TypeScript | `references/tsdoc.md`  |
| Python     | `references/pydoc.md`  |
| Lua        | `references/luadoc.md` |

## Handoff

This is an `update-*` skill. Hand off to `review-*` after the edit is applied.

## Verification

| Language                | Common check                |
| ----------------------- | --------------------------- |
| Go                      | `go doc`, `go vet`          |
| JavaScript / TypeScript | project linter or formatter |
| Python                  | `pydocstyle`, project tests |
| Lua                     | EmmyLua or LSP checks       |
