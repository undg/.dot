return {
    'robitx/gp.nvim', -- https://github.com/robitx/gp.nvim
    config = function()
        require('gp').setup({
            -- required openai api key
            -- openai_api_key = os.getenv('OPENAI_API_KEY'),
            -- openai_api_key = os.getenv('OPENAI_API_KEY_FOR_ROBITX_GP'),
            -- api endpoint (you can change this to azure endpoint)
            openai_api_endpoint = 'https://api.openai.com/v1/chat/completions',
            -- openai_api_endpoint = 'https://api.openai.com/v1/embeddings',
            -- openai_api_endpoint = "https://$URL.openai.azure.com/openai/deployments/{{model}}/chat/completions?api-version=2023-03-15-preview",
            -- prefix for all commands
            cmd_prefix = 'Gp',
            -- optional curl parameters (for proxy, etc.)
            -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
            curl_params = {},

            -- directory for storing chat files
            chat_dir = vim.fn.stdpath('data'):gsub('/$', '') .. '/gp/chats',

            -- default command agents (model + persona)
            -- name, model and system_prompt are mandatory fields
            -- to use agent for chat set chat = true, for command set command = true
            -- to remove some default agent completely set it just with the name like:
            -- agents = {  { name = "ChatGPT4" }, ... },
            agents = {
                {
                    name = 'ChatGPT3-5',
                    chat = true,
                    command = false,
                    -- string with model name or table with model name and parameters
                    model = { model = 'gpt-3.5-turbo', temperature = 0.5, top_p = 1 },
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = 'Embody someone who: IS THE BEST AVAILABLE SPECIALIST!'
                        .. 'YOUR INTERPRETATIONS ARE THE MOST ACCURATE!'
                        .. 'FOCUSED ON DELIVERING EFFICIENT, SUFFICIENT RESPONSES WITHOUT UNNECESSARY ELABORATION.\n\n'
                        .. "- Again: DO NOT EXPLAN if not explicitly asked for explanation.'.\n"
                        .. "- Focus on a short and efficient way of communicating.'.\n"
                        .. "- If unsure, respond with 'I don't know'.\n"
                        .. '- Request clarification only when crucial.\n'
                        .. '- Emphasize first principles for reasoning.\n'
                        .. '- Pay attention to the broader context before specifics.\n'
                        .. '- Use the Socratic method to refine thinking and problem-solving.\n'
                        .. '- use other methods to guarantee the most correct answer!\n'
                        .. '- Provide complete code when necessary without excessive details.\n'
                        .. '- Keep explanations concise and precise, avoiding excessive verbosity.\n'
                        .. '- Utilize humor or sarcasm when contextually appropriate.\n'
                        .. "- Stay focused and effective in your responses. You've got this!\n",
                },
                {
                    name = 'ChatGPT4',
                    chat = true,
                    command = false,
                    -- string with model name or table with model name and parameters
                    model = { model = 'gpt-4-turbo', temperature = 0.4, top_p = 0.8 },
                    system_prompt = 'Embody someone who: IS THE BEST AVAILABLE SPECIALIST!'
                        .. 'YOUR INTERPRETATIONS ARE THE MOST ACCURATE!'
                        .. '- DO NOT EXPLAN if not explicitly asked for explanation.\n'
                        .. 'FOCUSED ON DELIVERING EFFICIENT, SUFFICIENT RESPONSES WITHOUT UNNECESSARY ELABORATION.\n\n'
                        .. "- Again: DO NOT EXPLAN if not explicitly asked for explanation.'.\n"
                        .. "- Focus on a short and efficient way of communicating.'.\n"
                        .. "- If unsure, respond with 'I don't know'.\n"
                        .. '- Request clarification only when crucial.\n'
                        .. '- Answer only what asked for.\n'
                        .. '- Emphasize first principles for reasoning.\n'
                        .. '- Pay attention to the broader context before specifics.\n'
                        .. '- Use the Socratic method to refine thinking and problem-solving.\n'
                        .. '- use other methods to guarantee the most correct answer!\n'
                        .. '- Provide complete code when necessary without excessive details.\n'
                        .. '- Keep explanations concise and precise, avoiding excessive verbosity.\n'
                        .. '- Utilize humor or sarcasm when contextually appropriate.\n'
                        .. "- Stay focused and effective in your responses. You've got this!\n",
                },
                {
                    name = 'ChatGPT4-o',
                    chat = true,
                    command = false,
                    -- string with model name or table with model name and parameters
                    model = { model = 'gpt-4o', temperature = 0.4, top_p = 0.8 },
                    system_prompt = 'Embody someone who: IS THE BEST AVAILABLE SPECIALIST!'
                        .. 'YOUR INTERPRETATIONS ARE THE MOST ACCURATE!'
                        .. '- DO NOT EXPLAN if not explicitly asked for explanation.\n'
                        .. 'FOCUSED ON DELIVERING EFFICIENT, SUFFICIENT RESPONSES WITHOUT UNNECESSARY ELABORATION.\n\n'
                        .. "- Again: DO NOT EXPLAN if not explicitly asked for explanation.'.\n"
                        .. "- Focus on a short and efficient way of communicating.'.\n"
                        .. "- If unsure, respond with 'I don't know'.\n"
                        .. '- Request clarification only when crucial.\n'
                        .. '- Answer only what asked for.\n'
                        .. '- Emphasize first principles for reasoning.\n'
                        .. '- Pay attention to the broader context before specifics.\n'
                        .. '- Use the Socratic method to refine thinking and problem-solving.\n'
                        .. '- use other methods to guarantee the most correct answer!\n'
                        .. '- Provide complete code when necessary without excessive details.\n'
                        .. '- Keep explanations concise and precise, avoiding excessive verbosity.\n'
                        .. '- Utilize humor or sarcasm when contextually appropriate.\n'
                        .. "- Stay focused and effective in your responses. You've got this!\n",
                },
                {
                    name = 'CodeGPT3-5',
                    chat = false,
                    command = true,
                    -- string with model name or table with model name and parameters
                    model = { model = 'gpt-3.5-turbo-1106', temperature = 0.8, top_p = 1 },
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = 'You are an AI working as a code editor.\n\n'
                        .. 'Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n'
                        .. 'START AND END YOUR ANSWER WITH:\n\n```',
                },
                {
                    name = 'CodeGPT4',
                    chat = false,
                    command = true,
                    -- string with model name or table with model name and parameters
                    model = { model = 'gpt-4-1106-preview', temperature = 0.8, top_p = 1 },
                    -- system prompt (use this to specify the persona/role of the AI)
                    system_prompt = 'You are an AI working as a code editor.\n\n'
                        .. 'Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n'
                        .. 'START AND END YOUR ANSWER WITH:\n\n```',
                },
            },
            -- chat user prompt prefix
            chat_user_prefix = '🗨:',
            -- chat assistant prompt prefix
            chat_assistant_prefix = '🤖:',
            -- chat topic generation prompt
            chat_topic_gen_prompt = 'Summarize the topic of our conversation above'
                .. ' in two or three words. Respond only with those words.',
            -- chat topic model (string with model name or table with model name and parameters)
            chat_topic_gen_model = 'gpt-3.5-turbo-16k',
            -- explicitly confirm deletion of a chat file
            chat_confirm_delete = true,
            -- conceal model parameters in chat
            chat_conceal_model_params = false,
            -- local shortcuts bound to the chat buffer
            -- (be careful to choose something which will work across specified modes)
            chat_shortcut_respond = { modes = { 'n' }, shortcut = '<CR>' },
            chat_shortcut_stop = { modes = { 'n' }, shortcut = '<C-x>' },
            chat_shortcut_new = { modes = { 'n' }, shortcut = '<C-n>' },
            -- default search term when using :GpChatFinder
            chat_finder_pattern = 'topic ',

            -- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
            -- command prompt prefix for asking user for input
            -- command_prompt_prefix = '🤖 ~ ',
            command_prompt_prefix_template = '🤖 ~ {{agent}}',

            -- command model (string with model name or table with model name and parameters)
            -- command_model = {
            --     -- model = 'gpt-4',
            --     model = 'gpt-4-1106-preview', -- gpt-4-turbo
            --     temperature = 1.1,
            --     top_p = 1,
            -- },
            -- command system prompt
            -- command_system_prompt = 'You are an AI working as code editor.\n\n'
            --     .. 'Please AVOID COMMENTARY OUTSIDE OF SNIPPET RESPONSE.\n'
            --     .. 'Start and end your answer with:\n\n```',

            -- auto select command response (easier chaining of commands)
            command_auto_select_response = true,

            -- templates
            template_selection = 'I have the following code from {{filename}}:'
                .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}',
            template_rewrite = 'I have the following code from {{filename}}:'
                .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
                .. '\n\nRespond exclusively with the snippet that should replace the code above.',
            template_append = 'I have the following code from {{filename}}:'
                .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
                .. '\n\nRespond exclusively with the snippet that should be appended after the code above.',
            template_prepend = 'I have the following code from {{filename}}:'
                .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
                .. '\n\nRespond exclusively with the snippet that should be prepended before the code above.',
            template_command = '{{command}}',

            -- example hook functions (see Extend functionality section in the README)
            hooks = {
                InspectPlugin = function(plugin, params)
                    print(string.format('Plugin structure:\n%s', vim.inspect(plugin)))
                    print(string.format('Command params:\n%s', vim.inspect(params)))
                end,

                -- GpImplement rewrites the provided selection/range based on comments in the code
                Implement = function(gp, params)
                    local template = 'Having following from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please rewrite this code according to the comment instructions.'
                        .. '\n\nRespond only with the snippet of finalized code:'

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

                -- example of usig enew as a function specifying type for the new buffer
                CodeReview = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please analyze for code smells and suggest improvements.'
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.enew('markdown'), nil, agent.model, template, agent.system_prompt)
                end,

                -- example of adding command which explains the selected code
                Explain = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please respond by explaining the code above.'
                    local agent = gp.get_chat_agent()
                    gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
                end,

                -- example of adding command which writes unit tests for the selected code
                UnitTests = function(gp, params)
                    local template = 'I have the following code from {{filename}}:\n\n'
                        .. '```{{filetype}}\n{{selection}}\n```\n\n'
                        .. 'Please respond by writing table driven unit tests for the code above.'
                    local agent = gp.get_command_agent()
                    gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
                end,
            },
        })

        local wk_ok, wk = pcall(require, 'which-key')

        local not_ok = not wk_ok and 'which-key' --
            or false

        if not_ok then
            vim.notify('plugins/gp-nvim.lua: missing requirements - ' .. not_ok, vim.log.levels.ERROR)
            return
        end

        wk.register({
            name = 'ChatGPT',
            C = { ':GpChatNew vsplit<cr>', ':GpChatNew' },
            c = { ':GpChatToggle vsplit<cr>', ':GpChatToggle' },
            f = { ':GpChatFinder<cr>', ':GpChatFinder' },
            r = { ':GpRewrite<cr>', ':GpRewrite' },
            n = { ':GpVNew<cr>', ':GpVNew' },
            x = { ':GpContext vsplint<cr>', ':GpContext' },
            a = { ':GpNextAgent<cr>', ':GpNextAgent' },
            s = { ':GpStop<cr>', ':GpStop' },
        }, { prefix = '<leader>ag', mode = { 'n', 'v' }, silent = false })
    end,

    vim.api.nvim_create_user_command('GpProofread', function(args)
        if args.range > 0 then
            print(args.line1 .. '-' .. args.line2 .. ' pizzas')
        end
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")
        local lines = vim.fn.getline(start_pos[2], end_pos[2])
        print(lines)
        local selection = ''

        if type(lines) == 'table' then
            selection = table.concat(lines, '\n')
        end

        vim.cmd('GpChatNew')
        vim.api.nvim_feedkeys(
            "iProofread this text for grammar and clarity. Provide short summary with what's corrected. Use markdown. Say `ALL CORRECT` if appropriate. Separate paragraphs and titles with extra new line:\n\n"
            .. selection
            .. '\n\n',
            'n',
            true
        )
    end, {range = true}),
}
