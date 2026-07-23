import { Type } from "typebox";
import { existsSync } from "node:fs";
import { resolveVault } from "../config.js";
import { resolveVaultPath, atomicWrite } from "../utils/paths.js";
import { autoCommit } from "../utils/git.js";
import { isDailyPath, dailyFrontmatter } from "../utils/daily.js";
import { serializeFrontmatter } from "../utils/frontmatter.js";

export const newParams = Type.Object({
	path: Type.String({ description: "Relative path from vault root (kebab-case enforced, .md extension)" }),
	tags: Type.Optional(Type.Union([Type.String(), Type.Array(Type.String())], { description: "Tags (comma-separated or array)" })),
	content: Type.Optional(Type.String({ description: "Markdown body (after frontmatter)" })),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
});

export async function execute(params: {
	path: string;
	tags?: string | string[];
	content?: string;
	vault?: string | number;
}): Promise<{ path: string; frontmatter: Record<string, unknown> }> {
	const v = resolveVault(params.vault);
	const fullPath = resolveVaultPath(v.path, params.path);

	// Validate kebab-case
	const filename = params.path.split("/").pop() || "";
	const nameNoExt = filename.replace(/\.md$/i, "");
	if (!/^[a-z0-9]+(-[a-z0-9]+)*$/.test(nameNoExt)) {
		throw new Error(`Filename must be kebab-case: "${filename}". Got: "${nameNoExt}"`);
	}

	// Fail if already exists
	if (existsSync(fullPath)) {
		throw new Error(`Note already exists: ${params.path}. Use vault_save to update.`);
	}

	// Normalize tags
	let tagList: string[] = [];
	if (typeof params.tags === "string") {
		tagList = params.tags.split(",").map(t => t.trim()).filter(Boolean);
	} else if (Array.isArray(params.tags)) {
		tagList = params.tags;
	}

	// Build frontmatter
	let frontmatter: Record<string, unknown>;
	if (isDailyPath(params.path)) {
		frontmatter = dailyFrontmatter(params.path);
	} else {
		frontmatter = {
			id: nameNoExt,
			aliases: [],
			tags: tagList,
		};
	}

	const body = params.content || "";
	const fullContent = serializeFrontmatter(frontmatter as any, body);

	atomicWrite(fullPath, fullContent);
	autoCommit(v, params.path);

	return { path: params.path, frontmatter };
}
