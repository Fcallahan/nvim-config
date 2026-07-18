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
            -- Use the shell env var so ~/.zshrc changes take effect without editing this file
            vim.env.OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY") or vim.env.OPENROUTER_API_KEY
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
