---
name: create-skill
description: Use this skill when creating or updating a SKILL.md file
---

# Create or Update a Skill

Before creating or updating a skill, read Pi's runtime documentation at:

`$HOME/.bun/install/global/node_modules/@earendil-works/pi-coding-agent/docs/skills.md`

The [online Pi Skills documentation](https://pi.dev/docs/latest/skills) is the fallback and reference for skill structure, frontmatter, discovery, validation, and invocation.

## Local Conventions

- Pi configuration is stored in `~/.config/pi/`.
- This dotfiles repository stores that configuration in `~/.dot/pi/.config/pi/`.
- Personal skills are stored in `~/.dot/pi/.config/pi/skills/`.
- Keep helper files beside their `SKILL.md` and reference them with paths relative to the skill directory.

## Preferences

- Create a skill only for a reusable workflow, not temporary task state or a one-off summary.
- Keep skills small, concrete, and easy to follow. Prefer the simplest workflow that works.
- Use exact commands and paths where they matter.
- Avoid unnecessary abstraction, duplicated guidance, and details that do not belong in a reusable skill.
- Review the finished skill for ambiguity and check it against the Pi documentation.
