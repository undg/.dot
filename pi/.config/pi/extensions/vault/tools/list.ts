import { Type } from "typebox";
import { readdirSync, statSync, existsSync } from "node:fs";
import { join, relative } from "node:path";
import { resolveVaults } from "../config.js";
import { expandTilde } from "../utils/paths.js";

export const listParams = Type.Object({
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: 'Vault name, index, or "both"' })),
	folder: Type.Optional(Type.String({ description: "Subfolder path" })),
	pattern: Type.Optional(Type.String({ description: "Glob pattern (e.g., *.md, **/*)" })),
});

interface NoteEntry {
	path: string;
	size: number;
	modified: string;
	vault: string;
}

export async function execute(params: {
	vault?: string | number;
	folder?: string;
	pattern?: string;
}): Promise<NoteEntry[]> {
	const vaults = resolveVaults(params.vault);
	const results: NoteEntry[] = [];

	for (const v of vaults) {
		const vaultBase = expandTilde(v.path);
		let searchDir = vaultBase;
		if (params.folder) {
			searchDir = join(vaultBase, params.folder);
		}

		if (!existsSync(searchDir)) continue;

		walkDir(searchDir, vaultBase, v.name, params.pattern, results);
	}

	return results;
}

function walkDir(
	dir: string,
	basePath: string,
	vaultName: string,
	pattern: string | undefined,
	results: NoteEntry[],
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
			walkDir(fullPath, basePath, vaultName, pattern, results);
		} else if (entry.endsWith(".md")) {
			const relPath = relative(basePath, fullPath);

			if (pattern) {
				// Simple glob matching
				if (!matchSimpleGlob(relPath, pattern)) continue;
			}

			results.push({
				path: relPath,
				size: stat.size,
				modified: stat.mtime.toISOString(),
				vault: vaultName,
			});
		}
	}
}

function matchSimpleGlob(filepath: string, pattern: string): boolean {
	// Convert simple glob to regex
	const regex = new RegExp(
		"^" +
		pattern
			.replace(/\./g, "\\.")
			.replace(/\*\*/g, "<<<GLOBSTAR>>>")
			.replace(/\*/g, "[^/]*")
			.replace(/<<<GLOBSTAR>>>/g, ".*")
			.replace(/\?/g, "[^/]") +
		"$"
	);
	return regex.test(filepath);
}
