/**
 * Wikilink types:
 *   [[note-name]]              - simple link
 *   [[note-name|display text]]  - aliased link
 *   [[note-name#section]]       - link to heading
 *   [[note-name#section|alias]] - combined
 */

export interface Wikilink {
	raw: string;
	target: string;    // e.g., "note-name"
	alias: string | null;
	heading: string | null;
}

const WIKILINK_RE = /\[\[([^\]|#]+)(?:#([^\]|]*))?(?:\|([^\]]*))?\]\]/g;

export function parseWikilinks(text: string): Wikilink[] {
	const results: Wikilink[] = [];
	for (const match of text.matchAll(WIKILINK_RE)) {
		results.push({
			raw: match[0],
			target: match[1].trim(),
			heading: match[2]?.trim() || null,
			alias: match[3]?.trim() || null,
		});
	}
	return results;
}

/**
 * Extract all unique target note names from a block of text.
 * Strips .md extension if present.
 */
export function extractLinkTargets(text: string): string[] {
	const links = parseWikilinks(text);
	const targets = new Set<string>();
	for (const link of links) {
		let t = link.target;
		if (t.toLowerCase().endsWith(".md")) {
			t = t.slice(0, -3);
		}
		targets.add(t);
	}
	return [...targets];
}

/**
 * Check if a note filename matches a wikilink target.
 * "note-name" matches "note-name.md", "Note Name.md", "note name.md"
 */
export function noteMatchesLink(noteFilename: string, linkTarget: string): boolean {
	const noExt = noteFilename.replace(/\.md$/i, "");
	return noExt.toLowerCase() === linkTarget.toLowerCase();
}
