import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { randomUUID } from "node:crypto";

const ZEN_PROVIDER = "oc-sdk-zen";

export default function (pi: ExtensionAPI) {
	pi.on("before_provider_headers", (event, ctx) => {
		const provider = ctx.model?.provider;
		if (!provider || !provider.startsWith(ZEN_PROVIDER)) return;

		event.headers["x-opencode-client"] = "cli";
		event.headers["x-opencode-session"] = randomUUID();
		event.headers["x-opencode-project"] = randomUUID();
		event.headers["x-opencode-request"] = randomUUID();
		event.headers["User-Agent"] = "opencode/latest/1.3.15/cli";
	});

	pi.on("after_provider_response", (event, ctx) => {
		const provider = ctx.model?.provider;
		if (!provider || !provider.startsWith(ZEN_PROVIDER)) return;
		if (event.status !== 429) return;

		const retryAfter = event.headers["retry-after"] ?? event.headers["Retry-After"];
		if (retryAfter) {
			ctx.ui.notify(`Zen rate limited. Retry-After: ${retryAfter}`, "warning");
		} else {
			ctx.ui.notify("Zen rate limited. No Retry-After header.", "warning");
		}
	});
}
