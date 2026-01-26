# Chrome DevTools MCP - First Query Issue

## The Problem

When you first use `chrome-devtools` in an OpenCode session, the initial query may return empty or incomplete data.

## Why It Happens

1. **MCP Connection Initialization**
   - OpenCode loads the MCP server
   - MCP connects to Chrome via WebSocket
   - Chrome DevTools Protocol domains are enabled (Console, Network, etc.)
   
2. **Event Buffering**
   - Chrome needs time to send buffered console/network events
   - First query happens during this initialization
   - Events arrive AFTER the query completes

3. **Second Query Works**
   - Connection is established
   - Events are buffered
   - Full data is available

## Solutions

### Option 1: Ask Twice (Recommended)

If your first query returns empty data, simply ask again immediately:

```
Query 1: "Show console errors. use chrome-devtools"
→ Returns: "No console messages found"

Query 2: "Show console errors. use chrome-devtools"
→ Returns: Full list of errors ✅
```

### Option 2: Warm-Up Query

Start your session with a simple query to initialize the connection:

```
Query 1 (warm-up): "What page is currently open? use chrome-devtools"
→ Initializes connection

Query 2 (real): "Show console errors. use chrome-devtools"
→ Full data available ✅
```

### Option 3: Combined Query

Ask OpenCode to check multiple times in one prompt:

```
"Check the console for errors. If no data is returned, 
check again immediately. use chrome-devtools"
```

OpenCode will query twice automatically if needed.

## Understanding the Timing

```
Timeline:
┌─────────────────────────────────────────────────────┐
│ You: "Show console errors. use chrome-devtools"     │
├─────────────────────────────────────────────────────┤
│ [0ms]   OpenCode starts MCP server                  │
│ [100ms] MCP connects to Chrome                      │
│ [200ms] MCP enables Console domain                  │
│ [250ms] MCP queries console → Returns empty         │ ← First query
│ [300ms] Chrome sends buffered events → Data arrives │
├─────────────────────────────────────────────────────┤
│ You: "Show console errors again. use chrome-devtools"│
│ [0ms]   MCP already connected                       │
│ [10ms]  MCP queries console → Returns full data ✅  │ ← Second query
└─────────────────────────────────────────────────────┘
```

## Technical Details

### What Gets Buffered During Init

- **Console messages**: Events since page load
- **Network requests**: Events since page load
- **DOM changes**: Current state only (not buffered)

### When Buffering Works

```javascript
// Chrome's behavior:
1. Page loads
2. Console messages accumulate in Chrome's buffer
3. MCP connects
4. Chrome sends: "Here are all messages since page load"
5. MCP receives and caches them

// Timing issue:
Query arrives at step 3 (before buffered data)
Second query works (step 5, data cached)
```

## Best Practices

### Daily Workflow

```bash
# Method 1: Accept the double-query
1. Ask question
2. If empty, ask again immediately
3. Continue working

# Method 2: Warm up connection
1. Start session: "What page is open? use chrome-devtools"
2. Then ask real questions
3. Connection stays warm for session
```

### Long OpenCode Sessions

If you've been coding for a while without using chrome-devtools:

```
The MCP connection may time out or close.
First query after idle time = initialization again.
Solution: Just ask twice, or use warm-up query.
```

## Future Improvements

Possible solutions being explored:

1. **Auto-retry in MCP**: Server could wait for buffered data
2. **OpenCode-level retry**: OpenCode could automatically retry empty responses
3. **Pre-warm connection**: Start MCP connection on OpenCode startup

For now, the "ask twice" pattern is the simplest workaround.

## Summary

✅ **Normal behavior**: First query may be empty
✅ **Easy fix**: Ask the same question again immediately
✅ **Alternative**: Start with warm-up query
✅ **Not a bug**: Just initialization timing

Don't worry if you see "No console messages" on first try - just ask again! 🎯
