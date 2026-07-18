---
name: skill-create
description: Create or improve agent skills for OpenCode or Claude with proper family methodology. Load when creating new SKILL.md files, improving existing skills, establishing skill structure, or defining skill family patterns.
---

# Creating Agent Skills

Skills extend agent capabilities with domain-specific knowledge. Use skills for procedural knowledge the agent lacks—not for concepts it already understands.

If guidance is project-specific or one-off, use INSTRUCTIONS.md or inline context instead.

## Structure

### Required Frontmatter

Every SKILL.md must start with YAML frontmatter on line 1:

```yaml
---
name: my-skill-name
description: What this skill does and when to use it. Third-person.
---
```

**Field requirements:**
- `name`: lowercase, hyphens only, max 64 chars, no reserved words ("anthropic", "claude")
- `description`: max 1024 chars, specific triggers + capabilities

### File Organization

```
skill-{family}-{name}/    # Inverse naming for sorting
├── SKILL.md              # Required. Under 200 lines.
└── references/           # Optional. For detailed content.
    ├── api.md
    └── examples.md
```

Use `references/` when SKILL.md exceeds 200 lines. Keep references one level deep—avoid nested file references.

## Skill Family Framework

All skills belong to a family with consistent methodology. This ensures skills work together predictably.

| Family | Workflow Pattern | Purpose | Example |
|--------|-----------------|---------|---------|
| **create-*** | Design → Structure → Validate | Generate new artifacts | skill-create-plan, skill-create-pr |
| **execute-*** | Initialize → Track → Complete | Multi-step execution | skill-execute-plan, skill-execute-deploy |
| **update-*** | Analyze → Modify → Verify | Change existing artifacts | skill-update-plan, skill-update-skill |
| **review-*** | Assess → Report → Recommend | Quality evaluation | skill-review-code, skill-review-pr |

**Family Consistency Requirements:**
- All skills in a family share the same workflow pattern
- Output formats must be compatible with handoff targets
- Use inverse naming: `skill-{family}-{name}` for directory sorting
- Each skill family has a defining skill that establishes the pattern

**Handoff Chain:**
```
create-* → execute-* → update-* → review-*
```

Skills should indicate their position in the chain and what skill typically follows.

## Writing Descriptions

The description determines when the skill activates. Include both **what it does** and **when to use it**.

**Always use third-person** (the description is injected into the system prompt):

| Quality | Example |
|---------|---------|
| Good | `Manages GitLab MRs and pipelines via glab CLI. Load before running glab commands.` |
| Good | `Analyzes web performance with Chrome DevTools MCP. Use when auditing page load or Lighthouse scores.` |
| Bad | `I help you with GitLab operations.` |
| Bad | `Useful for various tasks.` |

Include key terms users might mention: tool names, file extensions, specific operations.

## Content Guidelines

### Match Specificity to Task Fragility

**High freedom** (multiple valid approaches):
```markdown
Review code for potential bugs, readability, and adherence to project conventions.
```

**Medium freedom** (preferred pattern with variation):
```markdown
Use pdfplumber for text extraction. For scanned PDFs requiring OCR, use pdf2image instead.
```

**Low freedom** (fragile operations):
```markdown
Run exactly: `python scripts/migrate.py --verify --backup`
Do not modify flags.
```

### Writing Style

- **Imperative form**: "Use X" not "You should use X"
- **Assume competence**: Skip explanations of concepts the agent knows
- **One term, consistent**: Pick "endpoint" or "route", not both
- **No time-sensitive content**: Avoid "as of 2025" or "after next release"

### Quick Reference Tables

For CLIs and APIs, provide lookup tables:

```markdown
| Task | Command |
|------|---------|
| Check status | `glab ci status` |
| View logs | `glab ci trace <job>` |
| Retry job | `glab ci retry <job>` |
```

## Common Patterns

### Prerequisite Verification

Check requirements before proceeding:

```markdown
## FIRST: Verify Installation

Run this before any commands. If it fails, STOP—this skill doesn't apply.

\`\`\`bash
glab --version
\`\`\`
```

### Workflow Checklists

For multi-step tasks, provide a copyable checklist:

```markdown
## Workflow

Copy this checklist to track progress:

\`\`\`
- [ ] Step 1: Analyze input
- [ ] Step 2: Validate mapping
- [ ] Step 3: Apply changes
- [ ] Step 4: Verify output
\`\`\`
```

### Concrete Examples

Show input/output pairs instead of abstract descriptions:

```markdown
**Input**: Added user authentication with JWT tokens
**Output**:
\`\`\`
feat(auth): implement JWT-based authentication
\`\`\`
```

## Anti-patterns

- **Verbose explanations**: Don't explain what PDFs are or how libraries work
- **Multiple options without defaults**: Recommend one approach, mention alternatives briefly
- **Vague descriptions**: "Helps with documents" won't activate correctly
- **Deeply nested references**: SKILL.md → file.md → another.md breaks navigation
- **Magic constants**: Document why values were chosen, or let the agent decide

## Checklist

Before finalizing a skill:

- [ ] Belongs to a skill family (create/execute/update/review)
- [ ] Uses inverse naming: `skill-{family}-{name}`
- [ ] Follows family-specific workflow pattern
- [ ] Defines output format for handoff to next skill
- [ ] Frontmatter starts on line 1 with `---`
- [ ] `name` matches directory name
- [ ] `description` includes triggers AND capabilities (third-person)
- [ ] SKILL.md is under 200 lines (use `references/` if larger)
- [ ] References are one level deep from SKILL.md
- [ ] Imperative form throughout ("Use X" not "You should")
- [ ] Quick reference table for any CLI/API commands
- [ ] Prerequisite verification if skill depends on tools/config
- [ ] No time-sensitive information
- [ ] Tested with representative tasks
