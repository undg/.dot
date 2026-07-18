export interface BraveResult {
	title: string;
	url: string;
	description: string;
}

export interface CachedSearch {
	query: string;
	results: BraveResult[];
	fetchedAt: number;
}

export interface SearchCache {
	get(query: string): CachedSearch | undefined;
	set(query: string, entry: CachedSearch): void;
	snapshot(): Record<string, CachedSearch>;
}

export function normalizeQuery(query: string): string {
	return query.trim().toLowerCase().replace(/\s+/g, " ");
}

class MemorySearchCache implements SearchCache {
	private map = new Map<string, CachedSearch>();

	get(query: string): CachedSearch | undefined {
		return this.map.get(normalizeQuery(query));
	}

	set(query: string, entry: CachedSearch): void {
		this.map.set(normalizeQuery(query), entry);
	}

	snapshot(): Record<string, CachedSearch> {
		return Object.fromEntries(this.map);
	}
}

export function createSearchCache(): SearchCache {
	return new MemorySearchCache();
}
