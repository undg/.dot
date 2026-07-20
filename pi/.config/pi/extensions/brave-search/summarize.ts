import type { Model } from "@earendil-works/pi-ai";
import { complete } from "@earendil-works/pi-ai/compat";
import type { ModelRegistry } from "@earendil-works/pi-coding-agent";
import type { BraveResult } from "./cache.ts";

export interface ResolvedSummaryModel {
	model: Model;
	auth: { ok: true; apiKey: string; headers?: Record<string, string>; env?: Record<string, string> };
}

export interface SummaryModelRef {
	provider: string;
	modelId: string;
}

export function parseModelRef(ref: string): SummaryModelRef | undefined {
	const slash = ref.indexOf("/");
	if (slash <= 0 || slash === ref.length - 1) return undefined;
	return {
		provider: ref.slice(0, slash),
		modelId: ref.slice(slash + 1),
	};
}

/** Normalize summaryModel config into a string array. */
export function normalizeSummaryModelRefs(raw: string | string[] | undefined): string[] {
	if (!raw) return [];
	return Array.isArray(raw) ? raw : [raw];
}

/**
 * Quick sync check: does a model ref point to a registered model with auth configured?
 * Use this as a cheap pre-filter before the async getApiKeyAndHeaders() call.
 */
export function isModelAvailableSync(ref: string, registry: ModelRegistry): boolean {
	const parsed = parseModelRef(ref);
	if (!parsed) return false;
	const model = registry.find(parsed.provider, parsed.modelId);
	if (!model) return false;
	return registry.hasConfiguredAuth(model);
}

/**
 * Walk the model ref fallback chain and resolve the first available model.
 * Uses a sync pre-check (find + hasConfiguredAuth) to skip models that can't work,
 * then falls through to the async key resolution.
 */
export async function resolveSummaryModel(
	refs: string[],
	registry: ModelRegistry,
): Promise<ResolvedSummaryModel | undefined> {
	for (const ref of refs) {
		if (!isModelAvailableSync(ref, registry)) continue;
		const parsed = parseModelRef(ref)!;
		const model = registry.find(parsed.provider, parsed.modelId)!;
		const auth = await registry.getApiKeyAndHeaders(model);
		if (auth.ok && auth.apiKey) return { model, auth };
	}
	return undefined;
}

function buildSummaryPrompt(query: string, results: BraveResult[]): string {
	const lines = [
		`You are a research assistant. Summarize the following web search results for the query "${query}".`,
		"",
		"Return a concise answer in 2-5 bullet points. Include the source URL in parentheses after each bullet. Then add a 'Sources:' section listing the URLs you used.",
		"",
		"Search results:",
	];
	for (let i = 0; i < results.length; i++) {
		const r = results[i];
		lines.push(`${i + 1}. ${r.title}`);
		lines.push(`   URL: ${r.url}`);
		lines.push(`   ${r.description}`);
		lines.push("");
	}
	return lines.join("\n");
}

export async function summarizeResults(
	query: string,
	results: BraveResult[],
	resolved: ResolvedSummaryModel,
	maxTokens: number | undefined,
	signal: AbortSignal | undefined,
): Promise<string | undefined> {
	if (results.length === 0) return undefined;

	const response = await complete(
		resolved.model,
		{
			messages: [
				{
					role: "user" as const,
					content: [{ type: "text" as const, text: buildSummaryPrompt(query, results) }],
					timestamp: Date.now(),
				},
			],
		},
		{
			apiKey: resolved.auth.apiKey,
			headers: resolved.auth.headers,
			env: resolved.auth.env,
			signal,
			maxTokens: maxTokens ?? 500,
			temperature: 0.3,
		},
	);

	const text = response.content
		.filter((c): c is { type: "text"; text: string } => c.type === "text")
		.map((c) => c.text)
		.join("\n")
		.trim();

	return text || undefined;
}
