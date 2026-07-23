import { mkdirSync, renameSync, writeFileSync } from "node:fs";
import { dirname, resolve as resolvePath } from "node:path";
import { homedir } from "node:os";

export function expandTilde(fp: string): string {
	if (fp.startsWith("~/") || fp === "~") {
		return resolvePath(homedir(), fp.slice(2));
	}
	return fp;
}

export function resolveVaultPath(vaultPath: string, relative: string): string {
	const base = expandTilde(vaultPath);
	const resolved = resolvePath(base, relative);
	if (!resolved.startsWith(base + "/") && resolved !== base) {
		throw new Error(`Path escapes vault: ${relative}`);
	}
	return resolved;
}

export function atomicWrite(filePath: string, content: string): void {
	mkdirSync(dirname(filePath), { recursive: true });
	const tmp = filePath + ".tmp." + Date.now();
	writeFileSync(tmp, content, "utf8");
	renameSync(tmp, filePath);
}
