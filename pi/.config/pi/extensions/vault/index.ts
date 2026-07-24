import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

// Config singleton
import { setConfigPath, resolveVault } from "./config.js";

// Tools
import { searchParams, execute as searchExec } from "./tools/search.js";
import { readParams, execute as readExec } from "./tools/read.js";
import { newParams, execute as newExec } from "./tools/new.js";
import { saveParams, execute as saveExec } from "./tools/save.js";
import { appendParams, execute as appendExec } from "./tools/append.js";
import { listParams, execute as listExec } from "./tools/list.js";
import { tagsParams, execute as tagsExec } from "./tools/tags.js";
import { tagParams, execute as tagExec } from "./tools/tag.js";
import { backlinksParams, execute as backlinksExec } from "./tools/backlinks.js";
import { commitParams, execute as commitExec } from "./tools/commit.js";

// Utils for vault_daily
import { dailyNotePath, dailyFrontmatter } from "./utils/daily.js";
import { resolveVaultPath, atomicWrite } from "./utils/paths.js";

import { serializeFrontmatter } from "./utils/frontmatter.js";

const CONFIG_PATH = join(homedir(), ".config", "pi", "vault.json");

function ensureDefaultConfig(): void {
	if (!existsSync(CONFIG_PATH)) {
		writeFileSync(
			CONFIG_PATH,
			JSON.stringify(
				{
					vaults: [
						{
							name: "default",
							path: join(homedir(), "Documents", "Obsidian"),
							git: true,
						},
					],
				},
				null,
				"\t"
			) + "\n",
			"utf8"
		);
	}
}

export default function (pi: ExtensionAPI) {
	setConfigPath(CONFIG_PATH);
	ensureDefaultConfig();

	// vault_search
	pi.registerTool({
		name: "vault_search",
		label: "Vault Search",
		description: "Search notes across Obsidian vaults using ripgrep. Supports tag, date, folder filters, and backlinks.",
		promptSnippet: "Search Obsidian vault notes with ripgrep (supports tag, date, folder, backlinks)",
		parameters: searchParams,
		async execute(_toolCallId, params) {
			const results = await searchExec(params as any);
			if (results.length === 0) {
				return {
					content: [{ type: "text", text: "No results found." }],
					details: { results: [] },
				};
			}
			const lines = results.map(r =>
				`[${r.vault}] ${r.path}:${r.line} — ${r.match}${r.context ? ` (${r.context})` : ""}`
			);
			return {
				content: [{ type: "text", text: `${results.length} result(s):\n${lines.join("\n")}` }],
				details: { results },
			};
		},
	});

	// vault_read
	pi.registerTool({
		name: "vault_read",
		label: "Vault Read",
		description: "Read a note's full content from an Obsidian vault.",
		promptSnippet: "Read full content of an Obsidian note by path",
		parameters: readParams,
		async execute(_toolCallId, params) {
			const content = await readExec(params as any);
			return {
				content: [{ type: "text", text: content }],
				details: { path: params.path, size: content.length },
			};
		},
	});

	// vault_new
	pi.registerTool({
		name: "vault_new",
		label: "Vault New",
		description: "Create a new note in an Obsidian vault with standard frontmatter. Fails if note already exists.",
		promptSnippet: "Create a new Obsidian note with frontmatter (id, aliases, tags)",
		parameters: newParams,
		async execute(_toolCallId, params) {
			const result = await newExec(params as any);
			return {
				content: [{ type: "text", text: `Created note: ${result.path}` }],
				details: result,
			};
		},
	});

	// vault_save
	pi.registerTool({
		name: "vault_save",
		label: "Vault Save",
		description: "Save content to a note. Creates file if new, overwrites if exists. Atomic write. Provide full markdown including frontmatter.",
		promptSnippet: "Save full markdown content to an Obsidian note (creates or overwrites; atomic)",
		parameters: saveParams,
		async execute(_toolCallId, params) {
			const result = await saveExec(params as any);
			return {
				content: [{ type: "text", text: `Saved note: ${result.path}` }],
				details: result,
			};
		},
	});

	// vault_append
	pi.registerTool({
		name: "vault_append",
		label: "Vault Append",
		description: "Append content to end of note. Atomic write. Never overwrites existing content.",
		promptSnippet: "Append content to the end of an Obsidian note (atomic, never overwrites)",
		parameters: appendParams,
		async execute(_toolCallId, params) {
			const result = await appendExec(params as any);
			return {
				content: [{ type: "text", text: `Appended to note: ${result.path}` }],
				details: result,
			};
		},
	});

	// vault_list
	pi.registerTool({
		name: "vault_list",
		label: "Vault List",
		description: "List notes in vault/folder with optional glob pattern.",
		promptSnippet: "List notes in Obsidian vault(s) with optional folder/glob filter",
		parameters: listParams,
		async execute(_toolCallId, params) {
			const results = await listExec(params as any);
			if (results.length === 0) {
				return {
					content: [{ type: "text", text: "No notes found." }],
					details: { notes: [] },
				};
			}
			const lines = results.map(r =>
				`[${r.vault}] ${r.path} (${(r.size / 1024).toFixed(1)}KB, ${r.modified})`
			);
			return {
				content: [{ type: "text", text: `${results.length} note(s):\n${lines.join("\n")}` }],
				details: { notes: results },
			};
		},
	});

	// vault_tag
	pi.registerTool({
		name: "vault_tag",
		label: "Vault Tag",
		description: "Add or remove tags from a note's frontmatter. Only touches frontmatter tags field.",
		promptSnippet: "Add or remove frontmatter tags on an Obsidian note",
		parameters: tagParams,
		async execute(_toolCallId, params) {
			const result = await tagExec(params as any);
			const verb = result.action === "add" ? "Added" : "Removed";
			return {
				content: [{ type: "text", text: `${verb} tag "${result.tag}" on ${result.path}` }],
				details: result,
			};
		},
	});

	// vault_tags
	pi.registerTool({
		name: "vault_tags",
		label: "Vault Tags",
		description: "List all tags across vaults with counts. Extracts from frontmatter and inline #tags.",
		promptSnippet: "List all tags across Obsidian vaults with usage counts",
		parameters: tagsParams,
		async execute(_toolCallId, params) {
			const results = await tagsExec(params as any);
			if (results.length === 0) {
				return {
					content: [{ type: "text", text: "No tags found." }],
					details: { tags: [] },
				};
			}
			const lines = results.map(r => `${r.tag}: ${r.count}`);
			return {
				content: [{ type: "text", text: `${results.length} tag(s):\n${lines.join("\n")}` }],
				details: { tags: results },
			};
		},
	});

	// vault_backlinks
	pi.registerTool({
		name: "vault_backlinks",
		label: "Vault Backlinks",
		description: "Find notes that [[wikilink]] to a given note.",
		promptSnippet: "Find notes that wikilink to a given Obsidian note",
		parameters: backlinksParams,
		async execute(_toolCallId, params) {
			const results = await backlinksExec(params as any);
			if (results.length === 0) {
				return {
					content: [{ type: "text", text: "No backlinks found." }],
					details: { backlinks: [] },
				};
			}
			const lines = results.map(r => `${r.path} → ${r.context}`);
			return {
				content: [{ type: "text", text: `${results.length} backlink(s):\n${lines.join("\n")}` }],
				details: { backlinks: results },
			};
		},
	});

	// vault_git_commit
	pi.registerTool({
		name: "vault_git_commit",
		label: "Vault Git Commit",
		description: "Stage and commit a single file in a git-managed vault. Only the specified file is committed — other unstaged changes remain untouched.",
		promptSnippet: "Stage and commit a single file in an Obsidian vault (git)",
		parameters: commitParams,
		async execute(_toolCallId, params) {
			const result = await commitExec(params as any);
			if (result.committed) {
				return {
					content: [{ type: "text", text: `Committed: ${result.path}` }],
					details: result,
				};
			}
			return {
				content: [{ type: "text", text: `File not committed (git disabled for vault): ${result.path}` }],
				details: result,
			};
		},
	});

	// vault_daily — quick daily note helper
	pi.registerTool({
		name: "vault_daily",
		label: "Vault Daily",
		description: "Read or create today's daily note.",
		promptSnippet: "Read or create today's daily note in the Obsidian vault",
		parameters: Type.Object({
			vault: Type.Optional(Type.Union([Type.String(), Type.Number()], { description: "Vault name or index" })),
		}),
		async execute(_toolCallId, params) {
			const dailyPath = dailyNotePath();
			const v = resolveVault(params.vault);
			const fullPath = resolveVaultPath(v.path, dailyPath);

			if (existsSync(fullPath)) {
				const content = readFileSync(fullPath, "utf8");
				return {
					content: [{ type: "text", text: content }],
					details: { path: dailyPath, existing: true },
				};
			}

			// Create daily note
			const fm = dailyFrontmatter(dailyPath);
			const fullContent = serializeFrontmatter(fm as any, "# " + dailyPath.replace(/\.md$/, "") + "\n");
			atomicWrite(fullPath, fullContent);
			return {
				content: [{ type: "text", text: fullContent }],
				details: { path: dailyPath, existing: false, created: true },
			};
		},
	});
}
