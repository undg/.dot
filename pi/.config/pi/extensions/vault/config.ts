import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";

export interface VaultConfig {
	vaults: { name: string; path: string; git?: boolean }[];
}

let _config: VaultConfig | null = null;
let _configPath: string | null = null;

export function setConfigPath(path: string): void {
	_configPath = path;
	_config = null;
}

export function getConfig(): VaultConfig {
	if (_config) return _config;
	const path = _configPath || homedir() + "/.config/pi/vault.json";

	if (!existsSync(path)) {
		return { vaults: [] };
	}

	const raw = readFileSync(path, "utf8");
	_config = JSON.parse(raw) as VaultConfig;
	return _config!;
}

export function resolveVault(input?: string | number): { name: string; path: string; git: boolean; index: number } {
	const config = getConfig();

	if (config.vaults.length === 0) {
		throw new Error("No vaults configured. Set up ~/.config/pi/vault.json");
	}

	let idx = 0;

	if (typeof input === "number") {
		idx = input;
	} else if (typeof input === "string") {
		if (input === "both") {
			throw new Error('"both" is not valid for single-vault tools. Use vault_search, vault_list, or vault_tags.');
		}
		const byName = config.vaults.findIndex((v) => v.name === input);
		if (byName >= 0) {
			idx = byName;
		} else {
			const num = parseInt(input, 10);
			if (!isNaN(num) && num >= 0 && num < config.vaults.length) {
				idx = num;
			} else {
				throw new Error(`Vault not found: "${input}"`);
			}
		}
	}

	if (idx < 0 || idx >= config.vaults.length) {
		throw new Error(`Invalid vault index: ${idx} (have ${config.vaults.length} vaults)`);
	}

	const v = config.vaults[idx];
	return { name: v.name, path: v.path, git: v.git !== false, index: idx };
}

/**
 * For tools that support "both" (vault_search, vault_list, vault_tags).
 * Returns single vault for specific input, all vaults for "both" or undefined.
 */
export function resolveVaults(input?: string | number): Array<{ name: string; path: string; git: boolean; index: number }> {
	if (input === undefined || input === "both") {
		return getConfig().vaults.map((v, i) => ({
			name: v.name,
			path: v.path,
			git: v.git !== false,
			index: i,
		}));
	}
	return [resolveVault(input)];
}
