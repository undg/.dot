import { StringEnum } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { Type } from "typebox";
import {
	createSearchCache,
	normalizeQuery,
	type BraveResult,
	type CachedSearch,
	type SearchCache,
} from "./cache.ts";

const ENV_KEY = "BRAVE_API_KEY";
const CUSTOM_TYPE = "brave-search-cache";
const FRESHNESS_OPTIONS = ["pd", "pw", "pm", "py"] as const;

const cache: SearchCache = createSearchCache();
let cachedApiKey: string | undefined | null = null;

interface BraveSearchConfig {
	apiKey: string;
}

function getConfigPath(): string {
	if (process.env.BRAVE_SEARCH_CONFIG) {
		return process.env.BRAVE_SEARCH_CONFIG;
	}
	return join(dirname(fileURLToPath(import.meta.url)), "config.json");
}

function loadConfig(): BraveSearchConfig | undefined {
	const path = getConfigPath();
	if (!existsSync(path)) return undefined;
	try {
		const raw = JSON.parse(readFileSync(path, "utf8")) as unknown;
		if (raw && typeof raw === "object" && "apiKey" in raw && typeof raw.apiKey === "string") {
			return raw as BraveSearchConfig;
		}
	} catch {
		// ignore malformed config
	}
	return undefined;
}

function execPromise(file: string, args: string[]): Promise<{ stdout: string; stderr: string; code: number }> {
	return new Promise((resolve) => {
		execFile(file, args, { encoding: "utf8" }, (error, stdout, stderr) => {
			if (error) {
				resolve({ stdout: stdout as string, stderr: stderr as string, code: (error.code as number) ?? 1 });
			} else {
				resolve({ stdout: stdout as string, stderr: stderr as string, code: 0 });
			}
		});
	});
}

async function resolveConfigValue(value: string): Promise<string | undefined> {
	const trimmed = value.trim();
	if (!trimmed) return undefined;

	if (trimmed.startsWith("!")) {
		const cmd = trimmed.slice(1);
		const { stdout, stderr, code } = await execPromise("sh", ["-c", cmd]);
		if (code !== 0) {
			throw new Error(`Key command failed (exit ${code}): ${stderr.trim() || cmd}`);
		}
		return stdout.trim() || undefined;
	}

	if (trimmed.startsWith("$")) {
		const varName = trimmed.slice(1);
		return process.env[varName]?.trim() || undefined;
	}

	return trimmed;
}

async function resolveApiKey(): Promise<string | undefined> {
	if (cachedApiKey !== null) return cachedApiKey || undefined;

	const envKey = process.env[ENV_KEY];
	if (envKey) {
		cachedApiKey = envKey.trim();
		return cachedApiKey;
	}

	const config = loadConfig();
	if (config) {
		const resolved = await resolveConfigValue(config.apiKey);
		if (resolved) {
			cachedApiKey = resolved;
			return cachedApiKey;
		}
	}

	cachedApiKey = undefined;
	return undefined;
}

function setupErrorText(): string {
	return [
		"Brave Search API key not found.",
		"",
		"To set it up:",
		"1. Export BRAVE_API_KEY environment variable, OR",
		"2. Create a config file at:",
		`   ${getConfigPath()}`,
		"   with contents like:",
		`   { "apiKey": "!$HOME/.config/pi/get-api-key brave-api" }`,
		"",
		"Store the key in your OS keyring first, for example:",
		"   secret-tool store --label='Brave API' provider brave-api",
	].join("\n");
}

interface BraveApiResponse {
	web?: {
		results?: Array<{
			title?: string;
			url?: string;
			description?: string;
		}>;
	};
}

function extractResults(data: unknown): BraveResult[] {
	const payload = data as BraveApiResponse;
	const raw = payload.web?.results;
	if (!Array.isArray(raw)) return [];
	return raw
		.map((item) => ({
			title: String(item.title ?? ""),
			url: String(item.url ?? ""),
			description: String(item.description ?? ""),
		}))
		.filter((r) => r.title || r.url || r.description);
}

async function fetchBrave(
	query: string,
	count: number,
	freshness: string | undefined,
	apiKey: string,
	signal: AbortSignal | undefined,
): Promise<{ results: BraveResult[]; fetchedAt: number }> {
	const url = new URL("https://api.search.brave.com/res/v1/web/search");
	url.searchParams.set("q", query);
	url.searchParams.set("count", String(count));
	url.searchParams.set("text_decorations", "false");
	if (freshness) {
		url.searchParams.set("freshness", freshness);
	}

	const response = await fetch(url.toString(), {
		signal,
		headers: {
			Accept: "application/json",
			"X-Subscription-Token": apiKey,
		},
	});

	if (!response.ok) {
		const body = await response.text();
		const preview = body.slice(0, 500);
		if (response.status === 401 || response.status === 403) {
			throw new Error(
				`Brave Search API returned ${response.status}: bad or missing API key. Check your config.\n\n${preview}`,
			);
		}
		if (response.status === 422) {
			throw new Error(`Brave Search API returned ${response.status}: bad parameters.\n${preview}`);
		}
		if (response.status === 429) {
			throw new Error(`Brave Search API returned ${response.status}: rate limited, retry later.`);
		}
		throw new Error(`Brave Search API returned ${response.status}: ${response.statusText}\n${preview}`);
	}

	let data: unknown;
	try {
		data = await response.json();
	} catch {
		const body = await response.text();
		throw new Error(`Brave Search API returned non-JSON response (${response.status}):\n${body.slice(0, 500)}`);
	}

	return { results: extractResults(data), fetchedAt: Date.now() };
}

function renderFooter(offset: number, show: number, total: number, cacheHit: boolean): string {
	const end = Math.min(offset + show, total);
	if (total === 0) {
		return "No results found.";
	}
	let footer = `Showing ${offset + 1}-${end} of ${total} results.`;
	if (end < total) {
		footer += ` Call brave_search again with same query and offset=${end} to see more`;
		if (cacheHit) {
			footer += " (served from cache, no new API call).";
		} else {
			footer += ".";
		}
	}
	return footer;
}

export default function braveSearchExtension(pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		const entries = ctx.sessionManager.getEntries();
		for (let i = entries.length - 1; i >= 0; i--) {
			const entry = entries[i];
			if (entry.type === "custom" && (entry as unknown as { customType?: string }).customType === CUSTOM_TYPE) {
				const data = (entry as unknown as { data?: Record<string, CachedSearch> }).data;
				if (data && typeof data === "object") {
					for (const [q, value] of Object.entries(data)) {
						if (value && Array.isArray(value.results)) {
							cache.set(q, value);
						}
					}
				}
				break;
			}
		}
	});

	pi.registerTool({
		name: "brave_search",
		label: "Brave Search",
		description: "Search the web using the Brave Search API.",
		promptSnippet: "Search the web for current information, docs, error messages, and references.",
		promptGuidelines: [
			"Use brave_search to find current information, docs, and error messages on the web.",
		],
		parameters: Type.Object({
			query: Type.String({ description: "Search query" }),
			count: Type.Optional(
				Type.Number({
					description: "How many results to fetch from the API (max 20).",
					default: 20,
					maximum: 20,
				}),
			),
			show: Type.Optional(
				Type.Number({
					description: "How many results to render to the LLM.",
					default: 5,
				}),
			),
			offset: Type.Optional(
				Type.Number({
					description: "Page through cached results.",
					default: 0,
					minimum: 0,
				}),
			),
			freshness: Type.Optional(StringEnum(FRESHNESS_OPTIONS)),
		}),

		async execute(_toolCallId, params, signal) {
			const query = normalizeQuery(params.query);
			const count = Math.min(20, Math.max(1, Math.floor(params.count ?? 20)));
			const show = Math.max(1, Math.floor(params.show ?? 5));
			const offset = Math.max(0, Math.floor(params.offset ?? 0));

			const apiKey = await resolveApiKey();
			if (!apiKey) {
				return {
					content: [{ type: "text", text: setupErrorText() }],
					details: { error: "missing_api_key" },
					isError: true,
				};
			}

			const cached = cache.get(query);
			const cacheHit = cached !== undefined && offset + show <= cached.results.length;

			let results: BraveResult[];
			let fetchedAt: number;
			let source: "cache" | "api";

			if (cacheHit && cached) {
				results = cached.results;
				fetchedAt = cached.fetchedAt;
				source = "cache";
			} else {
				const fetched = await fetchBrave(query, count, params.freshness, apiKey, signal);
				results = fetched.results;
				fetchedAt = fetched.fetchedAt;
				source = "api";
				cache.set(query, { query, results, fetchedAt });
				pi.appendEntry(CUSTOM_TYPE, cache.snapshot());
			}

			const total = results.length;
			const slice = results.slice(offset, offset + show);

			let text: string;
			if (slice.length === 0) {
				text = `No results to show for query: ${params.query}`;
			} else {
				const lines = slice.map(
					(r, i) => `${offset + i + 1}. ${r.title}\n   ${r.url}\n   ${r.description}`,
				);
				text = lines.join("\n\n");
			}

			const footer = renderFooter(offset, show, total, source === "cache");

			return {
				content: [{ type: "text", text: `${text}\n\n${footer}` }],
				details: {
					query: params.query,
					normalizedQuery: query,
					count,
					show,
					offset,
					total,
					source,
					fetchedAt,
					freshness: params.freshness,
				},
			};
		},
	});
}
