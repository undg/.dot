import { Type } from "typebox";
import { resolveVault } from "../config.js";
import { resolveVaultPath, atomicWrite } from "../utils/paths.js";

export const saveParams = Type.Object({
	path: Type.String({ description: "Relative path from vault root" }),
	content: Type.String({ description: "Full markdown content including frontmatter block" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
});

export async function execute(params: {
	path: string;
	content: string;
	vault?: string | number;
}): Promise<{ path: string }> {
	const v = resolveVault(params.vault);
	const fullPath = resolveVaultPath(v.path, params.path);

	atomicWrite(fullPath, params.content);
	return { path: params.path };
}
