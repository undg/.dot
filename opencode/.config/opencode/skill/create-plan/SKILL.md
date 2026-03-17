---
name: create-plan
description: Creates structured, executable plans for complex tasks. Load when asked to create a plan, break down a task, or organize multi-step work into actionable items.
---

# Create Plan Skill

Creates structured plans that integrate seamlessly with the execute-plan skill for systematic task completion.

## Core Workflow

When asked to create a plan:

1. **ANALYZE**: Understand the task scope, constraints, and requirements
2. **DECOMPOSE**: Break into logical, sequential steps
3. **STRUCTURE**: Format as todo items with priority and dependencies
4. **VALIDATE**: Ensure plan is actionable and complete

## Plan Structure

Each plan consists of todo items with:

- `content`: Clear, actionable description
- `status`: Always start as `pending`
- `priority`: `high`, `medium`, or `low` based on impact/blocking status

## Planning Principles

**Order matters**: Sequence steps by dependencies

- Prerequisites first (setup, config, dependencies)
- Blockers before blocked items
- Logical flow: analyze → design → implement → test → deploy

**Granularity**:

- 15-60 minutes per step (adjust for complexity)
- Too small = overhead; too large = unclear progress

**Clarity**:

- Use action verbs: "Implement", "Configure", "Test", "Review"
- Include success criteria where unclear
- Note dependencies explicitly

## Example

**Request**: "Create plan for adding user authentication"

**Output** (saved to `.opencode/plans/<name>.md`):

```md
# Add User Authentication — Plan

Branch: `feat/auth`

---

## General Instructions

Commit each task separately. Format: `type(scope): description`.

When picking a task, mark it `[!]`. When done, mark it `[x]`. Only pick tasks marked `[ ]`.

---

## Tasks

- [ ] **Analyze authentication requirements** (OAuth, JWT, sessions)
- [ ] **Set up authentication library and dependencies**
- [ ] **Create user model and database schema**
- [ ] **Implement login/logout endpoints**
- [ ] **Create login UI components**
- [ ] **Add authentication middleware for protected routes**
- [ ] **Write tests for auth flows**
- [ ] **Add password reset functionality**
- [ ] **Document authentication API**
```

## Common Plan Patterns

**Feature Development**:

1. Requirements/analysis
2. Design/architecture
3. Implementation (split by component)
4. Testing
5. Documentation

**Refactoring**:

1. Assess current state
2. Identify risk areas
3. Create safety net (tests)
4. Execute changes incrementally
5. Validate behavior preserved

**Bug Fix**:

1. Reproduce issue
2. Root cause analysis
3. Implement fix
4. Add regression test
5. Verify fix

## Integration with Execute-Plan

Plans are saved as `.opencode/plans/<name>.md` and use `[ ]` / `[!]` / `[x]` checkboxes. The execute-plan skill reads the file directly — no format conversion needed.

After creating a plan, user can immediately execute with: "execute this plan"
