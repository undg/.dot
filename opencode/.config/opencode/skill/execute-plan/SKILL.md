---
name: execute-plan
description: Executes multi-step plans systematically by tracking progress through todo lists. Load when given a plan with multiple steps or when working through a complex task requiring step-by-step execution.
---

# Execute Plan Skill

Executes multi-step plans by tracking progress and ensuring systematic completion.

## Core Workflow

When given a plan with multiple steps:

1. **INITIALIZE**: Convert plan to todo list with todowrite tool
2. **EXECUTE**: Work through steps one at a time, updating status
3. **COMPLETE**: Mark done and verify

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
1. Create todo list from plan
2. Mark first task in_progress
3. Execute the task
4. Mark task completed
5. Mark next task in_progress
6. Repeat until done
```

## Example

**Plan given**:
- Set up project structure
- Install dependencies
- Create config files
- Build components

**Correct execution**:
```typescript
// 1. Initialize
{"todos": [
  {"content": "Set up project structure", "status": "in_progress", "priority": "high"},
  {"content": "Install dependencies", "status": "pending", "priority": "high"},
  {"content": "Create config files", "status": "pending", "priority": "high"},
  {"content": "Build components", "status": "pending", "priority": "medium"}
]}

// 2. After setting up structure
{"todos": [
  {"content": "Set up project structure", "status": "completed", "priority": "high"},
  {"content": "Install dependencies", "status": "in_progress", "priority": "high"},
  ...
]}
```

## Key Principles

- **Atomic updates**: Mark complete immediately when done
- **Single in-progress**: Never have multiple in_progress tasks
- **Visible progress**: User should see what's being worked on
- **Never skip tracking**: Even simple tasks get tracked in multi-step work
