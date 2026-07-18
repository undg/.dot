import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { BrowserManager } from "./browser";
import { registerRichWebfetch } from "./tool";

export default function (pi: ExtensionAPI) {
  const browserManager = new BrowserManager();

  pi.on("session_shutdown", async () => {
    await browserManager.close();
  });

  registerRichWebfetch(pi, browserManager);
}
