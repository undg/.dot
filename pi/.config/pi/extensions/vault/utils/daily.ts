const DAILY_FOLDER = "Daily";
const DAILY_FILENAME_FORMAT = /^\d{4}-\d{2}-\d{2}\.md$/;
const DAILY_DEFAULT_TAGS = ["daily", "journal"];

export function isDailyPath(relativePath: string): boolean {
	return relativePath.startsWith(DAILY_FOLDER + "/") && DAILY_FILENAME_FORMAT.test(
		relativePath.slice(DAILY_FOLDER.length + 1)
	);
}

export function dailyId(dateStr: string): string {
	return dateStr.replace(/\.md$/i, "");
}

export function dailyFrontmatter(relativePath: string): Record<string, unknown> {
	const filename = relativePath.split("/").pop() || "";
	const id = dailyId(filename);

	return {
		id,
		aliases: [],
		tags: DAILY_DEFAULT_TAGS,
	};
}

export function todayFilename(): string {
	const d = new Date();
	const yyyy = d.getFullYear();
	const mm = String(d.getMonth() + 1).padStart(2, "0");
	const dd = String(d.getDate()).padStart(2, "0");
	return `${yyyy}-${mm}-${dd}.md`;
}

export function dailyNotePath(): string {
	return `${DAILY_FOLDER}/${todayFilename()}`;
}

export { DAILY_FOLDER, DAILY_DEFAULT_TAGS };
