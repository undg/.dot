import { Type } from "typebox";
import { readFileSync, existsSync } from "node:fs";
import { resolveVault } from "../config.js";
import { resolveVaultPath } from "../utils/paths.js";
import { parseFrontmatter, serializeFrontmatter } from "../utils/frontmatter.js";
import { atomicWrite } from "../utils/paths.js";

export const tagParams = Type.Object({
	action: Type.Union([Type.Literal("add"), Type.Literal("remove")], { description: "add or remove" }),
	tag: Type.String({ description: "Single tag string (e.g., todo, category/subtask)" }),
	path: Type.String({ description: "Relative path from vault root" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
});

export async function execute(params: {
	action: "add" | "remove";
	tag: string;
	path: string;
	vault?: string | number;
}): Promise<{ path: string; action: string; tag: string }> {
	const v = resolveVault(params.vault);
	const fullPath = resolveVaultPath(v.path, params.path);

	if (!existsSync(fullPath)) {
		throw new Error(`Note not found: ${params.path}`);
	}

	const content = readFileSync(fullPath, "utf8");
	const { frontmatter, body } = parseFrontmatter(content);

	// Ensure tags array exists
	let tags: string[] = Array.isArray(frontmatter.tags) ? frontmatter.tags : [];

	if (params.action === "add") {
		if (!tags.includes(params.tag)) {
			tags.push(params.tag);
		}
	} else {
		tags = tags.filter(t => t !== params.tag);
	}

	const updatedFm = { ...frontmatter, tags };
	const newContent = serializeFrontmatter(updatedFm, body);

	atomicWrite(fullPath, newContent);
	return { path: params.path, action: params.action, tag: params.tag };
}
