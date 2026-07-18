import { complete } from "@earendil-works/pi-ai/compat";
import type { ExtensionContext } from "@earendil-works/pi-coding-agent";
import type { BraveResult } from "./cache.ts";

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
	modelRef: string,
	maxTokens: number | undefined,
	ctx: ExtensionContext,
	signal: AbortSignal | undefined,
): Promise<string | undefined> {
	if (results.length === 0) return undefined;

	const ref = parseModelRef(modelRef);
	if (!ref) return undefined;

	const model = ctx.modelRegistry.find(ref.provider, ref.modelId);
	if (!model) return undefined;

	const auth = await ctx.modelRegistry.getApiKeyAndHeaders(model);
	if (!auth?.ok || !auth.apiKey) return undefined;

	const response = await complete(
		model,
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
			apiKey: auth.apiKey,
			headers: auth.headers,
			env: auth.env,
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
