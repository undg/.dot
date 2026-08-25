import { existsSync } from "node:fs";
import { platform } from "node:os";
import { Type } from "typebox";
import { resolveVault } from "../config.js";
import { resolveVaultPath } from "../utils/paths.js";

export const openParams = Type.Object({
	path: Type.String({ description: "Relative path from vault root of the note to open" }),
	vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
});

export async function execute(
	params: { path: string; vault?: string | number },
	exec: (command: string, args: string[]) => Promise<{ code: number | null; stderr: string; stdout: string }>,
): Promise<{ path: string; url: string }> {
	const vault = resolveVault(params.vault);
	const notePath = resolveVaultPath(vault.path, params.path);

	if (!existsSync(notePath)) {
		throw new Error(`Note not found: ${params.path}`);
	}

	const url = `obsidian://open?vault=${encodeURIComponent(vault.name)}&file=${encodeURIComponent(params.path)}`;
	const currentPlatform = platform();
	const command = currentPlatform === "darwin" ? "open" : currentPlatform === "linux" ? "xdg-open" : undefined;

	if (!command) {
		throw new Error(`Opening Obsidian notes is not supported on ${currentPlatform}`);
	}

	const result = await exec(command, [url]);
	if (result.code !== 0) {
		throw new Error(result.stderr || result.stdout || `Failed to open ${params.path}`);
	}

	return { path: params.path, url };
}
