import { execFileSync } from "node:child_process";
import { existsSync } from "node:fs";
import { dirname } from "node:path";
import { homedir } from "node:os";

/**
 * Stage and commit a single file in a git vault.
 * Commit format: vault: <relative/path.md>
 * Only commits if vault.git is true and the vault is a git repo.
 */
export function commitFile(
	vault: { path: string; git: boolean },
	relativePath: string,
	message?: string,
): void {
	if (!vault.git) return;

	const vaultPath = vault.path.replace(/^~/, homedir());
	const gitDir = findGitDir(vaultPath);
	if (!gitDir) return;

	const msg = message ?? `vault: ${relativePath}`;

	execFileSync("git", ["add", relativePath], { cwd: vaultPath, encoding: "utf8", stdio: "pipe", timeout: 10000 });
	execFileSync("git", ["commit", "-m", msg], { cwd: vaultPath, encoding: "utf8", stdio: "pipe", timeout: 10000 });
}

function findGitDir(start: string): string | null {
	let dir = start;
	while (dir && dir !== "/") {
		if (existsSync(dir + "/.git")) return dir + "/.git";
		const parent = dirname(dir);
		if (parent === dir) break;
		dir = parent;
	}
	return null;
}
