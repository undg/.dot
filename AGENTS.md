# Agent Guidelines for OpenCode Configuration

## Repository Structure
- `opencode/.config/opencode/opencode.json` - Main OpenCode configuration
- `opencode/.config/opencode/agent/` - Custom agent definitions (markdown files with YAML frontmatter)

## File Format
Agent definition files use markdown with YAML frontmatter:
- Required frontmatter: `description`, `mode: subagent`, `model`, `tools`, `permission`
- Temperature: 0.1 (review), 0.2 (debug), 0.3 (test), adjust based on task determinism
- Tools: Grant minimal permissions needed (write/edit only if creating/modifying files)
- Permission: Use `allow` for safe commands, `ask` for potentially destructive ones

## Naming & Style
- Agent files: lowercase, descriptive names (debug.md, test.md, prdescription)
- Focus agent instructions on specific role and workflow
- Use numbered steps for processes, bullet points for guidelines
- Keep instructions concise but comprehensive

## Best Practices
- Never grant unnecessary tool permissions (principle of least privilege)
- Test-related agents should allow test runners without asking
- Review/analysis agents should not have write/edit/bash permissions
- Use specific command patterns in bash permissions (e.g., "npm test*": allow)
