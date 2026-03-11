# OpenCode Agent Guidelines

## Reading Files from Other Branches or PRs

Never use `gh api` + `base64 -d` pipelines to read files from remote branches. Use a worktree instead:

1. Create a worktree for the branch: `use-git-worktree` with `action: create`
2. Read files directly with the `read` tool from the worktree directory
3. Remove the worktree when done: `use-git-worktree` with `action: remove`

This applies even for quick one-off lookups. The `gh api` approach is fragile, pipes through shell decoding, and requires unnecessary permissions.

## Browser Testing & Debugging

When working on frontend code or investigating browser-specific issues, use the Chrome DevTools MCP server to inspect and analyze the browser state.

### When to Use Chrome DevTools

- **Verify changes work as expected** - After making frontend code changes, analyze the current page state
- **Debug layout/styling issues** - Inspect DOM structure and CSS to identify visual problems
- **Check for console errors** - Find JavaScript errors, warnings, or network failures
- **Debug network requests** - Inspect API calls, check for CORS issues, or failed resource loading
- **Take snapshots** - Capture current DOM state or screenshots

### Development Environment

- **Vite dev server**: http://localhost:5173
- **Chrome instance**: Manually launched via `chrome-dev` command
- **User controls navigation**: OpenCode observes the page you have open, it doesn't navigate

### Workflow

Chrome DevTools MCP connects to your running Chrome instance. You control where Chrome navigates, OpenCode just reads DevTools data.

**Before using chrome-devtools:**
1. Launch Chrome: `chrome-dev`
2. Navigate to the page you want to inspect
3. Open DevTools if you want to see what OpenCode sees (optional)

**In OpenCode:**
- OpenCode attaches to your running Chrome
- It reads console logs, network requests, DOM state, etc.
- It does NOT navigate or control the browser
- You stay in full control

### Context Management

**To keep context small:**
- Refresh the page (Cmd+R) before asking OpenCode to check console/network
- This clears Chrome's internal buffers
- Be specific: Ask for errors only, not all console messages
- Performance tracing is disabled to save context

**Data retention:**
- Console messages: Cleared on page refresh
- Network requests: Cleared on page refresh  
- DOM snapshots: Always fresh (no history)
- Screenshots: Always fresh (no history)

### Usage Pattern

Always include `use chrome-devtools` in your prompt. **Be specific** to minimize context:

**Important: First Query Behavior**
- The FIRST time you use chrome-devtools in an OpenCode session, it may return empty/incomplete data
- This is because the MCP connection is initializing and Chrome is sending buffered events
- **Solution:** If first query returns no logs, immediately ask again - second query will have full data
- Alternatively, start with a simple query like "What page is currently open? use chrome-devtools" to warm up the connection

**Good (specific):**
```
Show me console errors only. use chrome-devtools
```

**Avoid (too broad):**
```
Show me everything in the console. use chrome-devtools
```

**Good examples:**
```
Check console for errors related to "fetch". use chrome-devtools
```

```
List failed network requests (status 4xx or 5xx). use chrome-devtools
```

```
Take a screenshot of the current page. use chrome-devtools
```

```
Show me the DOM structure of the navigation element. use chrome-devtools
```

**Warm-up pattern (optional):**
```
First query: "What's the current page URL? use chrome-devtools"
Second query: "Show console errors. use chrome-devtools" ← Full data available
```

### What OpenCode Can See

- Console messages (errors, warnings, logs)
- Network requests and responses
- DOM snapshots
- Current page URL and title
- Screenshots

### What OpenCode Cannot Do

- Navigate to different URLs (you control navigation)
- Click buttons or interact with the page (you control interactions)
- Close or open tabs (you control tabs)
- Record performance traces (disabled to save context)

### Available Capabilities

- Console log inspection (debugging category)
- Network request analysis (network category)
- DOM and CSS inspection (debugging category)
- Screenshot capture (debugging category)
- JavaScript execution for reading state (debugging category)
