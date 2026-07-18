vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2

vim.opt.laststatus = 3

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = ""

-- Enable system clipboard
vim.opt.clipboard = "unnamedplus"

vim.opt.fillchars = { fold = " " }
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local uv = vim.uv or vim.loop
local sessions_dir = vim.fn.stdpath("state") .. "/sessions"

local function ensure_sessions_dir()
  if vim.fn.isdirectory(sessions_dir) == 0 then
    vim.fn.mkdir(sessions_dir, "p")
  end
end

local function resolve_session_scope()
  local cwd = vim.fn.getcwd()
  local git_root = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })
  local scope = cwd

  if vim.v.shell_error == 0 and git_root[1] ~= nil and git_root[1] ~= "" then
    scope = git_root[1]
  end

  if uv and uv.fs_realpath then
    return uv.fs_realpath(scope) or scope
  end

  return scope
end

local function current_session_file()
  local scope = resolve_session_scope()
  local scope_name = vim.fn.fnamemodify(scope, ":t"):gsub("[^%w_.-]", "_")
  local scope_hash = vim.fn.sha256(scope):sub(1, 16)

  return string.format("%s/%s-%s.vim", sessions_dir, scope_name, scope_hash)
end

local function save_worktree_session()
  ensure_sessions_dir()
  local session_file = current_session_file()
  vim.cmd("silent! mksession! " .. vim.fn.fnameescape(session_file))
  return session_file
end

local function load_worktree_session()
  local session_file = current_session_file()
  if vim.fn.filereadable(session_file) == 0 then
    return nil
  end

  vim.cmd("silent! source " .. vim.fn.fnameescape(session_file))
  return session_file
end

local function clear_worktree_session()
  local session_file = current_session_file()
  if vim.fn.filereadable(session_file) == 0 then
    return false, session_file
  end

  local deleted = vim.fn.delete(session_file) == 0
  return deleted, session_file
end

local function clear_all_sessions()
  if vim.fn.isdirectory(sessions_dir) == 0 then
    return 0
  end

  local files = vim.fn.glob(sessions_dir .. "/*.vim", false, true)
  local removed = 0

  for _, file in ipairs(files) do
    if vim.fn.delete(file) == 0 then
      removed = removed + 1
    end
  end

  return removed
end

vim.api.nvim_create_user_command("SessionSave", function()
  local session_file = save_worktree_session()
  vim.notify("Session saved: " .. session_file, vim.log.levels.INFO)
end, { desc = "Save session for current worktree" })

vim.api.nvim_create_user_command("SessionLoad", function()
  local session_file = load_worktree_session()

  if session_file == nil then
    vim.notify("No session for this worktree.", vim.log.levels.WARN)
    return
  end

  vim.notify("Session loaded: " .. session_file, vim.log.levels.INFO)
end, { desc = "Load session for current worktree" })

vim.api.nvim_create_user_command("SessionClear", function()
  local deleted, session_file = clear_worktree_session()

  if not deleted then
    vim.notify("No session to clear for this worktree.", vim.log.levels.WARN)
    return
  end

  vim.notify("Session cleared: " .. session_file, vim.log.levels.INFO)
end, { desc = "Clear session for current worktree" })

vim.api.nvim_create_user_command("SessionClearAll", function()
  local removed = clear_all_sessions()
  vim.notify(string.format("Cleared %d session file(s).", removed), vim.log.levels.INFO)
end, { desc = "Clear all saved sessions" })

-- C# file type detection autocmd
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.cs",
  callback = function()
    vim.bo.filetype = "cs"
  end,
})
