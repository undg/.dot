import { Type } from "typebox";
import { readFileSync, existsSync } from "node:fs";
import { resolveVault } from "../config.js";
import { resolveVaultPath } from "../utils/paths.js";

export const readParams = Type.Object({
	path: Type.String({ description: "Relative path from vault root" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
});

export async function execute(params: { path: string; vault?: string | number }): Promise<string> {
	const v = resolveVault(params.vault);
	const fullPath = resolveVaultPath(v.path, params.path);

	if (!existsSync(fullPath)) {
		throw new Error(`Note not found: ${params.path}`);
	}

	return readFileSync(fullPath, "utf8");
}
