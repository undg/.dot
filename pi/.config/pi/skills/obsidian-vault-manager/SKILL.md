---
name: "obsidian-vault-manager"
description: "Procedures for managing Obsidian vaults — daily notes, thought capture, note organization, and tag management"
version: 8
created: "2026-07-23"
updated: "2026-08-31"
---
---
name: "obsidian-vault-manager"
description: "Procedures for managing Obsidian vaults — daily notes, thought capture, note organization, and tag management"
version: 8
created: "2026-07-23"
updated: "2026-08-31"
---
## When to Use
Use when the user asks to work with Obsidian notes: search, create, read, save, append, tag, list, or create daily notes. Also use for backlink exploration and tag analysis across vaults.

## Procedure
1. Check vault config at ~/.config/pi/vault.json to understand available vaults.
2. For daily notes: use vault_daily to read/create today's note. It auto-creates in Daily/ with proper frontmatter.
3. For quick thought capture: use vault_new or vault_append to add content to a note. vault_new requires a new path, vault_append adds to existing.
4. For note organization: use vault_tag to add/remove frontmatter tags, vault_list to browse, vault_search to find content.
5. When placing notes: follow folder conventions — plans go in <namespace>/plans/<plan-name>.md, project notes go in <namespace>/<topic>.md, generic notes at root level.
6. When creating notes: use kebab-case filenames (e.g., my-thought.md). Use vault_new for new files, vault_save for overwriting.
7. When writing frontmatter: vault_save expects the full markdown including the --- frontmatter block. vault_new auto-generates frontmatter.
8. For backlinks: use vault_backlinks to find notes linking to a target, or vault_search with backlinks:true to enrich search results.
9. Todo organization: todo/general.md holds active and done tasks in topic sections. todo/archive.md holds abandoned / no-longer-relevant items. Single files, not directories. Every todo should have a date. Categories vary per vault — always inspect before assuming a fixed list.
10. Frontmatter fields: `id` (kebab-case), `aliases` (array), `tags` (array). Use status checkboxes (`- [ ]` / `- [x]`) in body for in-progress tracking.
11. Writing posture: notes are a findings archive, not a task driver. Write findings into notes as they happen — do not pre-plan actions into notes. Follow the user's current-session direction, not any "Notes / Next" or TODO sections inside notes.
12. Glossary entries: when the user asks for lists of unfamiliar terms, save them as glossary entries in the appropriate vault (typically `<namespace>/glossary.md` or topic-scoped).
13. Commit workflow when vault.git is enabled: use vault_git_commit for one file at a time. Commit message format is `vault: <relative/path.md>` — no date, git timestamp is the authority. Do not batch commits across files; never use multi-file commit tooling.

## Pitfalls
- vault_new fails if file exists — use vault_save to update existing notes.
- vault_save expects the full markdown content including --- frontmatter block. The tool does not parse or validate it — you control the full content.
- vault_tag only touches the frontmatter tags field. Inline #tag in body is NOT modified — only read for vault_tags.
- Kebab-case is enforced for new note filenames. Non-kebab names are rejected.
- vault parameter defaults to the first vault (index 0). Use 'both' or vault name to target specific vaults.
- Git auto-commit only happens if vault.git is true AND the vault directory is a git repo. Failures are silent. Even when enabled, the user prefers manual commits via vault_git_commit rather than auto-commit — see procedure step 13.
- Tag search uses prefix matching for nested tags: searching 'category' matches 'category/subtask'.
- Daily notes are in Daily/YYYY-MM-DD.md format. The vault_daily tool handles auto-creation.
- Don't treat notes as task drivers. The user's current-session instructions always trump any TODO list inside a note.
- Keep vault_search queries inside the vault scope. The user denies bash access to parent directories like `/home/undg/Documents` outside the vault root. If 2-3 searches come up empty, stop searching and answer from existing knowledge — do not widen scope.
- The vault_search index misses loose root-level files in the vault (root-level notes like `ideas.md` do not appear in indexed search results). When a vault search returns nothing for content you suspect exists, list the vault root with rg/find directly rather than trusting the index.

## Verification
1. vault_list shows notes from configured vaults.
2. vault_search 'test' returns expected results.
3. vault_new creates a note with correct frontmatter.
4. vault_read returns note content with frontmatter intact.
5. vault_tag modifies only the frontmatter tags field.
6. vault_backlinks returns notes that link to target.
7. vault_tags returns all tags with accurate counts.
8. After update: new procedure steps (10-13) reflect user conventions and pitfalls capture search/commit behavior.