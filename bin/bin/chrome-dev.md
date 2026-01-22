# chrome-dev

Launch a dedicated Chrome instance for development, separate from your personal browsing.

## Features

- 🔒 **Isolated profile** - Separate from personal Chrome
- 💾 **Persistent auth** - Login once, stays logged in
- 🔌 **Remote debugging** - Accessible via port 9222
- 🛠️ **Dev tool integration** - Works with OpenCode, nvim-DAP, etc.

## Usage

```bash
# Launch with default URL (localhost:5173)
chrome-dev

# Launch with custom URL
chrome-dev http://localhost:3000

# Check if running
chrome-dev --status

# Reset profile (clear all data)
chrome-dev --reset

# Show help
chrome-dev --help
```

## Configuration

Environment variables:

- `CHROME_DEV_PROFILE` - Profile location (default: `~/.chrome-dev-profile`)
- `CHROME_DEBUG_PORT` - Remote debugging port (default: `9222`)
- `CHROME_DEV_URL` - Default URL (default: `http://localhost:5173`)

Example:

```bash
# Use different port and profile
CHROME_DEBUG_PORT=9223 CHROME_DEV_PROFILE=~/.chrome-custom chrome-dev
```

## Integration

### OpenCode Chrome DevTools MCP

Automatically connects to this Chrome instance when configured with:

```json
{
  "mcp": {
    "chrome-devtools": {
      "type": "local",
      "command": ["npx", "-y", "chrome-devtools-mcp@latest", 
                  "--user-data-dir=$HOME/.chrome-dev-profile", 
                  "--headless=false"],
      "enabled": false
    }
  }
}
```

### nvim-DAP

Configure nvim-DAP to connect to the remote debugging port:

```lua
dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = {vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js"}
}

dap.configurations.typescript = {
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}"
  }
}
```

## Security

**⚠️ Important:**

- Remote debugging port allows local applications to control Chrome
- Use only for development
- Don't browse sensitive sites in this instance
- Profile is persistent - reset with `chrome-dev --reset` if needed

## Platform Support

- ✅ macOS (Google Chrome)
- ✅ Linux (Google Chrome, Chromium)
- ❌ Windows (not supported by this script - use manual launch)
