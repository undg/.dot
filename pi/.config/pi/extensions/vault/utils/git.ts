import { execFileSync } from "node:child_process";
import { existsSync } from "node:fs";
import { dirname } from "node:path";
import { homedir } from "node:os";

/**
 * Auto-commit a file in a git vault.
 * Commit format: vault(<YYYY-MM-DD>): <relative/path.md>
 * Only commits if vault.git is true and the vault is a git repo.
 */
export function autoCommit(vault: { path: string; git: boolean }, relativePath: string): void {
	if (!vault.git) return;

	const vaultPath = vault.path.replace(/^~/, homedir());
	const gitDir = findGitDir(vaultPath);
	if (!gitDir) return;

	const now = new Date();
	const yyyy = now.getFullYear();
	const mm = String(now.getMonth() + 1).padStart(2, "0");
	const dd = String(now.getDate()).padStart(2, "0");
	const dateStr = `${yyyy}-${mm}-${dd}`;
	const msg = `vault(${dateStr}): ${relativePath}`;

	try {
		execFileSync("git", ["add", relativePath], { cwd: vaultPath, encoding: "utf8", stdio: "pipe", timeout: 10000 });
		execFileSync("git", ["commit", "-m", msg], { cwd: vaultPath, encoding: "utf8", stdio: "pipe", timeout: 10000 });
	} catch {
		// Silently ignore commit failures (nothing to commit, no changes, etc.)
	}
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
