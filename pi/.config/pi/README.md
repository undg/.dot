# Pi Coding Agent Configuration

This directory is Pi's agent configuration, exposed at `~/.config/pi` via a symlink to the dotfiles repo.

## Layout

| Path            | Purpose                                                             |
| --------------- | ------------------------------------------------------------------- |
| `settings.json` | Pi core settings: provider, model, npm command, installed packages. |
| `AGENTS.md`     | Project-level agent instructions (e.g., Grug).                      |
| `auth.json`     | API key lookup config (not the keys themselves).                    |
| `extensions/`   | Extension configs and logs.                                         |
| `npm/`          | Local package workspace for Pi extensions.                          |
| `sessions/`     | Session data (ignored by git).                                      |
| `get-api-key`   | Helper script for fetching API keys.                                |

## Permissions

Permissions are enforced by the `pi-permission-system` extension:

- Config: `extensions/pi-permission-system/config.json`
- Audit log: `extensions/pi-permission-system/logs/pi-permission-system-permission-review.jsonl`

The config was ported from OpenCode's `permission` block in `opencode.json`.

### Key decisions

- Top-level fallback is `"*": "allow"`, matching OpenCode's default permissiveness.
- `.env`, `.git/`, and `.ssh/` are blocked via the cross-cutting `path` surface, so they are protected for all file tools and bash.
- Outside-working-directory access defaults to `ask`, with explicit allow rules for `~/Documents/Work/*` and `~/Documents/Personal/*`.
- Bash commands follow the same allow/ask/deny list as OpenCode.
- `mcp` currently defaults to `ask`; `code-review-graph` is not enabled yet.

Validate the config against the extension's schema:

```bash
cd /tmp
cat > validate-config.ts <<'EOF'
import { unifiedConfigSchema } from '/home/undg/.dot/pi/.config/pi/npm/node_modules/.pnpm/@gotgenes+pi-permission-system@20.7.3/node_modules/@gotgenes/pi-permission-system/src/config-schema.ts';
import config from '/home/undg/.dot/pi/.config/pi/extensions/pi-permission-system/config.json' with { type: 'json' };

const result = unifiedConfigSchema.safeParse(config);
if (result.success) {
  console.log('valid');
} else {
  console.error(result.error);
  process.exit(1);
}
EOF
bun validate-config.ts
rm validate-config.ts
```

## Authentication

API keys are not stored in this repo. `auth.json` contains entries that tell Pi how to retrieve a key from the OS keyring at runtime.

Example `auth.json`:

```json
{
  "opencode": {
    "type": "api_key",
    "key": "!$HOME/.config/pi/get-api-key brave-api"
  }
}
```

The `!` prefix means the value is a shell command to execute; the output becomes the API key.

The helper script `get-api-key` reads from:

- **Linux:** `secret-tool` (libsecret / GNOME Keyring)
- **macOS:** `security find-generic-password` (Keychain)

### Saving a key

**Linux (secret-tool):**

```bash
secret-tool store --label="Pi OpenCode" service opencode
# paste the key when prompted
```

**macOS (security):**

```bash
security add-generic-password -s "pi-opencode" -a "$USER" -w
# type the key and press Enter, then Ctrl-D
```

To add a new provider, store it with the same `provider <name>` / service `pi-<name>` pattern and add a matching entry to `auth.json`.

## The `npm/` directory

`npm/` is Pi's local package workspace for extensions.

- `package.json` lists installed packages (e.g., `@gotgenes/pi-permission-system`).
- `pnpm-lock.yaml` and `pnpm-workspace.yaml` track the pnpm install.
- `node_modules/` holds the actual downloaded packages.
- `npm/.gitignore` ignores everything inside `npm/` except itself, so dependencies are not committed.

Do not delete the folder — Pi recreates it when it installs packages. Only `npm/.gitignore` should be tracked in git.

## Useful references

- [pi-permission-system configuration docs](https://github.com/gotgenes/pi-packages/tree/main/packages/pi-permission-system/docs/configuration.md)
- [pi-permission-system OpenCode compatibility guide](https://github.com/gotgenes/pi-packages/tree/main/packages/pi-permission-system/docs/opencode-compatibility.md)
