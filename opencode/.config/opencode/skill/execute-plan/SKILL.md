---
name: execute-plan
description: Executes multi-step plans systematically by tracking progress through todo lists. Load when given a plan with multiple steps or when working through a complex task requiring step-by-step execution.
---

# Execute Plan Skill

Executes multi-step plans by tracking progress and ensuring systematic completion.

## General Instructions

Plans are stored as markdown files (e.g. `.opencode/plans/<name>.md`). Before executing:

1. **Read the plan file** to get the task list and any project-specific instructions (commit format, branch, etc.)
2. **Follow the plan's own General Instructions** if present — they take precedence over defaults here
3. **Mark tasks in the plan file** as you work:
   - `[ ]` — not yet started
   - `[!]` — in progress (pick only one at a time)
   - `[x]` — done
   - Only pick tasks currently marked `[ ]`
4. **Commit after each task** unless the plan says otherwise. Use the commit format specified in the plan. If none is given, use conventional commits: `type(scope): short imperative description`
5. **Keep the plan file in sync** — update task markers before committing so the plan reflects reality

## Core Workflow

When given a plan with multiple steps:

1. **INITIALIZE**: Read the plan file → create todo list with todowrite tool
2. **EXECUTE**: Work through steps one at a time, updating both the todo list and the plan file
3. **COMPLETE**: Mark done in both places and verify

## Todo List Structure

Each todo item needs:

- `content`: Clear description of the step
- `status`: `pending`, `in_progress`, `completed`, or `cancelled`
- `priority`: `high`, `medium`, or `low`

## Status Management Rules

**Only ONE task in_progress at any time**

State transitions:

```
pending → in_progress → completed
                ↓
           cancelled
```

Update status IMMEDIATELY after:

- Starting work on a step (in_progress)
- Completing a step (completed)
- Deciding a step is not needed (cancelled)

## Execution Pattern

```
1. Read plan file, note any General Instructions
2. Create todo list from plan tasks
3. Mark first task [!] in plan file, in_progress in todo
4. Execute the task
5. Mark task [x] in plan file, completed in todo
6. Commit (per plan instructions)
7. Repeat until done
```

## Example

**Plan file** (`.opencode/plans/my-plan.md`):

```md
- [ ] Set up project structure
- [ ] Install dependencies
- [ ] Create config files
- [ ] Build components
```

**While working**:

```md
- [x] Set up project structure
- [!] Install dependencies
- [ ] Create config files
- [ ] Build components
```

**When done**:

```md
- [x] Set up project structure
- [x] Install dependencies
- [x] Create config files
- [x] Build components
```

## Key Principles

- **Atomic updates**: Mark complete immediately when done
- **Single in-progress**: Never have multiple in_progress tasks
- **Visible progress**: User should see what's being worked on
- **Never skip tracking**: Even simple tasks get tracked in multi-step work
- **Plan file is the source of truth**: Always update it alongside the todo list
