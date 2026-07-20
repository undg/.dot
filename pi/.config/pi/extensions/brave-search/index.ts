import { StringEnum } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { createSearchCache, normalizeQuery, type BraveResult, type CachedSearch, type SearchCache } from "./cache.ts";
import { loadConfig, resolveApiKey, setupErrorText } from "./config.ts";
import { fetchBrave } from "./search.ts";
import { normalizeSummaryModelRefs, resolveSummaryModel, summarizeResults } from "./summarize.ts";

const CUSTOM_TYPE = "brave-search-cache";
const FRESHNESS_OPTIONS = ["pd", "pw", "pm", "py"] as const;

const cache: SearchCache = createSearchCache();

function renderRawResults(query: string, results: BraveResult[], offset: number, show: number): string {
	const slice = results.slice(offset, offset + show);
	if (slice.length === 0) {
		return `No results to show for query: ${query}`;
	}
	const lines = slice.map(
		(r, i) => `${offset + i + 1}. ${r.title}\n   ${r.url}\n   ${r.description}`,
	);
	return lines.join("\n\n");
}

function renderFooter(offset: number, show: number, total: number, cacheHit: boolean, summary?: string, summaryModel?: string): string {
	if (summary) {
		const modelSuffix = summaryModel ? ` via ${summaryModel}` : "";
		return `Summarized ${total} Brave Search results${modelSuffix}.`;
	}
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
		description: "Search the web using the Brave Search API. Optional cheap-model summary reduces context cost.",
		promptSnippet: "Search the web for current information, docs, error messages, and references.",
		promptGuidelines: [
			"Use brave_search to find current information, docs, and error messages on the web.",
			"Use summarize=true when you only need a concise answer with source links.",
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
					description: "How many results to render to the LLM when not summarizing.",
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
			summarize: Type.Optional(
				Type.Boolean({
					description: "Summarize results with a cheap model before returning.",
					default: false,
				}),
			),
		}),

		async execute(_toolCallId, params, signal, _onUpdate, ctx: ExtensionContext) {
			const query = normalizeQuery(params.query);
			const count = Math.min(20, Math.max(1, Math.floor(params.count ?? 20)));
			const show = Math.max(1, Math.floor(params.show ?? 5));
			const offset = Math.max(0, Math.floor(params.offset ?? 0));
			const config = loadConfig();
			const summarize = params.summarize ?? config?.alwaysSummarize ?? false;

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
			let summary: string | undefined;
			let text: string;

			let summaryModel: string | undefined;

			if (summarize && config?.summaryModel && total > 0) {
				const refs = normalizeSummaryModelRefs(config.summaryModel);
				const resolved = await resolveSummaryModel(refs, ctx.modelRegistry);
				if (resolved) {
					summaryModel = `${resolved.model.provider}/${resolved.model.id}`;
					summary = await summarizeResults(
						params.query, results, resolved,
						config.maxSummaryTokens, signal,
					);
				}
				if (summary) {
					text = `**Summarized via ${summaryModel}:**\n\n${summary}`;
				} else {
					// fall back to raw results if summarization failed or no model resolved
					text = renderRawResults(params.query, results, offset, show);
				}
			} else {
				text = renderRawResults(params.query, results, offset, show);
			}

			const footer = renderFooter(offset, show, total, source === "cache", summary, summaryModel);

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
					summarize,
					summaryModel,
					summary,
				},
			};
		},
	});
}
