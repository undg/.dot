import { chromium, type Browser, type BrowserContext, type Page } from "playwright";

export class BrowserManager {
  private browser: Browser | null = null;
  private context: BrowserContext | null = null;
  private launchPromise: Promise<BrowserContext> | null = null;
  private closing = false;

  async newPage(): Promise<Page> {
    const context = await this.getContext();
    return context.newPage();
  }

  async close(): Promise<void> {
    this.closing = true;

    if (this.launchPromise) {
      try {
        await this.launchPromise;
      } catch {
        // Ignore launch errors during shutdown.
      }
    }

    if (this.context) {
      await this.context.close().catch(() => {});
      this.context = null;
    }

    if (this.browser) {
      await this.browser.close().catch(() => {});
      this.browser = null;
    }

    this.launchPromise = null;
    this.closing = false;
  }

  private async getContext(): Promise<BrowserContext> {
    if (this.closing) {
      throw new Error("Browser manager is shutting down");
    }

    if (this.context) {
      return this.context;
    }

    if (this.launchPromise) {
      return this.launchPromise;
    }

    this.launchPromise = this.launch().finally(() => {
      this.launchPromise = null;
    });

    return this.launchPromise;
  }

  private async launch(): Promise<BrowserContext> {
    try {
      this.browser = await chromium.launch({ headless: true });
      this.context = await this.browser.newContext();
      return this.context;
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      throw new Error(
        `Failed to launch browser. Did you run 'npx playwright install'? ${message}`
      );
    }
  }
}
