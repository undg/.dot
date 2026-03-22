# Agent Guidelines for Television Configuration

This repository contains configuration files for [television](https://github.com/alexpasmantier/television) (tv), a Rust-based fuzzy finder tool.

## Repository Structure

- `config.toml` - Main television configuration (UI, keybindings, shell integration)
- `cable/` - Custom channel plugins (tv's extension system)
  - Each cable has a `.toml` configuration file
  - Optional `.sh` helper script for complex source/preview logic

## Build/Test Commands

**No build system** - This is a pure configuration repository.

**Validation:**
```bash
# Validate TOML syntax
toml-test config.toml
toml-test cable/*.toml

# Test shell scripts for syntax errors
bash -n cable/*.sh

# Test a cable by running it
tv <cable-name>
```

## Code Style Guidelines

### TOML Files
- Use 4-space indentation
- Group related settings under appropriate sections
- Use kebab-case for multi-word keys
- Quote string values consistently
- Prefer arrays over inline tables for requirements

### Cable Configuration
Required structure:
```toml
[metadata]
name = "channel-name"           # Lowercase with hyphens
description = "What this does"    # Concise, sentence case
requirements = ["dep1", "dep2"]     # Optional: required CLI tools

[source]
command = "command to generate entries"
display = "{format}"              # Optional: display transformation
output = "{format}"               # Final output transformation
ansi = true                       # Optional: preserve ANSI colors

[preview]
command = "command to preview '{}'"

[actions.name]
description = "What this action does"
command = "command to execute"
mode = "execute" | "fork"         # execute=wait, fork=background
```

### Shell Scripts
- Use `#!/bin/bash` with `set -euo pipefail` for new scripts
- Include usage comment at top
- Filter sensitive data (API keys, tokens, passwords) in previews
- Handle both `source` and `preview` modes via case statement

### Naming Conventions
- **Cables**: lowercase with hyphens (e.g., `gh-prs`, `tmux-sessions`)
- **Actions**: lowercase with hyphens (e.g., `attach`, `kill-session`)
- **Scripts**: match the cable name (e.g., `env.sh` for `env.toml`)
- **Variables in format strings**: Use `{split:delimiter:index}` syntax

### Security Guidelines
- Never log or display sensitive values (tokens, passwords, keys)
- Use `strip_ansi` filter when extracting values from colored output
- Validate external commands exist before using them

### Format String Reference
- `{split:delim:index}` - Split and extract field
- `{strip_ansi}` - Remove ANSI color codes
- `{regex:pattern:group}` - Regex extraction
- Pipe filters together: `{strip_ansi|split:#:1}`
