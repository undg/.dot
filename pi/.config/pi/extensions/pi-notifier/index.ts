import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile, execFileSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { basename, dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import notifier from "node-notifier";

const __dirname = dirname(fileURLToPath(import.meta.url));

const CONFIG_PATH = join(homedir(), ".config", "pi", "pi-notifier.json");

interface NotifierConfig {
	sound: boolean;
	notification: boolean;
	bell: boolean;
	timeout: number;
	suppressWhenFocused: boolean;
	minDuration: number;
	volumes: Record<string, number>;
	sounds: Record<string, string | null>;
}

const DEFAULT_CONFIG: NotifierConfig = {
	sound: true,
	notification: true,
	bell: false,
	timeout: 5,
	suppressWhenFocused: true,
	minDuration: 0,
	volumes: { complete: 1, error: 1, permission: 1 },
	sounds: { complete: null, error: null, permission: null },
};

function loadConfig(): NotifierConfig {
	if (!existsSync(CONFIG_PATH)) return DEFAULT_CONFIG;
	try {
		const raw = JSON.parse(readFileSync(CONFIG_PATH, "utf8")) as Partial<NotifierConfig>;
		return {
			...DEFAULT_CONFIG,
			...raw,
			volumes: { ...DEFAULT_CONFIG.volumes, ...raw.volumes },
			sounds: { ...DEFAULT_CONFIG.sounds, ...raw.sounds },
		};
	} catch {
		return DEFAULT_CONFIG;
	}
}

const config = loadConfig();

const PLAYERS = [
	{ cmd: "paplay", args: (path: string, volume: number) => [`--volume=${Math.round(volume * 65536)}`, path] },
	{ cmd: "aplay", args: (path: string) => [path] },
	{ cmd: "mpv", args: (path: string, volume: number) => [`--volume=${Math.round(volume * 100)}`, "--no-terminal", path] },
	{ cmd: "ffplay", args: (path: string, volume: number) => ["-nodisp", "-autoexit", "-volume", `${Math.round(volume * 100)}`, path] },
];

function isFocused(): boolean {
	if (!config.suppressWhenFocused) return false;
	if (process.env.TMUX) {
		try {
			const out = execFileSync("tmux", ["display-message", "-p", "#{session_attached} #{window_active} #{pane_active}"], {
				encoding: "utf8",
				timeout: 1000,
			});
			const [attached, windowActive, paneActive] = out.trim().split(/\s+/);
			return attached === "1" && windowActive === "1" && paneActive === "1";
		} catch {
			return false;
		}
	}
	return false;
}

function soundPath(event: string): string | null {
	const custom = config.sounds[event];
	if (custom && existsSync(custom)) return custom;
	const bundled = join(__dirname, "sounds", `${event}.wav`);
	return existsSync(bundled) ? bundled : null;
}

function playSound(event: string) {
	if (!config.sound) return;
	const path = soundPath(event);
	if (!path) return;
	const volume = Math.max(0, Math.min(1, config.volumes[event] ?? 1));

	for (const player of PLAYERS) {
		try {
			execFile(player.cmd, player.args(path, volume), { timeout: 30000 }, () => {});
			return;
		} catch (e: any) {
			if (e.code !== "ENOENT") return;
		}
	}
}

function sendNotification(title: string, message: string) {
	if (!config.notification) return;
	notifier.notify({ title, message, timeout: config.timeout } as any, () => {});
}

function notify(event: string, title: string, message: string, force = false) {
	const blocked = !force && isFocused();
	if (config.notification && !blocked) sendNotification(title, message);
	if (config.sound && !blocked) playSound(event);
	if (config.bell && !blocked) process.stdout.write("\x07");
}

export default function (pi: ExtensionAPI) {
	let sessionStartTime = 0;
	let errorNotified = false;

	pi.on("session_start", () => {
		sessionStartTime = Date.now();
		errorNotified = false;
	});

	pi.on("agent_settled", (_event, ctx) => {
		const elapsed = (Date.now() - sessionStartTime) / 1000;
		if (config.minDuration > 0 && elapsed < config.minDuration) return;
		notify("complete", "Pi done", basename(ctx.cwd), true);
	});

	pi.on("turn_end", (event: { toolResults?: Array<{ isError?: boolean }> }) => {
		if (errorNotified) return;
		if (event.toolResults?.some((r) => r.isError)) {
			errorNotified = true;
			notify("error", "Pi error", "A tool failed");
		}
	});

	pi.events.on("permissions:ui_prompt", (raw) => {
		const event = raw as PermissionUiPromptEvent;
		const title = `Pi permission: ${event.surface ?? "request"}`;
		const body = event.message || event.value || "Permission needed";
		notify("permission", title, body, true);
	});
}

interface PermissionUiPromptEvent {
	requestId: string;
	source: string;
	surface: string | null;
	value: string | null;
	agentName: string | null;
	message: string;
	forwarding: unknown;
}
