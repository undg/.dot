---
name: create-skill
description: Use this skill when creating or updating a SKILL.md file
---

# Create or Update a Skill

Follow the current Pi skills documentation instead of duplicating its rules here:

- [Pi Skills documentation](https://pi.dev/docs/latest/skills)
- When working in the Pi source tree, also read its local `docs/skills.md`.

This skill only adds local preferences and paths.

## Local Setup

- Pi configuration is stored in `~/.config/pi/`.
- In this setup, that configuration is versioned at `~/.dot/pi/.config/pi/`.
- Personal skills live in `~/.dot/pi/.config/pi/skills/`.
- A skill is normally a directory containing `SKILL.md`; keep helper files beside it and reference them with paths relative to the skill directory.

## Preferences

1. Create a skill only for a reusable workflow. Do not create one for temporary task state or a one-off summary.
2. Keep skills small, concrete, and easy to follow. Prefer the simplest workflow that works.
3. Use exact commands and paths where they matter, but do not copy Pi's general skill specification into the skill.
4. Avoid unnecessary abstraction, duplicated guidance, and project-specific details that do not belong in a reusable skill.
5. Review the finished skill for ambiguity and verify it against the current Pi documentation.
