import type { Plugin } from "@opencode-ai/plugin"

const PLUGIN_NAME = "chrome-devtools-warmup"
const MCP_COMMAND = [
  "npx",
  "-y",
  "chrome-devtools-mcp@latest",
  "--browser-url=http://127.0.0.1:9222",
  "--no-category-emulation",
]
const MCP_NAME = "chrome-devtools"

async function log(client: any, level: "info" | "warn" | "error", message: string) {
  await client.app
    .log({
      service: PLUGIN_NAME,
      level,
      message,
    })
    .catch(() => {})
}

async function ensureMcp(client: any, directory: string): Promise<void> {
  const statusResult = await client.mcp.status({ query: { directory } })
  const status = statusResult.data?.[MCP_NAME]

  if (!status || status.status === "disabled") {
    await client.mcp.add({
      body: {
        name: MCP_NAME,
        config: {
          type: "local",
          command: MCP_COMMAND,
          enabled: true,
        },
      },
      query: { directory },
    })
  }

  await client.mcp.connect({
    path: { name: MCP_NAME },
    query: { directory },
  })

  const finalStatus = await client.mcp.status({ query: { directory } })
  const connected = finalStatus.data?.[MCP_NAME]?.status === "connected"
  if (!connected) {
    throw new Error(`MCP status is ${finalStatus.data?.[MCP_NAME]?.status ?? "unknown"}`)
  }
}

export const ChromeDevtoolsPlugin: Plugin = async ({ client, directory }) => {
  return {
    "command.execute.before": async (input) => {
      if (input.command !== "chrome-devtools") return

      try {
        await ensureMcp(client, directory)
        await log(client, "info", "chrome-devtools MCP enabled")
      } catch (err) {
        await log(client, "error", `failed to enable MCP: ${err}`)
      }
    },
  }
}

export default ChromeDevtoolsPlugin
