import { Type } from "typebox";
import { execFileSync } from "node:child_process";
import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { resolveVaults } from "../config.js";
import { expandTilde } from "../utils/paths.js";

export const searchParams = Type.Object({
	query: Type.String({ description: "Search text (ripgrep pattern)" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: 'Vault name, index, or "both"' })),
	tag: Type.Optional(Type.String({ description: "Filter by tag" })),
	date_from: Type.Optional(Type.String({ description: "ISO date YYYY-MM-DD" })),
	date_to: Type.Optional(Type.String({ description: "ISO date YYYY-MM-DD" })),
	folder: Type.Optional(Type.String({ description: "Limit to subfolder" })),
	backlinks: Type.Optional(Type.Boolean({ description: "Include backlinked notes", default: false })),
});

interface SearchResult {
	path: string;
	line: number;
	match: string;
	context: string;
	vault: string;
}

export async function execute(params: {
	query: string;
	vault?: string | number;
	tag?: string;
	date_from?: string;
	date_to?: string;
	folder?: string;
	backlinks?: boolean;
}): Promise<SearchResult[]> {
	const results: SearchResult[] = [];
	const vaults = resolveVaults(params.vault);

	for (const v of vaults) {
		const vaultBase = expandTilde(v.path);

		let searchDir = vaultBase;
		if (params.folder) {
			searchDir = join(vaultBase, params.folder);
			if (!existsSync(searchDir)) continue;
		}

		// Run ripgrep
		const rgArgs = [
			"--line-number", "--no-heading", "--color=never",
			"--glob", "*.md",
			"--", params.query, searchDir,
		];

		try {
			const stdout = execFileSync("rg", rgArgs, {
				encoding: "utf8",
				stdio: "pipe",
				maxBuffer: 10 * 1024 * 1024,
				timeout: 30000,
			});

			for (const line of stdout.trim().split("\n")) {
				if (!line) continue;
				const colonIdx = line.indexOf(":");
				if (colonIdx < 0) continue;

				const pathPart = line.slice(0, colonIdx);
				const rest = line.slice(colonIdx + 1);

				const secondColon = rest.indexOf(":");
				if (secondColon < 0) continue;

				const lineNum = parseInt(rest.slice(0, secondColon), 10);
				const match = rest.slice(secondColon + 1);

				let relPath = pathPart;
				if (relPath.startsWith(vaultBase + "/")) {
					relPath = relPath.slice(vaultBase.length + 1);
				} else if (relPath.startsWith(vaultBase)) {
					relPath = relPath.slice(vaultBase.length);
				}

				if (params.tag && !noteHasTag(vaultBase, relPath, params.tag)) continue;
				if ((params.date_from || params.date_to) && !noteInDateRange(relPath, params.date_from, params.date_to)) continue;

				results.push({ path: relPath, line: lineNum, match, context: "", vault: v.name });
			}
		} catch {
			// rg returns non-zero when no matches — ignore
		}

		// Backlinks
		if (params.backlinks) {
			const matchTargets = new Set<string>();
			for (const r of results) {
				matchTargets.add(r.path.replace(/\.md$/i, ""));
			}

			for (const target of matchTargets) {
				const blArgs = [
					"--line-number", "--no-heading", "--color=never",
					"--glob", "*.md",
					"--", `\\[\\[${target}(\\||#|\\]\\])`, vaultBase,
				];

				try {
					const bl = execFileSync("rg", blArgs, {
						encoding: "utf8",
						stdio: "pipe",
						maxBuffer: 10 * 1024 * 1024,
						timeout: 30000,
					});

					for (const l of bl.trim().split("\n")) {
						if (!l) continue;
						const ci = l.indexOf(":");
						if (ci < 0) continue;
						const pp = l.slice(0, ci);
						let rp = pp;
						if (rp.startsWith(vaultBase + "/")) rp = rp.slice(vaultBase.length + 1);
						else if (rp.startsWith(vaultBase)) rp = rp.slice(vaultBase.length);

						if (results.some(r => r.path === rp)) continue;

						const rest2 = l.slice(ci + 1);
						const sc = rest2.indexOf(":");
						results.push({
							path: rp,
							line: sc > 0 ? parseInt(rest2.slice(0, sc), 10) : 0,
							match: sc > 0 ? rest2.slice(sc + 1) : "",
							context: `backlinks to [[${target}]]`,
							vault: v.name,
						});
					}
				} catch {
					// no backlinks
				}
			}
		}
	}

	return results;
}

function noteHasTag(vaultBase: string, relPath: string, tag: string): boolean {
	const fullPath = join(vaultBase, relPath);
	if (!existsSync(fullPath)) return false;

	const content = readFileSync(fullPath, "utf8");

	// Check frontmatter tags
	const fmMatch = content.match(/^---\n([\s\S]*?)\n---/);
	if (fmMatch) {
		const fm = fmMatch[1];
		const tagItems = fm.match(/^\s+-\s+(.+)$/gm);
		if (tagItems) {
			for (const item of tagItems) {
				const t = item.replace(/^\s+-\s+/, "").trim();
				if (tagMatches(t, tag)) return true;
			}
		}
	}

	// Check inline #tags
	const inlineTags = content.match(/#[\w/-]+/g);
	if (inlineTags) {
		for (const t of inlineTags) {
			if (tagMatches(t.slice(1), tag)) return true;
		}
	}

	return false;
}

function tagMatches(noteTag: string, searchTag: string): boolean {
	if (noteTag === searchTag) return true;
	if (noteTag.startsWith(searchTag + "/")) return true;
	return false;
}

function noteInDateRange(relPath: string, from?: string, to?: string): boolean {
	const dateMatch = relPath.match(/(\d{4}-\d{2}-\d{2})/);
	if (!dateMatch) return false;
	const noteDate = dateMatch[1];
	if (from && noteDate < from) return false;
	if (to && noteDate > to) return false;
	return true;
}
