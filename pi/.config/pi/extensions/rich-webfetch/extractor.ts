import type { Page } from "playwright";

export interface ExtractOptions {
  selector?: string;
  includeHtml?: boolean;
  maxChars: number;
}

export async function extractFromPage(
  page: Page,
  options: ExtractOptions,
): Promise<string> {
  if (options.includeHtml) {
    const html = await page.content();
    return truncate(html, options.maxChars);
  }

  const raw = options.selector
    ? await page.locator(options.selector).innerText({ timeout: 5000 })
    : await page.evaluate(() => document.body?.innerText ?? "");

  return truncate(normalizeText(raw), options.maxChars);
}

function normalizeText(text: string): string {
  return text
    .split("\n")
    .map((line) => line.replace(/[\t ]+/g, " ").trim())
    .filter((line) => line.length > 0)
    .join("\n")
    .replace(/\n{3,}/g, "\n\n");
}

function truncate(text: string, maxChars: number): string {
  if (text.length <= maxChars) return text;
  const cut = text.lastIndexOf(" ", maxChars - 12);
  const end = cut > maxChars * 0.8 ? cut : maxChars - 12;
  return text.slice(0, end) + "\n\n... [truncated]";
}
