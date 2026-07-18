local M = {}

local vault_dir = vim.fn.expand("~/vault")
local home_file = vault_dir .. "/DAILY NOTES.md"
local last_file_path = vim.fn.stdpath("state") .. "/td-last-file"
local td_win = nil

local function normalize(path)
    return vim.fn.fnamemodify(path, ":p")
end

local function ensure_vault()
    vim.fn.mkdir(vault_dir, "p")
end

local function file_exists(path)
    return vim.fn.filereadable(path) == 1
end

local function stat_time(path)
    local stat = vim.loop.fs_stat(path)
    if not stat then
        return 0
    end

    if stat.birthtime and stat.birthtime.sec and stat.birthtime.sec > 0 then
        return stat.birthtime.sec
    end

    if stat.ctime and stat.ctime.sec then
        return stat.ctime.sec
    end

    if stat.mtime and stat.mtime.sec then
        return stat.mtime.sec
    end

    return 0
end

local function note_files()
    ensure_vault()

    if not file_exists(home_file) then
        vim.fn.writefile({}, home_file)
    end

    local files = vim.fn.glob(vault_dir .. "/*.md", false, true)

    table.sort(files, function(a, b)
        local at = stat_time(a)
        local bt = stat_time(b)

        if at == bt then
            return a < b
        end

        return at < bt
    end)

    return files
end

local function current_note_index(files)
    local current = normalize(vim.api.nvim_buf_get_name(0))

    for index, file in ipairs(files) do
        if normalize(file) == current then
            return index
        end
    end

    return 1
end

local function read_last_file()
    local ok, lines = pcall(vim.fn.readfile, last_file_path)
    if not ok then
        return home_file
    end

    local path = lines[1]

    if path and path ~= "" and file_exists(path) then
        return path
    end

    return home_file
end

local function write_last_file(path)
    vim.fn.mkdir(vim.fn.fnamemodify(last_file_path, ":h"), "p")
    vim.fn.writefile({ path }, last_file_path)
end

local function slugify(title)
    local slug = title:lower()
    slug = slug:gsub("^%s+", ""):gsub("%s+$", "")
    slug = slug:gsub("[^%w%s%-_]", "")
    slug = slug:gsub("%s+", "-")
    slug = slug:gsub("%-+", "-")

    if slug == "" then
        return nil
    end

    return slug .. ".md"
end

function M.open(path)
    ensure_vault()

    path = path or read_last_file()

    if not file_exists(path) then
        vim.fn.writefile({}, path)
    end

    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.8)
    local row = 0
    local col = math.floor(vim.o.columns - width)
    local buf = vim.fn.bufadd(path)

    vim.fn.bufload(buf)
    write_last_file(path)

    if td_win and vim.api.nvim_win_is_valid(td_win) then
        vim.api.nvim_win_set_buf(td_win, buf)
        vim.api.nvim_set_current_win(td_win)
    else
        td_win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            style = "minimal",
            border = "rounded",
        })
    end

    vim.api.nvim_win_set_option(td_win, "winblend", 0)
    vim.api.nvim_win_set_option(td_win, "wrap", true)
    vim.api.nvim_win_set_option(td_win, "relativenumber", true)
    vim.api.nvim_win_set_option(td_win, "number", true)
end

function M.new()
    vim.ui.input({ prompt = "New TD page title: " }, function(title)
        if not title or title == "" then
            return
        end

        local filename = slugify(title)
        if not filename then
            vim.notify("TD page title must contain letters or numbers", vim.log.levels.WARN)
            return
        end

        local path = vault_dir .. "/" .. filename

        if file_exists(path) then
            vim.notify("TD page already exists: " .. filename, vim.log.levels.WARN)
        else
            vim.fn.writefile({ "# " .. title, "" }, path)
        end

        M.open(path)
    end)
end

function M.next()
    local files = note_files()
    if #files == 0 then
        M.open(home_file)
        return
    end

    local index = current_note_index(files)
    local next_index = (index % #files) + 1

    M.open(files[next_index])
end

function M.prev()
    local files = note_files()
    if #files == 0 then
        M.open(home_file)
        return
    end

    local index = current_note_index(files)
    local prev_index = ((index - 2) % #files) + 1

    M.open(files[prev_index])
end

function M.delete_current()
    local current = normalize(vim.api.nvim_buf_get_name(0))
    local home = normalize(home_file)
    local vault = normalize(vault_dir)

    if current == "" or current:sub(1, #vault) ~= vault then
        vim.notify("Current buffer is not a TD page", vim.log.levels.WARN)
        return
    end

    if current == home then
        vim.notify("Refusing to delete TD home page", vim.log.levels.WARN)
        return
    end

    local filename = vim.fn.fnamemodify(current, ":t")
    local answer = vim.fn.input("Delete TD page '" .. filename .. "'? Type y to confirm: ")

    if answer ~= "y" then
        vim.notify("TD page delete cancelled")
        return
    end

    local files = note_files()
    local index = current_note_index(files)
    local fallback = home_file

    if #files > 1 then
        fallback = files[((index - 2) % #files) + 1]
        if normalize(fallback) == current then
            fallback = home_file
        end
    end

    vim.cmd("bdelete! " .. vim.fn.bufnr(current))
    vim.fn.delete(current)
    vim.notify("Deleted TD page: " .. filename)
    M.open(fallback)
end

return M
