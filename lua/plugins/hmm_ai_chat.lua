return {
    {
        dir = "~/HmmAiChat",
        name = "HmmAiChat",
        cmd = {
            "HmmAiChatAsk",
            "HmmAiChatToggle",
            "HmmAiChatNew",
        },
        keys = {
            { "<leader>cc", mode = "x", desc = "HmmAiChat: ask about selection" },
            { "<leader>ca", function() vim.cmd("HmmAiChatAsk") end, mode = "n", desc = "HmmAiChat: ask a question" },
            { "<leader>ct", mode = "n", desc = "HmmAiChat: toggle chat" },
            { "<leader>cn", mode = "n", desc = "HmmAiChat: new chat" },
        },
        config = function()
            -- Prefer shell env var, fall back to pi's OpenRouter key from auth.json
            local key = os.getenv("OPENROUTER_API_KEY")
            if not key or key == "" then
                local ok, lines = pcall(vim.fn.readfile, vim.fn.expand("~/.pi/agent/auth.json"))
                if ok and lines then
                    local ok2, parsed = pcall(vim.json.decode, table.concat(lines, "\n"))
                    if ok2 and parsed and parsed.openrouter and parsed.openrouter.key then
                        key = parsed.openrouter.key
                    end
                end
            end
            vim.env.OPENROUTER_API_KEY = key or ""
            require("hmm_ai_chat").setup({
                model = "deepseek/deepseek-chat",
                keymaps = {
                    ask_visual = "<leader>cc",
                    toggle = "<leader>ct",
                    new_chat = "<leader>cn",
                },
                window = {
                    width = 80,
                },
            })
        end,
    },
}
