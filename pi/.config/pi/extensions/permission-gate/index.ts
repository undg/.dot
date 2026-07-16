import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { getAgentDir } from "@earendil-works/pi-coding-agent";
import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { basename, join, resolve } from "node:path";

/**
 * Permission gate for pi.
 *
 * Reads `permissions.json` from the pi agent directory (e.g. `~/.config/pi/`).
 * The file follows the same spirit as the OpenCode permission system:
 *   - `tools`: default allow/ask/deny per tool name
 *   - `read`/`write`/`edit`: path patterns (most specific match wins)
 *   - `bash`: command patterns (most specific match wins)
 *
 * If a rule action is `deny`, the tool call is blocked. If it is `ask`, a
 * confirmation dialog is shown in the TUI; in non-interactive mode `ask`
 * becomes `deny`.
 *
 * Patterns support simple glob syntax:
 *   - `*` matches any characters (in path-aware mode it does not cross `/`)
 *   - `**` matches any number of path segments
 *   - `?` matches a single character
 *   - `~` is expanded to the user's home directory
 */

type Action = "allow" | "ask" | "deny";

interface PatternRule {
	pattern: string;
	action: Action;
}

interface PermissionConfig {
	tools?: Record<string, Action>;
	read?: PatternRule[];
	write?: PatternRule[];
	edit?: PatternRule[];
	bash?: PatternRule[];
	/** Tools whose `path` argument should be checked against the `read` rules. */
	pathTools?: string[];
}

const DEFAULT_CONFIG: PermissionConfig = {
	tools: {
		read: "allow",
		bash: "ask",
		edit: "allow",
		write: "allow",
		grep: "allow",
		find: "allow",
		ls: "allow",
	},
	read: [
		{ pattern: "*", action: "allow" },
		{ pattern: "*.env.example", action: "allow" },
		{ pattern: "*.env", action: "deny" },
		{ pattern: "*.env.*", action: "deny" },
		{ pattern: "**/.git/**", action: "deny" },
		{ pattern: ".git/**", action: "deny" },
		{ pattern: "**/.ssh/**", action: "deny" },
		{ pattern: ".ssh/**", action: "deny" },
	],
	write: [
		{ pattern: "*", action: "allow" },
		{ pattern: "*.env", action: "deny" },
		{ pattern: "*.env.*", action: "deny" },
		{ pattern: "**/.git/**", action: "deny" },
		{ pattern: ".git/**", action: "deny" },
		{ pattern: "**/.ssh/**", action: "deny" },
		{ pattern: ".ssh/**", action: "deny" },
	],
	edit: [
		{ pattern: "*", action: "allow" },
		{ pattern: "*.env", action: "deny" },
		{ pattern: "*.env.*", action: "deny" },
		{ pattern: "**/.git/**", action: "deny" },
		{ pattern: ".git/**", action: "deny" },
		{ pattern: "**/.ssh/**", action: "deny" },
		{ pattern: ".ssh/**", action: "deny" },
	],
	bash: [
		{ pattern: "GIT_EDITOR=true git rebase --continue", action: "allow" },
		{ pattern: "git rebase --continue", action: "allow" },
		{ pattern: "git diff *", action: "allow" },
		{ pattern: "git log *", action: "allow" },
		{ pattern: "git show *", action: "allow" },
		{ pattern: "git status *", action: "allow" },
		{ pattern: "git branch *", action: "allow" },
		{ pattern: "git merge-base *", action: "allow" },
		{ pattern: "git push *", action: "deny" },
		{ pattern: "git commit *", action: "ask" },
		{ pattern: "git config *", action: "ask" },
		{ pattern: "git remote *", action: "ask" },
		{ pattern: "git rebase *", action: "ask" },
		{ pattern: "git *", action: "ask" },
		{ pattern: "gh pr create *", action: "deny" },
		{ pattern: "gh issue list *", action: "allow" },
		{ pattern: "gh issue view *", action: "allow" },
		{ pattern: "gh pr checks *", action: "allow" },
		{ pattern: "gh pr diff *", action: "allow" },
		{ pattern: "gh pr list *", action: "allow" },
		{ pattern: "gh pr view *", action: "allow" },
		{ pattern: "gh repo view *", action: "allow" },
		{ pattern: "gh run list *", action: "allow" },
		{ pattern: "gh run view *", action: "allow" },
		{ pattern: "gh search prs *", action: "allow" },
		{ pattern: "gh pr status *", action: "allow" },
		{ pattern: "gh api *", action: "ask" },
		{ pattern: "gh *", action: "ask" },
		{ pattern: "npm run test *", action: "allow" },
		{ pattern: "npm test *", action: "allow" },
		{ pattern: "npm run lint *", action: "allow" },
		{ pattern: "npm run type-check *", action: "allow" },
		{ pattern: "npm run lint -- --fix *", action: "allow" },
		{ pattern: "pnpm vitest *", action: "allow" },
		{ pattern: "pnpm test *", action: "allow" },
		{ pattern: "pnpm test:ci *", action: "allow" },
		{ pattern: "pnpm lint *", action: "allow" },
		{ pattern: "pnpm lint:files *", action: "allow" },
		{ pattern: "pnpm type-check *", action: "allow" },
		{ pattern: "pnpm lint -- --fix *", action: "allow" },
		{ pattern: "jq *", action: "allow" },
		{ pattern: "ag *", action: "allow" },
		{ pattern: "rg *", action: "allow" },
		{ pattern: "echo *", action: "allow" },
		{ pattern: "echo", action: "allow" },
		{ pattern: "tmux display-message *", action: "allow" },
		{ pattern: "find *", action: "allow" },
		{ pattern: "head *", action: "allow" },
		{ pattern: "tail *", action: "allow" },
		{ pattern: "grep *", action: "allow" },
		{ pattern: "cat *", action: "allow" },
		{ pattern: "ls *", action: "allow" },
		{ pattern: "ls", action: "allow" },
		{ pattern: "pwd *", action: "allow" },
		{ pattern: "pwd", action: "allow" },
		{ pattern: "exa *", action: "allow" },
		{ pattern: "eza *", action: "allow" },
		{ pattern: "wc *", action: "allow" },
		{ pattern: "tree *", action: "allow" },
		{ pattern: "sed *", action: "allow" },
		{ pattern: "sort *", action: "allow" },
		{ pattern: "uniq *", action: "allow" },
		{ pattern: "awk *", action: "allow" },
		{ pattern: "node -e *", action: "deny" },
		{ pattern: "python -c *", action: "deny" },
		{ pattern: "rm -rf *", action: "deny" },
		{ pattern: "rm *", action: "ask" },
		{ pattern: "mv *", action: "ask" },
		{ pattern: "sh *", action: "ask" },
		{ pattern: "curl *", action: "ask" },
		{ pattern: "wget *", action: "ask" },
		{ pattern: "*", action: "ask" },
	],
	pathTools: ["grep", "find", "ls"],
};

function loadConfig(): PermissionConfig {
	const path = join(getAgentDir(), "permissions.json");
	try {
		const raw = readFileSync(path, "utf-8");
		const parsed = JSON.parse(raw) as PermissionConfig;
		// Merge defaults so missing sections still have a safe fallback.
		return {
			...DEFAULT_CONFIG,
			...parsed,
			tools: { ...DEFAULT_CONFIG.tools, ...parsed.tools },
		};
	} catch (e: any) {
		console.error(`[permission-gate] failed to load ${path}: ${e.message}. Using defaults.`);
		return DEFAULT_CONFIG;
	}
}

function expandTilde(value: string): string {
	if (value === "~") return homedir();
	if (value.startsWith("~/")) return join(homedir(), value.slice(2));
	return value;
}

function buildRegexBody(pattern: string, pathAware: boolean): string {
	let re = "";
	let i = 0;
	while (i < pattern.length) {
		const c = pattern[i];
		if (c === "*") {
			if (pattern[i + 1] === "*") {
				re += ".*";
				i += 2;
			} else {
				re += pathAware ? "[^/]*" : ".*";
				i++;
			}
		} else if (c === "?") {
			re += pathAware ? "[^/]" : ".";
			i++;
		} else if (/[.+^${}()|[\]\\]/.test(c)) {
			re += "\\" + c;
			i++;
		} else {
			re += c;
			i++;
		}
	}
	return re;
}

function globToRegex(pattern: string, pathAware: boolean): RegExp {
	// For bash patterns, a trailing " *" should also match the command with no
	// extra arguments (e.g. "git diff" matches "git diff *").
	if (!pathAware && pattern.endsWith(" *")) {
		const base = pattern.slice(0, -2);
		const baseRe = buildRegexBody(base, false);
		return new RegExp("^" + baseRe + "(?: .*)?$");
	}
	return new RegExp("^" + buildRegexBody(pattern, pathAware) + "$");
}

function matchPattern(pattern: string, value: string, isPath: boolean): boolean {
	const expanded = expandTilde(pattern);
	if (isPath) {
		const abs = resolve(expandTilde(value));
		if (expanded.includes("/")) {
			if (globToRegex(expanded, true).test(abs)) return true;
		}
		if (!expanded.includes("/")) {
			if (globToRegex(expanded, true).test(basename(abs))) return true;
		}
	} else {
		if (globToRegex(expanded, false).test(value)) return true;
	}
	return false;
}

function patternSpecificity(pattern: string): number {
	let wildcardChars = 0;
	for (const c of pattern) {
		if (c === "*" || c === "?") {
			wildcardChars++;
		}
	}
	// More literal characters and fewer wildcards = more specific.
	return pattern.length - 2 * wildcardChars;
}

function evaluateRules(
	rules: PatternRule[] | undefined,
	value: string,
	isPath: boolean,
): Action | undefined {
	if (!rules) return undefined;

	let bestAction: Action | undefined;
	let bestScore = -Infinity;

	for (const rule of rules) {
		if (!matchPattern(rule.pattern, value, isPath)) continue;

		const score = patternSpecificity(rule.pattern);
		if (score > bestScore) {
			bestScore = score;
			bestAction = rule.action;
		}
	}

	return bestAction;
}

export default function (pi: ExtensionAPI) {
	const config = loadConfig();

	pi.on("tool_call", async (event, ctx) => {
		const toolName = event.toolName;
		const toolDefault = config.tools?.[toolName];

		// Tool-level deny.
		if (toolDefault === "deny") {
			return {
				block: true,
				reason: `Tool "${toolName}" is disabled by the permission policy`,
			};
		}

		let handled = false;

		// Path-aware tools.
		const pathAwareTools = new Set([
			"read",
			"write",
			"edit",
			...(config.pathTools ?? []),
		]);

		if (pathAwareTools.has(toolName)) {
			const pathValue = (event.input as Record<string, unknown>).path as string | undefined;
			if (pathValue) {
				handled = true;
				const absPath = resolve(ctx.cwd, expandTilde(pathValue));
				const rules = (config as Record<string, PatternRule[] | undefined>)[toolName] ?? config.read;
				const action = evaluateRules(rules, absPath, true);

				if (action === "deny") {
					if (ctx.hasUI) {
						ctx.ui.notify(`Blocked ${toolName}: ${pathValue}`, "warning");
					}
					return {
						block: true,
						reason: `Permission policy blocks ${toolName} on "${pathValue}"`,
					};
				}

				if (action === "ask") {
					if (!ctx.hasUI) {
						return {
							block: true,
							reason: `Permission policy requires confirmation for ${toolName} on "${pathValue}" (no UI available)`,
						};
					}
					const ok = await ctx.ui.confirm(
						"Permission required",
						`Allow ${toolName} on "${pathValue}"?`,
					);
					if (!ok) {
						return {
							block: true,
							reason: "Blocked by user",
						};
					}
					return undefined;
				}
			}
		}

		// Bash command rules.
		if (toolName === "bash") {
			const command = (event.input as Record<string, unknown>).command as string | undefined;
			if (command) {
				handled = true;
				const action = evaluateRules(config.bash, command, false);

				if (action === "deny") {
					if (ctx.hasUI) {
						ctx.ui.notify(`Blocked bash command: ${command}`, "warning");
					}
					return {
						block: true,
						reason: `Permission policy blocks bash command: ${command}`,
					};
				}

				if (action === "ask") {
					if (!ctx.hasUI) {
						return {
							block: true,
							reason: `Permission policy requires confirmation for bash command (no UI available): ${command}`,
						};
					}
					const ok = await ctx.ui.confirm(
						"Permission required",
						`Allow bash command:\n\n${command}`,
					);
					if (!ok) {
						return {
							block: true,
							reason: "Blocked by user",
						};
					}
					return undefined;
				}
			}
		}

		// Tool-level ask for any tool that is not covered by dedicated rules.
		if (!handled && toolDefault === "ask") {
			if (!ctx.hasUI) {
				return {
					block: true,
					reason: `Permission policy requires confirmation for tool "${toolName}" (no UI available)`,
				};
			}
			const ok = await ctx.ui.confirm("Permission required", `Allow tool "${toolName}"?`);
			if (!ok) {
				return {
					block: true,
					reason: "Blocked by user",
				};
			}
		}

		return undefined;
	});
}
