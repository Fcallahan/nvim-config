return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" },
    },
    cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatClose",
        "CopilotChatToggle",
        "CopilotChatReset",
    },
    keys = {
        { "<leader>cb", mode = "v", desc = "AI (Copilot): Find bugs in selection" },
        { "<leader>ce", mode = "v", desc = "AI (Copilot): Explain code line-by-line" },
        { "<leader>cc", mode = "v", desc = "AI (Copilot): Custom prompt for selection" },
    },
    config = function()
        local chat = require("CopilotChat")

        -- Setup CopilotChat
        chat.setup({
            debug = false,
            show_help = "yes",
            prompts = {
                -- Custom prompts (verbatim from ChatGPT config)
                FindBugs = {
                    prompt = "Find potential bugs, edge cases, race conditions, error handling gaps, performance pitfalls, and security issues in the selected code. Be specific, cite the exact lines/expressions, and propose concrete fixes.",
                },
                ExplainDetailed = {
                    prompt = "Carefully explain the selected code line by line. For each line or logical block, describe what it does and why it exists. Then summarize the overall goal this code achieves, the inputs/outputs, and any important assumptions.",
                },
            },
            window = {
                layout = 'float',
                width = 0.8,
                height = 0.8,
                border = 'rounded',
            },
        })

        -- Helper functions for visual-mode keybindings
        local function find_bugs_visual()
            local prompt = "Find potential bugs, edge cases, race conditions, error handling gaps, performance pitfalls, and security issues in the selected code. Be specific, cite the exact lines/expressions, and propose concrete fixes."
            chat.ask(prompt, {
                selection = require("CopilotChat.select").visual,
            })
        end

        local function explain_visual()
            local prompt = "Carefully explain the selected code line by line. For each line or logical block, describe what it does and why it exists. Then summarize the overall goal this code achieves, the inputs/outputs, and any important assumptions."
            chat.ask(prompt, {
                selection = require("CopilotChat.select").visual,
            })
        end

        local function custom_prompt_visual()
            vim.ui.input({
                prompt = "🤖 Ask Copilot: ",
            }, function(input)
                if input and input ~= "" then
                    chat.ask(input, {
                        selection = require("CopilotChat.select").visual,
                    })
                end
            end)
        end

        -- Safe mapping helper with conflict detection
        local function safe_vmap(lhs, rhs, desc)
            local existing = vim.fn.maparg(lhs, 'v')
            if existing ~= '' then
                vim.notify("⚠️  CopilotChat: " .. lhs .. " already mapped, trying fallback...", vim.log.levels.WARN)
                return nil
            end

            vim.keymap.set('v', lhs, rhs, {
                noremap = true,
                silent = true,
                desc = desc
            })

            vim.notify("✓ CopilotChat: Mapped " .. lhs .. " - " .. desc, vim.log.levels.INFO)
            return lhs
        end

        -- Set up keybindings with fallbacks
        local bug_key = safe_vmap('<leader>cb', find_bugs_visual, 'AI (Copilot): Find bugs in selection')
        if not bug_key then
            bug_key = safe_vmap('<leader>ab', find_bugs_visual, 'AI (Copilot): Find bugs in selection')
                or safe_vmap('<leader>gb', find_bugs_visual, 'AI (Copilot): Find bugs in selection')
                or safe_vmap('<leader>zb', find_bugs_visual, 'AI (Copilot): Find bugs in selection')
        end

        local explain_key = safe_vmap('<leader>ce', explain_visual, 'AI (Copilot): Explain code line-by-line + overall goal')
        if not explain_key then
            explain_key = safe_vmap('<leader>ae', explain_visual, 'AI (Copilot): Explain code line-by-line + overall goal')
                or safe_vmap('<leader>ge', explain_visual, 'AI (Copilot): Explain code line-by-line + overall goal')
                or safe_vmap('<leader>ze', explain_visual, 'AI (Copilot): Explain code line-by-line + overall goal')
        end

        local custom_key = safe_vmap('<leader>cc', custom_prompt_visual, 'AI (Copilot): Custom prompt for selection')
        if not custom_key then
            custom_key = safe_vmap('<leader>ac', custom_prompt_visual, 'AI (Copilot): Custom prompt for selection')
                or safe_vmap('<leader>gc', custom_prompt_visual, 'AI (Copilot): Custom prompt for selection')
                or safe_vmap('<leader>zc', custom_prompt_visual, 'AI (Copilot): Custom prompt for selection')
        end

        -- Store final mappings for reference
        _G.copilot_chat_mappings = {
            bug_finder = bug_key or '<leader>cb',
            explainer = explain_key or '<leader>ce',
            custom = custom_key or '<leader>cc',
        }
    end,
}
