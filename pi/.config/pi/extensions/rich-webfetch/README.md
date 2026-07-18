# rich-webfetch

Headless-browser web fetcher for Pi. Extracts readable text from JavaScript-rendered pages.

## Why

The built-in `webfetch` tool fetches raw HTML and parses it with regex. This fails for React, Vue, and other SPA frameworks that render content in the browser.

`rich_webfetch` launches a Chromium browser, waits for the page to render, then extracts the visible text.

## Install

```bash
cd ~/.config/pi/extensions/rich-webfetch
npm install
npx playwright install chromium
```

## Usage

Ask Pi to fetch a JS-rendered page:

```
Fetch http://localhost:8448 with rich_webfetch
```

## Parameters

- `url` — URL to fetch (required)
- `maxChars` — Maximum characters to return (default 8000)
- `waitUntil` — When to consider navigation complete: `load`, `domcontentloaded`, `networkidle` (default `networkidle`)
- `selector` — Optional CSS selector to extract text from a specific element
- `includeHtml` — Return rendered HTML instead of plain text

## Notes

- First call in a session is slower because the browser must start.
- The browser is reused across calls and closed when the Pi session ends.
