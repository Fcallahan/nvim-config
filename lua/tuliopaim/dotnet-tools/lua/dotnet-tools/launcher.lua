-- EMServices Billing Rules Interactive Launcher
-- Provides Rider-like "run/debug" menu for .NET projects

local M = {}
local helpers = require("dotnet-tools.helpers")

-- Profile definitions for EMServices Billing Rules
M.launch_profiles = {
    {
        name = "Web API - Development (http://localhost:5156)",
        key = "api-dev",
        project = "EMServices.BillingRules",
        profile = "http-Development",
        env = {
            ASPNETCORE_ENVIRONMENT = "Development",
        },
        port = 5156,
        description = "Web API with local PostgreSQL and Redis",
    },
    {
        name = "Web API - DevRemote (http://localhost:5156 + AWS)",
        key = "api-devremote",
        project = "EMServices.BillingRules",
        profile = "http-DevRemote",
        env = {
            ASPNETCORE_ENVIRONMENT = "DevRemote",
        },
        port = 5156,
        description = "Web API with remote AWS services",
    },
    {
        name = "Worker Service - Development",
        key = "worker-dev",
        project = "Emservices.WorkerApp",
        profile = "Emservices.WorkerApp",
        env = {
            DOTNET_ENVIRONMENT = "Development",
        },
        description = "Background worker for EMSmart2 events",
    },
    {
        name = "API + Worker - Both Services",
        key = "compound",
        compound = true,
        services = { "api-dev", "worker-dev" },
        description = "Run both Web API and Worker together",
    },
}

-- Find the nearest .sln file by walking up the directory tree
M.find_solution = function()
    local current_file = vim.fn.expand("%:p")
    if current_file == "" then
        current_file = vim.fn.getcwd()
    end

    local search_dir = vim.fn.fnamemodify(current_file, ":h")

    -- Walk up the directory tree looking for .sln file
    for _ = 1, 10 do  -- Limit to 10 levels up
        local sln_files = vim.fn.glob(search_dir .. "/*.sln", false, true)
        if #sln_files > 0 then
            return sln_files[1]
        end

        local parent = vim.fn.fnamemodify(search_dir, ":h")
        if parent == search_dir then
            break  -- Reached root
        end
        search_dir = parent
    end

    return nil
end

-- Get the solution directory
M.get_solution_dir = function()
    local sln_path = M.find_solution()
    if not sln_path then
        vim.notify("No .sln file found. Make sure you're in the Billing Rules project.", vim.log.levels.ERROR)
        return nil
    end
    return vim.fn.fnamemodify(sln_path, ":h")
end

-- Find the project file for a given project name
M.find_project_file = function(solution_dir, project_name)
    local search_pattern = solution_dir .. "/src/" .. project_name .. "/" .. project_name .. ".csproj"
    if vim.fn.filereadable(search_pattern) == 1 then
        return search_pattern
    end

    -- Fallback: search recursively
    local cmd = string.format('find "%s" -type f -name "%s.csproj"', solution_dir, project_name)
    local result = vim.fn.systemlist(cmd)
    if #result > 0 then
        return result[1]
    end

    return nil
end

-- Get the DLL path for a project
M.get_dll_path = function(solution_dir, project_name)
    local project_file = M.find_project_file(solution_dir, project_name)
    if not project_file then
        return nil
    end

    local project_dir = vim.fn.fnamemodify(project_file, ":h")
    local dll_path = project_dir .. "/bin/Debug/net9.0/" .. project_name .. ".dll"

    if vim.fn.filereadable(dll_path) == 1 then
        return dll_path
    end

    return nil
end

-- Build the project
M.build_project = function(project_file)
    vim.notify("Building project: " .. vim.fn.fnamemodify(project_file, ":t:r"), vim.log.levels.INFO)

    local cmd = string.format('dotnet build "%s" -c Debug', project_file)
    local output = vim.fn.system(cmd)
    local exit_code = vim.v.shell_error

    if exit_code == 0 then
        vim.notify("✔️  Build successful", vim.log.levels.INFO)
        return true
    else
        vim.notify("❌ Build failed:\n" .. output, vim.log.levels.ERROR)
        return false
    end
end

-- Run a project profile
M.run_profile = function(profile_config)
    local solution_dir = M.get_solution_dir()
    if not solution_dir then
        return
    end

    local project_file = M.find_project_file(solution_dir, profile_config.project)
    if not project_file then
        vim.notify("Project not found: " .. profile_config.project, vim.log.levels.ERROR)
        return
    end

    -- Ask to build first
    local should_build = vim.fn.confirm("Should I rebuild the project first?", "&Yes\n&No", 2)
    if should_build == 1 then
        if not M.build_project(project_file) then
            return
        end
    end

    -- Construct environment variables
    local env_vars = {}
    for key, value in pairs(profile_config.env) do
        table.insert(env_vars, string.format("%s=%s", key, value))
    end
    local env_str = table.concat(env_vars, " ")

    -- Construct the dotnet run command
    local cmd = string.format(
        '%s dotnet run --project "%s" --launch-profile "%s"',
        env_str,
        project_file,
        profile_config.profile
    )

    -- Run in a terminal buffer
    vim.cmd("split")
    vim.cmd("terminal " .. cmd)
    vim.cmd("startinsert")

    -- Show info message
    local message = string.format(
        "🚀 Starting: %s\n%s",
        profile_config.name,
        profile_config.description
    )
    if profile_config.port then
        message = message .. "\n📡 Port: " .. profile_config.port
    end
    vim.notify(message, vim.log.levels.INFO)
end

-- Debug a project profile using nvim-dap
M.debug_profile = function(profile_config)
    local solution_dir = M.get_solution_dir()
    if not solution_dir then
        return
    end

    local project_file = M.find_project_file(solution_dir, profile_config.project)
    if not project_file then
        vim.notify("Project not found: " .. profile_config.project, vim.log.levels.ERROR)
        return
    end

    -- Ask to build first
    local should_build = vim.fn.confirm("Should I rebuild the project first?", "&Yes\n&No", 1)
    if should_build == 1 then
        if not M.build_project(project_file) then
            return
        end
    end

    -- Get DLL path
    local dll_path = M.get_dll_path(solution_dir, profile_config.project)
    if not dll_path then
        vim.notify("DLL not found. Build the project first.", vim.log.levels.ERROR)
        return
    end

    -- Create DAP configuration on the fly
    local dap_config = {
        type = "coreclr",
        name = profile_config.name,
        request = "launch",
        program = dll_path,
        cwd = vim.fn.fnamemodify(project_file, ":h"),
        env = profile_config.env,
        stopAtEntry = false,
    }

    -- Start DAP
    local dap = require("dap")
    dap.run(dap_config)

    vim.notify("🐛 Debugging: " .. profile_config.name, vim.log.levels.INFO)
end

-- Run compound configuration (API + Worker)
M.run_compound = function(profile_config, is_debug)
    for _, service_key in ipairs(profile_config.services) do
        -- Find the service profile
        local service_profile = nil
        for _, p in ipairs(M.launch_profiles) do
            if p.key == service_key then
                service_profile = p
                break
            end
        end

        if service_profile then
            if is_debug then
                M.debug_profile(service_profile)
            else
                M.run_profile(service_profile)
            end
            -- Small delay between launches
            vim.cmd("sleep 500m")
        end
    end
end

-- Show the interactive launcher menu
M.show_launcher = function()
    -- Check if Snacks is available
    local snacks_ok, _ = pcall(require, "snacks")
    if not snacks_ok then
        vim.notify("Snacks.nvim not found. Using fallback menu.", vim.log.levels.WARN)
        M.show_fallback_launcher()
        return
    end

    -- Prepare items for Snacks picker
    local items = {}
    for _, profile in ipairs(M.launch_profiles) do
        table.insert(items, {
            text = profile.name,
            profile = profile,
        })
    end

    -- Show picker
    Snacks.picker.pick({
        prompt = "Select Launch Profile",
        items = items,
        format = function(item)
            return item.text
        end,
    }, function(selected)
        if not selected then
            return
        end

        local profile = selected.profile

        -- Ask: Run or Debug?
        local action_items = {
            { text = "▶️  Run", action = "run" },
            { text = "🐛 Debug", action = "debug" },
        }

        Snacks.picker.pick({
            prompt = "Run or Debug?",
            items = action_items,
            format = function(item)
                return item.text
            end,
        }, function(action_selected)
            if not action_selected then
                return
            end

            local is_debug = action_selected.action == "debug"

            if profile.compound then
                M.run_compound(profile, is_debug)
            else
                if is_debug then
                    M.debug_profile(profile)
                else
                    M.run_profile(profile)
                end
            end
        end)
    end)
end

-- Fallback launcher using vim.ui.select (if Snacks not available)
M.show_fallback_launcher = function()
    local profile_names = {}
    for _, profile in ipairs(M.launch_profiles) do
        table.insert(profile_names, profile.name)
    end

    vim.ui.select(profile_names, {
        prompt = "Select Launch Profile:",
    }, function(choice, idx)
        if not choice then
            return
        end

        local profile = M.launch_profiles[idx]

        vim.ui.select({ "▶️  Run", "🐛 Debug" }, {
            prompt = "Action:",
        }, function(action)
            if not action then
                return
            end

            local is_debug = action == "🐛 Debug"

            if profile.compound then
                M.run_compound(profile, is_debug)
            else
                if is_debug then
                    M.debug_profile(profile)
                else
                    M.run_profile(profile)
                end
            end
        end)
    end)
end

-- Setup function (called from plugin config)
M.setup = function(opts)
    opts = opts or {}

    -- Allow users to override/extend launch profiles
    if opts.profiles then
        M.launch_profiles = vim.tbl_deep_extend("force", M.launch_profiles, opts.profiles)
    end

    -- Create user command
    vim.api.nvim_create_user_command("RunLauncher", function()
        M.show_launcher()
    end, { desc = "Open interactive .NET launcher" })

    -- Optional: Auto-detect and add custom launch profiles from launchSettings.json
    -- This can be implemented later if needed
end

return M
