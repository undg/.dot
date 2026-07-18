import type { BraveResult } from "./cache.ts";

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

export async function fetchBrave(
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
