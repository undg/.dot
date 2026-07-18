import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const BLOCK_END_TAGS = [
  "h1",
  "h2",
  "h3",
  "h4",
  "h5",
  "h6",
  "p",
  "div",
  "section",
  "article",
  "main",
  "aside",
  "header",
  "footer",
  "nav",
  "figure",
  "figcaption",
  "blockquote",
  "pre",
  "address",
  "hr",
  "li",
  "tr",
  "caption",
  "dd",
  "dt",
];

const BLOCK_START_TAGS = [...BLOCK_END_TAGS, "ul", "ol", "table", "dl"];

const REMOVABLE_TAGS = [
  "script",
  "style",
  "noscript",
  "iframe",
  "svg",
  "canvas",
  "template",
  "audio",
  "video",
  "embed",
  "object",
  "head",
  "meta",
  "link",
];

const COMMON_ENTITIES: Record<string, string> = {
  amp: "&",
  lt: "<",
  gt: ">",
  quot: '"',
  apos: "'",
  nbsp: " ",
  ndash: "–",
  mdash: "—",
  hellip: "…",
  copy: "©",
  reg: "®",
  trade: "™",
  euro: "€",
  pound: "£",
  yen: "¥",
  laquo: "«",
  raquo: "»",
  ldquo: '"',
  rdquo: '"',
  lsquo: "'",
  rsquo: "'",
};

function decodeHtmlEntities(text: string): string {
  return text.replace(/&([^;\s]+);/g, (match, entity) => {
    const decoded = COMMON_ENTITIES[entity];
    if (decoded !== undefined) return decoded;

    if (entity.startsWith("#x") || entity.startsWith("#X")) {
      const code = parseInt(entity.slice(2), 16);
      if (!Number.isNaN(code)) return String.fromCodePoint(code);
    }

    if (entity.startsWith("#")) {
      const code = parseInt(entity.slice(1), 10);
      if (!Number.isNaN(code)) return String.fromCodePoint(code);
    }

    return match;
  });
}

function htmlToText(html: string): string {
  let text = html;

  for (const tag of REMOVABLE_TAGS) {
    text = text.replace(
      new RegExp(`<${tag}\\b[^>]*>[\\s\\S]*?<\\/${tag}>`, "gi"),
      " ",
    );
    text = text.replace(new RegExp(`<${tag}\\b[^>]*\\/?>`, "gi"), " ");
  }

  for (const tag of BLOCK_START_TAGS) {
    text = text.replace(new RegExp(`<${tag}\\b[^>]*>`, "gi"), "\n");
  }

  for (const tag of BLOCK_END_TAGS) {
    text = text.replace(new RegExp(`<\\/${tag}\\b[^>]*>`, "gi"), "\n");
  }

  text = text.replace(/<br\b[^>]*\/?>/gi, "\n");
  text = text.replace(/<li\b[^>]*>/gi, "\n• ");
  text = text.replace(/<td\b[^>]*>/gi, " | ");
  text = text.replace(/<th\b[^>]*>/gi, " | ");
  text = text.replace(/<[^>]+>/g, "");
  text = decodeHtmlEntities(text);
  text = text
    .split("\n")
    .map((line) => line.replace(/[\t ]+/g, " ").trim())
    .join("\n");
  text = text.replace(/\n{3,}/g, "\n\n");

  return text.trim();
}

function truncate(text: string, maxChars: number): string {
  if (text.length <= maxChars) return text;
  const cut = text.lastIndexOf(" ", maxChars - 12);
  const end = cut > maxChars * 0.8 ? cut : maxChars - 12;
  return text.slice(0, end) + "\n\n... [truncated]";
}

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "webfetch",
    label: "Web Fetch",
    description:
      "Fetch a public URL and return its page content as readable plain text.",
    promptSnippet:
      "Fetch a public URL and convert the HTML page to plain text.",
    promptGuidelines: [
      "Use webfetch when the user gives a URL and wants its content summarized or referenced.",
      "Use webfetch only for public URLs that do not require authentication.",
    ],
    parameters: Type.Object({
      url: Type.String({
        description: "Public URL to fetch, e.g. https://example.com/article",
      }),
      maxChars: Type.Optional(
        Type.Number({
          description: "Maximum characters to return. Defaults to 8000.",
          default: 8000,
        }),
      ),
    }),

    async execute(_toolCallId, params, signal, _onUpdate, _ctx) {
      const maxChars = params.maxChars ?? 8000;

      if (
        !params.url.startsWith("http://") &&
        !params.url.startsWith("https://")
      ) {
        throw new Error(
          `Invalid URL: ${params.url} (must start with http:// or https://)`,
        );
      }

      const response = await fetch(params.url, {
        signal,
        redirect: "follow",
        headers: {
          "User-Agent": "Mozilla/5.0 (compatible; pi-webfetch/1.0)",
          Accept:
            "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      const contentType = response.headers.get("content-type") ?? "";
      if (
        !contentType.includes("text/html") &&
        !contentType.includes("application/xhtml+xml")
      ) {
        const body = await response.text();
        return {
          content: [{ type: "text", text: truncate(body, maxChars) }],
          details: { contentType },
        };
      }

      const html = await response.text();
      const text = htmlToText(html);

      return {
        content: [{ type: "text", text: truncate(text, maxChars) }],
        details: { url: params.url, chars: text.length },
      };
    },
  });
}
