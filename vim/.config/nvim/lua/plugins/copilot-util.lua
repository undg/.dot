local chat_ok, chat = pcall(require, "CopilotChat")
local copilot_ok = pcall(require, "copilot")

local not_ok = not chat_ok and "CopilotChat" --
	or not copilot_ok and "copilot"
	or false

if not_ok then
	vim.notify("copilot-utils.lua: requirement's missing - " .. not_ok, vim.log.levels.ERROR)
end

local M = {}

function M.copilot_callback(response)
	if vim.g.chat_title then
		print('early exit')
		return
	end

	local prompt = [[
Generate chat title in filepath-friendly format for:

```
%s
```

Output only the title and nothing else in your response.
]]

	-- Use AI to generate prompt title based on first AI response to user question
	chat.ask(vim.trim(prompt:format(response)), {
		headless = true, -- Disable updating chat buffer and history with this question
		callback = function(gen_response)
			vim.g.chat_title = os.date("%Y-%m-%d") .. "_" .. vim.trim(gen_response)

			print('Chat title set to: ' .. vim.g.chat_title)
			chat.save(vim.g.chat_title)
		end
	})
end

function M.reset_all()
	vim.g.chat_title = nil
	chat.reset()
end

function M.reset_title()
	vim.g.chat_title = nil
end

function M.show_title()
	if vim.g.chat_title then
		vim.notify(vim.g.chat_title, vim.log.levels.INFO, { title = "CopilotChat title" })
	else
		vim.notify('nil :(', vim.log.levels.INFO, { title = "CopilotChat title" })
	end
end

---save chat to file
function M.save_file()
	if vim.g.chat_title then
		chat.save(vim.g.chat_title)
		return
	end
end

return M
