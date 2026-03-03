---
name: obsidian
description: Read, create, or update notes in Obsidian vaults. Handles multi-vault setup by detecting active vaults and asking the user which one to use. Load when working with personal notes, work notes, or any Obsidian markdown files.
---

# Skill: obsidian

## Vault Locations

| Vault    | Path                   |
| -------- | ---------------------- |
| Work     | `~/Documents/Work`     |
| Personal | `~/Documents/Personal` |
| Vimwiki  | `~/Documents/vimwiki`  |

## FIRST: Detect Active Vaults

Before any operation, check which vaults are active (exist AND contain `.md` files):

```bash
for vault in ~/Documents/Work ~/Documents/Personal ~/Documents/vimwiki; do
  count=$(find "$vault" -name "*.md" 2>/dev/null | wc -l)
  echo "$vault: $count"
done
```

- If count > 0 → vault is active
- If count = 0 or directory missing → skip it

## Vault Selection

- **One active vault** → use it silently, no need to ask
- **Multiple active vaults** → ask the user which one before proceeding

## Note Conventions (Work vault)

- Plain `.md` files, no strict naming convention outside of tickets
- Tickets live in `~/Documents/Work/tickets/` with format: `{ticketNumber} ({type}) {Title}.md`
- Use YAML frontmatter with `id`, `aliases`, `tags`
- Tags should be lowercase, hyphen-separated

## Operations

**Find a note:**

```bash
find ~/Documents/Work -name "*.md" | xargs grep -l "search term"
```

**Create a note** — use Write tool with frontmatter:

```markdown
---
id: Note Title
aliases: []
tags:
  - relevant-tag
---
```

**Update a note** — read first, then edit with Edit tool.
