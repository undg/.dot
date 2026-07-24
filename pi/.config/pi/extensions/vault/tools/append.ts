import { Type } from "typebox";
import { readFileSync } from "node:fs";
import { resolveVault } from "../config.js";
import { resolveVaultPath, atomicWrite } from "../utils/paths.js";

export const appendParams = Type.Object({
	path: Type.String({ description: "Relative path from vault root" }),
	content: Type.String({ description: "Content to append" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
	separator: Type.Optional(Type.String({ description: "Separator before appended content", default: "\n\n" })),
});

export async function execute(params: {
	path: string;
	content: string;
	vault?: string | number;
	separator?: string;
}): Promise<{ path: string }> {
	const v = resolveVault(params.vault);
	const fullPath = resolveVaultPath(v.path, params.path);

	const existing = readFileSync(fullPath, "utf8");
	const sep = params.separator ?? "\n\n";
	const newContent = existing + sep + params.content;

	atomicWrite(fullPath, newContent);
	return { path: params.path };
}
