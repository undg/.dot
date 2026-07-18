import { execFile } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

export interface BraveSearchConfig {
	apiKey: string;
	summaryModel?: string;
	alwaysSummarize?: boolean;
	maxSummaryTokens?: number;
}

const ENV_KEY = "BRAVE_API_KEY";
let cachedApiKey: string | undefined | null = null;

export function getConfigPath(): string {
	if (process.env.BRAVE_SEARCH_CONFIG) {
		return process.env.BRAVE_SEARCH_CONFIG;
	}
	return join(dirname(fileURLToPath(import.meta.url)), "config.json");
}

export function loadConfig(): BraveSearchConfig | undefined {
	const path = getConfigPath();
	if (!existsSync(path)) return undefined;
	try {
		const raw = JSON.parse(readFileSync(path, "utf8")) as unknown;
		if (raw && typeof raw === "object" && "apiKey" in raw && typeof raw.apiKey === "string") {
			return raw as BraveSearchConfig;
		}
	} catch {
		// ignore malformed config
	}
	return undefined;
}

function execPromise(file: string, args: string[]): Promise<{ stdout: string; stderr: string; code: number }> {
	return new Promise((resolve) => {
		execFile(file, args, { encoding: "utf8" }, (error, stdout, stderr) => {
			if (error) {
				resolve({ stdout: stdout as string, stderr: stderr as string, code: (error.code as number) ?? 1 });
			} else {
				resolve({ stdout: stdout as string, stderr: stderr as string, code: 0 });
			}
		});
	});
}

async function resolveConfigValue(value: string): Promise<string | undefined> {
	const trimmed = value.trim();
	if (!trimmed) return undefined;

	if (trimmed.startsWith("!")) {
		const cmd = trimmed.slice(1);
		const { stdout, stderr, code } = await execPromise("sh", ["-c", cmd]);
		if (code !== 0) {
			throw new Error(`Key command failed (exit ${code}): ${stderr.trim() || cmd}`);
		}
		return stdout.trim() || undefined;
	}

	if (trimmed.startsWith("$")) {
		const varName = trimmed.slice(1);
		return process.env[varName]?.trim() || undefined;
	}

	return trimmed;
}

export async function resolveApiKey(): Promise<string | undefined> {
	if (cachedApiKey !== null) return cachedApiKey || undefined;

	const envKey = process.env[ENV_KEY];
	if (envKey) {
		cachedApiKey = envKey.trim();
		return cachedApiKey;
	}

	const config = loadConfig();
	if (config) {
		const resolved = await resolveConfigValue(config.apiKey);
		if (resolved) {
			cachedApiKey = resolved;
			return cachedApiKey;
		}
	}

	cachedApiKey = undefined;
	return undefined;
}

export function setupErrorText(): string {
	return [
		"Brave Search API key not found.",
		"",
		"To set it up:",
		"1. Export BRAVE_API_KEY environment variable, OR",
		"2. Create a config file at:",
		`   ${getConfigPath()}`,
		"   with contents like:",
		`   { "apiKey": "!$HOME/.config/pi/get-api-key brave-api" }`,
		"",
		"Store the key in your OS keyring first, for example:",
		"   secret-tool store --label='Brave API' provider brave-api",
	].join("\n");
}
