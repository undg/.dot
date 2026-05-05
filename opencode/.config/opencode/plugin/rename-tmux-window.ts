import type { Plugin, PluginInput } from "@opencode-ai/plugin"
import { tool } from "@opencode-ai/plugin"

const PLUGIN_NAME = "rename-tmux-window"

function decode(bytes: Uint8Array): string {
  return new TextDecoder().decode(bytes).trim()
}

async function log(
  client: PluginInput["client"],
  level: "info" | "warn" | "error",
  message: string,
  extra?: Record<string, unknown>,
) {
  await client.app
    .log({
      service: PLUGIN_NAME,
      level,
      message,
      extra,
    })
    .catch(() => {})
}

export const RenameTmuxWindowPlugin: Plugin = async ({ client, directory, $ }) => {
  return {
    tool: {
      "rename-tmux-window": tool({
        description: "Rename the current tmux window. Best effort only.",
        args: {
          name: tool.schema.string().describe("New name for the current tmux window"),
        },
        async execute(args, context) {
          if (!process.env.TMUX) {
            return "Skipped tmux rename: not running inside tmux"
          }

          const result = await $`tmux rename-window ${args.name}`.quiet().nothrow().cwd(directory)

          if (result.exitCode === 0) {
            await log(client, "info", "Renamed tmux window", {
              sessionID: context.sessionID,
              windowName: args.name,
            })
            return `Renamed current tmux window to: ${args.name}`
          }

          await log(client, "warn", "Failed to rename tmux window", {
            sessionID: context.sessionID,
            windowName: args.name,
            error: decode(result.stderr),
          })
          return "Skipped tmux rename"
        },
      }),
    },
  }
}

export default RenameTmuxWindowPlugin
