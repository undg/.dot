# Brave Search Extension

Brave Search API integration for pi. Adds a `brave_search` tool with optional AI summarization.

## Setup

### API Key

Two options:

1. **Environment variable**: `export BRAVE_API_KEY="BSA..."`
2. **Config file**: `extensions/brave-search/config.json`

The config file supports dynamic key resolution via prefixes:

| Prefix | Example | Behavior |
|--------|---------|----------|
| `!` | `"!$HOME/.config/pi/get-api-key brave-api"` | Runs a shell command |
| `$` | `"$BRAVE_API_KEY"` | Reads an env variable |
| plain | `"BSA..."` | Uses the literal string |

### Config File

```json
{
  "apiKey": "!$HOME/.config/pi/get-api-key brave-api",
  "summaryModel": "opencode-go/mimo-v2.5",
  "alwaysSummarize": false,
  "maxSummaryTokens": 500
}
```

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `apiKey` | `string` | — | Brave API key (supports `!` and `$` prefixes) |
| `summaryModel` | `string \| string[]` | — | Model for summarization. Array = fallback chain |
| `alwaysSummarize` | `boolean` | `false` | Summarize every search, ignore the `summarize` parameter |
| `maxSummaryTokens` | `number` | `500` | Max tokens for the summary response |

## Summarization

When `summarize=true` (or `alwaysSummarize` is set), results are sent to a cheap model for a 2-5 bullet summary with source links.

### Model Format

`"provider/model-id"` — e.g. `"opencode-go/mimo-v2.5"`, `"mistral/mistral-small"`

### Fallback Chain

`summaryModel` accepts an array. Models are tried in order. The first one with a working API key wins:

```json
{
  "summaryModel": ["mistral/mistral-small", "opencode-go/deepseek-v4-flash"]
}
```

**How fallback works:**

1. **Sync pre-check** — `find()` + `hasConfiguredAuth()` skips models not in the registry or with no auth configured (no I/O, instant)
2. **Async auth** — `getApiKeyAndHeaders()` resolves the actual key. If it fails, next model is tried

No error is shown if all models fail — results fall back to plain text rendering.

## Search Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `query` | `string` | — | Search query |
| `count` | `number` | `20` | Results to fetch (max 20) |
| `show` | `number` | `5` | Results to display (when not summarizing) |
| `offset` | `number` | `0` | Pagination offset into cached results |
| `freshness` | `"pd" \| "pw" \| "pm" \| "py"` | — | Filter by recency |
| `summarize` | `boolean` | `false` | Run AI summarization |

## Caching

Identical queries are cached in-memory for the session lifetime. Use `offset` to page through cached results without additional API calls.
