import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		// pi-diff enables expanded output during the same event. Defer this
		// override until all session_start handlers have run.
		setTimeout(() => ctx.ui.setToolsExpanded(false), 0);
	});
}
