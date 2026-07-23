import { Type } from "typebox";
import { readFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, relative } from "node:path";
import { resolveVault } from "../config.js";
import { expandTilde } from "../utils/paths.js";
import { extractLinkTargets } from "../utils/wikilinks.js";

export const backlinksParams = Type.Object({
	path: Type.String({ description: "Target note path (relative from vault root)" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
});

interface BacklinkResult {
	path: string;
	line: number;
	context: string;
}

export async function execute(params: { path: string; vault?: string | number }): Promise<BacklinkResult[]> {
	const v = resolveVault(params.vault);
	const vaultBase = expandTilde(v.path);
	const targetName = params.path.replace(/\.md$/i, "").toLowerCase();

	const results: BacklinkResult[] = [];
	searchForWikilinks(vaultBase, vaultBase, targetName, results);
	return results;
}

function searchForWikilinks(
	dir: string,
	basePath: string,
	targetName: string,
	results: BacklinkResult[],
): void {
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
			searchForWikilinks(fullPath, basePath, targetName, results);
		} else if (entry.endsWith(".md")) {
			const relPath = relative(basePath, fullPath);

			// Don't count self-references
			const selfName = relPath.replace(/\.md$/i, "").toLowerCase();
			if (selfName === targetName) continue;

			let content: string;
			try {
				content = readFileSync(fullPath, "utf8");
			} catch {
				continue;
			}

			const targets = extractLinkTargets(content);
			for (const target of targets) {
				if (target.toLowerCase() === targetName) {
					results.push({
						path: relPath,
						line: 0,
						context: `[[${target}]]`,
					});
					break; // one entry per source file
				}
			}
		}
	}
}
