export interface Frontmatter {
	id?: string;
	aliases?: string[];
	tags?: string[];
	[key: string]: unknown;
}

/**
 * Parse YAML frontmatter from markdown content.
 * Read-only - minimal YAML subset (simple key-value, arrays, strings).
 */
export function parseFrontmatter(content: string): { frontmatter: Frontmatter; body: string } {
	const match = content.match(/^---\n([\s\S]*?)\n---\n?([\s\S]*)$/);
	if (!match) {
		return { frontmatter: {}, body: content };
	}

	const yaml = match[1];
	const body = match[2];
	const fm: Frontmatter = {};

	let currentKey: string | null = null;
	let currentArray: string[] = [];

	for (const line of yaml.split("\n")) {
		// Array item (indented with - )
		const arrMatch = line.match(/^\s+-\s+(.+)/);
		if (arrMatch && currentKey) {
			currentArray.push(arrMatch[1].trim());
			continue;
		}

		// Flush pending array
		if (currentKey && currentArray.length > 0) {
			fm[currentKey] = currentArray;
			currentArray = [];
			currentKey = null;
		}

		// Key: Value
		const kv = line.match(/^(\w[\w-]*)\s*:\s*(.*)/);
		if (kv) {
			const key = kv[1];
			let value = kv[2].trim();

			// Strip quotes
			if ((value.startsWith('"') && value.endsWith('"')) ||
				(value.startsWith("'") && value.endsWith("'"))) {
				value = value.slice(1, -1);
			}

			if (value === "") {
				// Could be start of array
				currentKey = key;
				currentArray = [];
			} else {
				// Scalar value
				const lower = value.toLowerCase();
				if (lower === "true") fm[key] = true;
				else if (lower === "false") fm[key] = false;
				else if (value === "[]") fm[key] = [];
				else fm[key] = value;
			}
		}
	}

	// Flush last array
	if (currentKey) {
		fm[currentKey] = currentArray.length > 0 ? currentArray : [];
	}

	return { frontmatter: fm, body };
}

/**
 * Serialize frontmatter + content back to string.
 */
export function serializeFrontmatter(frontmatter: Frontmatter, body: string): string {
	const lines: string[] = ["---"];

	for (const [key, value] of Object.entries(frontmatter)) {
		if (Array.isArray(value)) {
			lines.push(`${key}:`);
			for (const item of value) {
				lines.push(`  - ${item}`);
			}
		} else if (typeof value === "boolean") {
			lines.push(`${key}: ${value}`);
		} else if (typeof value === "number") {
			lines.push(`${key}: ${value}`);
		} else if (typeof value === "string") {
			// Quote strings with special chars
			if (/[:\n#{}[\]&*!|>'"%@`]/.test(value) || value.length === 0) {
				lines.push(`${key}: "${value.replace(/"/g, '\\"')}"`);
			} else {
				lines.push(`${key}: ${value}`);
			}
		}
	}

	lines.push("---");
	lines.push("");
	return lines.join("\n") + body;
}
