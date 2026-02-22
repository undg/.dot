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

**Output**:
```
Plan: Add User Authentication

1. [high] Analyze authentication requirements (OAuth, JWT, sessions)
2. [high] Set up authentication library and dependencies
3. [high] Create user model and database schema
4. [high] Implement login/logout endpoints
5. [medium] Create login UI components
6. [medium] Add authentication middleware for protected routes
7. [medium] Write tests for auth flows
8. [low] Add password reset functionality
9. [low] Document authentication API
```

**In todo format** (for execute-plan compatibility):
```json
{
  "todos": [
    {"content": "Analyze authentication requirements (OAuth, JWT, sessions)", "status": "pending", "priority": "high"},
    {"content": "Set up authentication library and dependencies", "status": "pending", "priority": "high"},
    {"content": "Create user model and database schema", "status": "pending", "priority": "high"},
    {"content": "Implement login/logout endpoints", "status": "pending", "priority": "high"},
    {"content": "Create login UI components", "status": "pending", "priority": "medium"},
    {"content": "Add authentication middleware for protected routes", "status": "pending", "priority": "medium"},
    {"content": "Write tests for auth flows", "status": "pending", "priority": "medium"},
    {"content": "Add password reset functionality", "status": "pending", "priority": "low"},
    {"content": "Document authentication API", "status": "pending", "priority": "low"}
  ]
}
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

Created plans are designed for seamless handoff:
- Same todo structure
- Ready for status tracking
- Compatible with todowrite tool

After creating a plan, user can immediately execute with: "execute this plan"
