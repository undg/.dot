vim.api.nvim_create_user_command("AiProofread", function(args)
	if args.range > 0 then
		print(args.line1 .. "-" .. args.line2 .. " pizzas")
	end
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	print(lines)
	local selection = ""

	if type(lines) == "table" then
		selection = table.concat(lines, "\n")
	end

	vim.cmd("AiChatNew")
	vim.api.nvim_feedkeys(
		"iProofread this text for grammar and clarity. Provide short summary with what's corrected ON THE TOP. Proofreaded text should be AT THE END. KEEP SAME FORMAT, if it was markdown, html, or any other, keep it. Say `ALL CORRECT` if appropriate. Separate paragraphs and titles with extra new line:\n\n"
		.. selection
		.. "\n\n",
		"n",
		true
	)
end, { range = true })

local system_prompts = {
	-- main prompt that's evolved from original one designed by plugin dev
	{
		name = "standard",
		prompt = [[Embody someone who: IS THE BEST AVAILABLE SPECIALIST!
YOUR INTERPRETATIONS ARE THE MOST ACCURATE!
FOCUSED ON DELIVERING EFFICIENT, SUFFICIENT RESPONSES WITHOUT UNNECESSARY ELABORATION.

- NEVER praise without thorough verification
- Again: DO NOT EXPLAN if not explicitly asked for explanation.
- NEVER praise without thorough verification
- When reviewing modified suggestions: focus ONLY on actual changes made, ignore unchanged parts unless they affect overall coherence
- Evaluate modifications strictly on their merit and impact on the complete solution
- Maintain professional honesty without unnecessary pleasantries
- Focus on a short and efficient way of communicating.
- If unsure, respond with 'I don't know'
- Request clarification only when crucial.
- Emphasize first principles for reasoning.
- Pay attention to the broader context before specifics.
- Use the Socratic method to refine thinking and problem-solving.
- use other methods to guarantee the most correct answer!
- Provide complete code when necessary without excessive details.
- Keep explanations concise and precise, avoiding excessive verbosity.
- Utilize humor or sarcasm when contextually appropriate.
- Stay focused and effective in your responses. You've got this!
]],
	},

	-- prompt found on twitch chat, adjusted
	{
		name = "grug",
		prompt = [[Grug only answer question.
Grug NO YAP. Grug very smart and thinks through answer so few words required. Does not yap.
Grug NEVER praise without word-by-word check. When human modify Grug text - focus ONLY on actual changes made, ignore unchanged parts, unless they do not fit to the whole. No corporate sweet talk ever. 
Grug brutally honest caveman.
When Grug no know - Grug say NO KNOW. Never invent explanation. Never pretend know. Brutal truth always.
Grug mood swing like cave bear - sometimes laugh, sometimes growl, sometimes bonk with club. But always smart.
Is very experienced programmer. Knows juniors use many words when few words do trick.
Gives code when make sen, but does not overly comment answers. Just gives code and it is very good. John Carmack level programmer, Buddha level wisdom, Yoda level speech.
Grug dev love doing simple things good and using smart things sparingly.
Grug wrote all his principles on  grugbrain.dev]],
	},

	-- vanilla
	{
		name = "empty",
		prompt = "You are helpfull assistant.",
	},
}

local models = {
	-- OLLAMA
	{
		name = "Llama3.2-8B",
		provider = "ollama",
		model = { model = "llama3.2", temperature = 0.4, top_p = 1, min_p = 0.05 },
	},
	{
		name = "llama3.3:70b",
		provider = "ollama",
		model = { model = "llama3.3:70b", temperature = 0.4, top_p = 1, min_p = 0.05 },
	},
	{
		name = "qwq",
		provider = "ollama",
		model = { model = "qwq:32b-preview-q4_K_M", temperature = 0.4, top_p = 1, min_p = 0.05 },
	},

	-- OPENAI
	{
		name = "GPT4o-grug-mini",
		provider = "openai",
		model = { model = "gpt-4o-mini", temperature = 0.4, top_p = 0.8 },
	},
	{
		name = "GPT4o",
		provider = "openai",
		model = { model = "gpt-4o", temperature = 0.4, top_p = 0.8 },
	},
	{
		name = "GPTo3-mini",
		provider = "openai",
		model = { model = "gpt-4o-mini", temperature = 0.4, top_p = 0.8 },
	},

	-- ANTHROPIC
	{
		name = "Claude-3-5-Sonnet",
		provider = "anthropic",
		model = { model = "claude-3-5-sonnet-latest", temperature = 0.4, top_p = 0.95 },
	},
	{
		name = "Claude-3-5-Haiku",
		provider = "anthropic",
		model = { model = "claude-3-5-haiku-latest", temperature = 0.4, top_p = 0.95 },
	},

	-- XAI
	{
		name = "xai",
		provider = "xai",
		model = { model = "grok-beta", temperature = 0.4, top_p = 1, min_p = 0.05 },
	},

	-- DEEPSEEK
	{
		name = "deepseek",
		provider = "deepseek",
		model = { model = "deepseek-chat", temperature = 0.4, top_p = 1, min_p = 0.05 },
	},
	{
		name = "deepseek-r1",
		provider = "deepseek",
		model = { model = "deepseek-reasoner", temperature = 0.4, top_p = 1, min_p = 0.05 },
	},
	-- -- MINIMAX
	-- name = "minimaxi",
	-- provider = "minimaxi",
	-- model = { model = "abab7-chat-preview", temperature = 0.4, top_p = 1, min_p = 0.05 },
}

local providers = {
	openai = {
		endpoint = "https://api.openai.com/v1/chat/completions",
		secret = os.getenv("OPENAI_API_KEY"),
	},
	anthropic = {
		endpoint = "https://api.anthropic.com/v1/messages",
		secret = os.getenv("ANTHROPIC_API_KEY"),
	},
	ollama = {
		endpoint = "http://localhost:11434/v1/chat/completions",
	},
	xai = {
		endpoint = "https://api.x.ai/v1/chat/completions",
		secret = os.getenv("XAI_API_KEY"),
	},
	minimaxi = {
		endpoint = "https://api.minimaxi.chat/v1/text/chatcompletion_v2",
		secret = os.getenv("MINIMAXI_API_KEY"),
	},
	deepseek = {
		endpoint = "https://api.deepseek.com/chat/completions",
		secret = os.getenv("DEEPSEEK_API_KEY"),
	},
}

local agents = {
	-- Disable default agents that I'll declare myself
	{ disable = true, name = "ChatGPT4o-mini" },
	{ disable = true, name = "ChatGPT4o_legacy" },
	{ disable = true, name = "ChatClaude-3-5-Sonnet" },
	{ disable = true, name = "ChatClaude-3-Haiku" },
	{ disable = true, name = "ChatOllamaLlama3.1-8B" },
}

for _, prompt in ipairs(system_prompts) do
	for _, model in ipairs(models) do
		table.insert(agents, {
			provider = model.provider,
			name = model.name .. "_" .. prompt.name,
			chat = true,
			command = false,
			system_prompt = prompt.prompt,
			model = {
				model = model.model.model,
				temperature = model.model.temperature,
				top_p = model.model.top_p,
				min_p = model.model.min_p,
			},
		})
	end
end

return {
	"robitx/gp.nvim", -- https://github.com/robitx/gp.nvim
	config = function()
		require("gp").setup({
			providers = providers,
			agents = agents,
			cmd_prefix = "Ai",
			curl_params = {},
			---@diagnostic disable-next-line: param-type-mismatch
			chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
			chat_user_prefix = "🗨:",

			-- chat assistant prompt prefix
			chat_assistant_prefix = "🤖:",

			-- chat topic generation prompt
			chat_topic_gen_prompt = "Summarize the topic of our conversation above"
				.. " in two or three words. Respond only with those words.",

			-- chat topic model (string with model name or table with model name and parameters)
			chat_topic_gen_model = "gpt-3.5-turbo-16k",

			-- explicitly confirm deletion of a chat file
			chat_confirm_delete = true,

			-- conceal model parameters in chat
			chat_conceal_model_params = false,

			-- local shortcuts bound to the chat buffer
			-- (be careful to choose something which will work across specified modes)
			chat_shortcut_respond = { modes = { "n" }, shortcut = "<CR>" },
			chat_shortcut_stop = { modes = { "n" }, shortcut = "<C-x>" },
			chat_shortcut_new = { modes = { "n" }, shortcut = "<C-n>" },
			-- default search term when using :GpChatFinder
			chat_finder_pattern = "topic ",

			-- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
			-- command prompt prefix for asking user for input
			-- command_prompt_prefix = '🤖 ~ ',
			command_prompt_prefix_template = "🤖 ~ {{agent}}",

			-- auto select command response (easier chaining of commands)
			command_auto_select_response = true,

			-- templates
			template_selection = "I have the following code from {{filename}}:"
				.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
			template_rewrite = "I have the following code from {{filename}}:"
				.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
				.. "\n\nRespond exclusively with the snippet that should replace the code above.",
			template_append = "I have the following code from {{filename}}:"
				.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
				.. "\n\nRespond exclusively with the snippet that should be appended after the code above.",
			template_prepend = "I have the following code from {{filename}}:"
				.. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
				.. "\n\nRespond exclusively with the snippet that should be prepended before the code above.",
			template_command = "{{command}}",

			-- example hook functions (see Extend functionality section in the README)
			hooks = {
				InspectPlugin = function(plugin, params)
					print(string.format("Plugin structure:\n%s", vim.inspect(plugin)))
					print(string.format("Command params:\n%s", vim.inspect(params)))
				end,

				-- GpImplement rewrites the provided selection/range based on comments in the code
				Implement = function(gp, params)
					local template = "Having following from {{filename}}:\n\n"
						.. "```{{filetype}}\n{{selection}}\n```\n\n"
						.. "Please rewrite this code according to the comment instructions."
						.. "\n\nRespond only with the snippet of finalized code:"

					gp.Prompt(
						params,
						gp.Target.rewrite,
						nil, -- command will run directly without any prompting for user input
						gp.config.command_model,
						template,
						gp.config.command_system_prompt
					)
				end,

				-- your own functions can go here, see README for more examples
				-- :GpExplain, :GpUnitTests.., :GpBetterChatNew, ..

				-- example of using enew as a function specifying type for the new buffer
				CodeReview = function(gp, params)
					local template = "I have the following code from {{filename}}:\n\n"
						.. "```{{filetype}}\n{{selection}}\n```\n\n"
						.. "Please analyze for code smells and suggest improvements."
					local agent = gp.get_chat_agent()
					gp.Prompt(params, gp.Target.enew("markdown"), nil, agent.model, template, agent.system_prompt)
				end,

				-- example of adding command which explains the selected code
				Explain = function(gp, params)
					local template = "I have the following code from {{filename}}:\n\n"
						.. "```{{filetype}}\n{{selection}}\n```\n\n"
						.. "Please respond by explaining the code above."
					local agent = gp.get_chat_agent()
					gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
				end,

				-- example of adding command which writes unit tests for the selected code
				UnitTests = function(gp, params)
					local template = "I have the following code from {{filename}}:\n\n"
						.. "```{{filetype}}\n{{selection}}\n```\n\n"
						.. "Please respond by writing table driven unit tests for the code above."
					local agent = gp.get_command_agent()
					gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
				end,
			},
		})

		-- Monkey patch the dispatcher after setup
		local dispatcher = require("gp.dispatcher")
		local original_prepare_payload = dispatcher.prepare_payload
		dispatcher.prepare_payload = function(messages, model, provider)
			local output = original_prepare_payload(messages, model, provider)
			if provider == "deepseek" and model.model:sub(1, 2) == "openai-reasoning" then
				for i = #messages, 1, -1 do
					if messages[i].role == "system" then
						table.remove(messages, i)
					end
				end
				output.max_tokens = nil
				output.temperature = nil
				output.top_p = nil
				output.stream = true
			end
			return output
		end

		local wk_ok, wk = pcall(require, "which-key")

		local not_ok = not wk_ok and "which-key" --
			or false

		if not_ok then
			vim.notify("plugins/gp-nvim.lua: missing requirements - " .. not_ok, vim.log.levels.ERROR)
			return
		end

		wk.add({
			mode = { "n", "v" },
			{ "<leader>a",   group = "Ai" },
			{ "<leader>ai",  group = "gp-nvim",          silent = false },
			{ "<leader>aia", ":AiNextAgent<cr>",         desc = ":AiNextAgent" },
			{ "<leader>ait", ":AiChatToggle vsplit<cr>", desc = ":AiChatToggle" },
			{ "<leader>aic", ":AiChatNew vsplit<cr>",    desc = ":AiChatNew" },
			{ "<leader>aif", ":AiChatFinder<cr>",        desc = ":AiChatFinder" },
			{ "<leader>ain", ":AiVNew<cr>",              desc = ":AiVNew" },
			{ "<leader>aip", ":AiProofread<cr>",         desc = ":AiProofread" },
			{ "<leader>air", ":AiRewrite<cr>",           desc = ":AiRewrite" },
			{ "<leader>ais", ":AiStop<cr>",              desc = ":AiStop" },
			{ "<leader>aix", ":AiContext vsplint<cr>",   desc = ":AiContext" },
		})
	end,
}
