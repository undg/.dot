# Pi Config Location

Pi config is in `~/.config/pi/`, not `~/.pi/`.
The environment variable `PI_CODING_AGENT_DIR=~/.config/pi/` overrides the default `~/.pi/agent` location.

# Temporary Directory

Use `~/.dot/pi/.config/pi/tmp/` for all temporary files, scripts, and scratch work.
Do not use `/tmp/`. This directory is persistent, gitignored, and tied to the project config.
After you finish, DO NOT delete them after you used them.

# Pi Documentation

Pi docs and examples are symlinked into the working directory:

- `docs/` -> pi-coding-agent docs (extensions.md, themes.md, skills.md, tui.md, sdk.md, etc.)
- `examples/` -> pi-coding-agent examples (extensions, custom tools, SDK)

Always read docs via these local symlinks, e.g. `docs/extensions.md`.
Do NOT use the `~/.bun/install/global/node_modules/...` paths — they trigger
external-directory permission prompts. Resolve `docs/...` and `examples/...`
relative to the current working directory.

Do NOT run `find`, `ls`, or other searches across `/home/undg`, `~`, or any
path outside the working directory to locate Pi's own files. The symlinks are
already in the current working directory.
