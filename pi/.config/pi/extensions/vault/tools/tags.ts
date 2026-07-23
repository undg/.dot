import { Type } from "typebox";
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, relative } from "node:path";
import { resolveVaults } from "../config.js";
import { expandTilde } from "../utils/paths.js";

export const tagsParams = Type.Object({
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: 'Vault name, index, or "both"' })),
});

interface TagCount {
	tag: string;
	count: number;
}

export async function execute(params: { vault?: string | number }): Promise<TagCount[]> {
	const vaults = resolveVaults(params.vault);
	const tagCounts = new Map<string, number>();

	for (const v of vaults) {
		const vaultBase = expandTilde(v.path);
		countTags(vaultBase, tagCounts);
	}

	const result: TagCount[] = [];
	for (const [tag, count] of tagCounts.entries()) {
		result.push({ tag, count });
	}
	result.sort((a, b) => b.count - a.count);
	return result;
}

function countTags(baseDir: string, counts: Map<string, number>): void {
	if (!existsSync(baseDir)) return;

	walkAndCount(baseDir, baseDir, counts);
}

function walkAndCount(dir: string, basePath: string, counts: Map<string, number>): void {
	let entries: string[];
	try {
		entries = readdirSync(dir);
	} catch {
		return;
	}

	for (const entry of entries) {
		if (entry.startsWith(".")) continue;

		const fullPath = join(dir, entry);
		let stat;
		try {
			stat = statSync(fullPath);
		} catch {
			continue;
		}

		if (stat.isDirectory()) {
			walkAndCount(fullPath, basePath, counts);
		} else if (entry.endsWith(".md")) {
			countTagsInFile(fullPath, counts);
		}
	}
}

function countTagsInFile(filePath: string, counts: Map<string, number>): void {
	let content: string;
	try {
		content = readFileSync(filePath, "utf8");
	} catch {
		return;
	}

	const seen = new Set<string>();

	// Frontmatter tags
	const fmMatch = content.match(/^---\n([\s\S]*?)\n---/);
	if (fmMatch) {
		const fm = fmMatch[1];
		const tagItems = fm.match(/^\s+-\s+(.+)$/gm);
		if (tagItems) {
			for (const item of tagItems) {
				const tag = item.replace(/^\s+-\s+/, "").trim();
				if (tag && !seen.has(tag)) {
					seen.add(tag);
				}
			}
		}
	}

	// Inline #tags
	const inlineTags = content.match(/#[\w/-]+/g);
	if (inlineTags) {
		for (const t of inlineTags) {
			const tag = t.slice(1);
			if (tag && !seen.has(tag)) {
				seen.add(tag);
			}
		}
	}

	for (const tag of seen) {
		counts.set(tag, (counts.get(tag) || 0) + 1);
	}
}
