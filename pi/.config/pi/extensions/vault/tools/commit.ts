import { Type } from "typebox";
import { resolveVault } from "../config.js";
import { commitFile } from "../utils/git.js";

export const commitParams = Type.Object({
	path: Type.String({ description: "Relative path from vault root — the file to stage and commit" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
	message: Type.Optional(Type.String({ description: "Override auto-generated commit message" })),
});

export async function execute(params: {
	path: string;
	vault?: string | number;
	message?: string;
}): Promise<{ path: string; committed: boolean }> {
	const v = resolveVault(params.vault);

	if (!v.git) {
		return { path: params.path, committed: false };
	}

	commitFile(v, params.path, params.message);

	return { path: params.path, committed: true };
}
