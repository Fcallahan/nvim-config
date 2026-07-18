return {
    "letieu/jira.nvim",
    cmd = "Jira",  -- Lazy load on :Jira command
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>jo", "<cmd>Jira<CR>", desc = "[J]ira [O]pen board" },
        { "<leader>jc", "<cmd>Jira create<CR>", desc = "[J]ira [C]reate issue" },
        {
            "<leader>jm",
            function()
                local issue = vim.fn.input("Issue key: ")
                if issue ~= "" then
                    vim.cmd("Jira info " .. issue)
                end
            end,
            desc = "[J]ira view issue by key",
        },
        {
            "<leader>jq",
            function()
                local query = vim.fn.input("JQL query: ")
                if query ~= "" then
                    vim.cmd("Jira query " .. query)
                end
            end,
            desc = "[J]ira custom [Q]uery",
        },
    },
    opts = {
        jira = {
            -- Keep env vars available for local fallback auth compatibility.
            base = vim.env.JIRA_BASE_URL,
            email = vim.env.JIRA_EMAIL,
            token = vim.env.JIRA_TOKEN,
            type = vim.env.JIRA_AUTH_TYPE,
            limit = 200,  -- Max issues to fetch per query
            default_project = "EMSVC",  -- Default project key
        },
        -- Custom JQL queries for quick access
        queries = {
            my_open = "assignee = currentUser() AND resolution = Unresolved ORDER BY priority DESC",
            recent = "updated >= -7d ORDER BY updated DESC",
            sprint = "sprint in openSprints() ORDER BY priority DESC",
        },
        -- Project-specific settings (add your project keys as needed)
        projects = {
            -- Example: Configure custom fields if needed
            -- ["EMSVC"] = {
            --     story_points_field = "customfield_10026",
            --     acceptance_criteria_field = "customfield_10027",
            -- },
        },
    },
    config = function(_, opts)
        require("jira").setup(opts)

        local auth = require("jira.common.auth")
        if auth._env_fallback_patched then
            return
        end

        local original_load = auth.load

        auth.load = function()
            local stored = original_load() or {}
            local merged = {
                base = stored.base or vim.env.JIRA_BASE_URL,
                email = stored.email or vim.env.JIRA_EMAIL,
                token = stored.token or vim.env.JIRA_TOKEN,
                type = (stored.type or vim.env.JIRA_AUTH_TYPE or "basic"):lower(),
            }

            local has_base = merged.base and merged.base ~= ""
            local has_token = merged.token and merged.token ~= ""
            local is_pat = merged.type == "pat"
            local has_email = merged.email and merged.email ~= ""

            if not has_base or not has_token or (not is_pat and not has_email) then
                return nil
            end

            return merged
        end

        auth._env_fallback_patched = true
    end,
}
