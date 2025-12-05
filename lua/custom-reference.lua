-- Enhanced Custom Reference Overlay - NvChad Style
-- Searchable, comprehensive keybindings reference with multi-column grid
-- Press <leader>ref to toggle, / or i to search, q to close

local M = {}

-- State management
local state = {
  win_id = nil,
  buf_id = nil,
  search_mode = false,
  search_query = "",
}

-- Compact ASCII Art Header
local header = {
  "",
  "                    ╭─────────────────────────────╮",
  "                    │  What did you forget? 🤔   │",
  "                    ╰────────────┬────────────────╯",
  "                                 │",
  "                    /\\_/\\       /",
  "                   ( o.o )     /",
  "                    > ^ <     /",
  "                   /|   |\\",
  "                  (_|   |_)",
  "",
  "                 🔍 Searchable Reference - Press / to search",
  "",
}

-- Comprehensive keybindings organized by workflow
local reference_content = {
  {
    section = "🔧 PR REVIEW",
    priority = 1,
    tags = {"pr", "review", "github", "octo", "git"},
    items = {
      { "<leader>opr", "Start PR review" },
      { "]q / [q", "Next/prev file" },
      { "<space>ca", "Add comment" },
      { "<space>sa", "Add suggestion" },
      { "]t / [t", "Next/prev thread" },
      { "<leader><space>", "Toggle viewed" },
      { "gf", "Go to file" },
      { "<leader>oprs", "Submit review" },
      { "<C-a>", "Approve (submit)" },
      { "<C-m>", "Comment (submit)" },
      { "<C-r>", "Request changes" },
      { "<leader>oprd", "Discard review" },
      { "<leader>opl", "List PRs" },
      { "<C-b>", "Open in browser" },
    }
  },
  {
    section = "🐛 DEBUGGING",
    priority = 2,
    tags = {"debug", "dap", "breakpoint", "step", "launch", "exception"},
    items = {
      { "<leader>dd", "Quick debug (launch)" },
      { "F9 / <leader>db", "Toggle breakpoint" },
      { "Shift+F9", "Conditional BP" },
      { "<leader>dE", "Cycle exception BP" },
      { "<leader>deu", "Break unhandled" },
      { "<leader>dea", "Break all except" },
      { "<leader>deo", "Except BP off" },
      { "F5 / <leader>dc", "Start/Continue" },
      { "F10 / <leader>dv", "Step over" },
      { "F11 / <leader>di", "Step into" },
      { "F8 / <leader>do", "Step out" },
      { "F2 / <leader>dr", "Restart" },
      { "F4 / <leader>dx", "Stop/exit" },
      { "<leader>dX", "Force kill (nuclear)" },
      { "<space>?", "Eval under cursor" },
      { "<leader>de", "Eval expression" },
      { "<leader>dvar", "Search variables" },
      { "<leader>dfr", "Jump frames" },
      { "<leader>dS", "Toggle sidebar" },
      { "<leader>dC", "Toggle console" },
    }
  },
  {
    section = "🧪 TESTING",
    priority = 3,
    tags = {"test", "neotest", "xunit", "debug"},
    items = {
      { "<leader>te", "Test explorer" },
      { "<leader>tr", "Run test" },
      { "<leader>tf", "Run file tests" },
      { "<leader>dt", "Debug test" },
      { "<leader>to", "Test output" },
      { "<leader>tS", "Stop tests" },
      { "r (explorer)", "Run under cursor" },
      { "w (explorer)", "Watch test" },
      { "d (explorer)", "Debug under cursor" },
      { "o (explorer)", "Show output" },
    }
  },
  {
    section = "🏗️ BUILD & RUN",
    priority = 4,
    tags = {"build", "dotnet", "csharp", "run"},
    items = {
      { "<leader>rl", "Run launcher" },
      { "<leader>cb", "Build project" },
      { "<leader>cB", "Build solution" },
      { "<leader>cd", "Build default" },
      { ":Wb", "Write & build" },
      { ":Wd", "Write & debug build" },
      { "<leader>ce", "Show errors" },
      { "<leader>cw", "Show warnings" },
      { "<leader>cr", "Run project" },
      { "<leader>ct", "Run tests" },
      { "<leader>cp", "Check outdated" },
      { "<leader>cs", "User secrets" },
    }
  },
  {
    section = "🔍 FINDING",
    priority = 5,
    tags = {"find", "search", "telescope", "file"},
    items = {
      { "<leader>ff", "Find files" },
      { "<leader>fg", "Live grep" },
      { "<leader>fw", "Grep word" },
      { "<leader><leader>", "Find buffers" },
      { "<leader>fh", "Help tags" },
      { "<leader>fo", "Recent files" },
      { "<leader>fb", "Git branches" },
      { "<leader>fc", "Git commits" },
      { "<leader>fs", "Git status" },
      { "<leader>fp", "Find keymaps" },
      { "<leader>fd", "Diagnostics" },
      { "<leader>fr", "Find & replace" },
    }
  },
  {
    section = "📝 LSP & CODE",
    priority = 6,
    tags = {"lsp", "code", "definition", "reference"},
    items = {
      { "gd / <leader>gd", "Go to definition" },
      { "gr", "Go to references" },
      { "gi / <leader>gi", "Go to impl" },
      { "<leader>gD", "Go to declaration" },
      { "<leader>gt", "Go to type def" },
      { "K", "Hover docs" },
      { "<leader>ca", "Code actions" },
      { "<leader>rn", "Rename" },
      { "<leader>lf", "Format" },
      { "]d / [d", "Next/prev diag" },
      { "]e / [e", "Next/prev error" },
      { "]w / [w", "Next/prev warn" },
    }
  },
  {
    section = "🔀 GIT",
    priority = 7,
    tags = {"git", "lazygit", "diff", "blame"},
    items = {
      { "<leader>lg", "LazyGit" },
      { "<leader>gb", "Git blame" },
      { ":Gd", "Git diff" },
      { "<leader>gfl", "File history" },
      { "<leader>gc", "Commits" },
      { "<leader>gs", "Git status" },
      { "gh pr list", "List PRs" },
      { "gh pr view", "View PR" },
      { "gh pr diff", "PR diff" },
    }
  },
  {
    section = "🗂️ FILES",
    priority = 8,
    tags = {"file", "buffer", "explorer", "harpoon"},
    items = {
      { "<leader>ef", "Reveal explorer" },
      { "<leader>eo", "Open explorer" },
      { "gk / gj", "Next/prev buffer" },
      { "<leader>bd", "Close buffer" },
      { "<leader>hi", "Harpoon add" },
      { "<leader>hh", "Harpoon menu" },
      { "<leader>1-5", "Harpoon jump" },
      { "<C-h/j/k/l>", "Navigate windows" },
      { "<leader>v", "Vsplit" },
      { "<leader>b", "Hsplit" },
      { "<leader>x", "Close window" },
    }
  },
  {
    section = "⚡ QUICK",
    priority = 9,
    tags = {"quick", "terminal", "clipboard"},
    items = {
      { "<leader>ref", "This overlay" },
      { "<leader>ch", "Cheatsheet" },
      { "<C-t>", "Toggle terminal" },
      { "<leader>th/tv/tt", "Term H/V/T" },
      { "<leader>no", "Clear search" },
      { "<leader>nd", "New doc" },
      { "<leader>td", "TODO" },
      { "<C-f>", "Tmux session" },
      { "<leader>y", "Yank system" },
      { "<leader>p", "Paste reg 0" },
      { "<leader>d", "Delete black" },
    }
  },
  {
    section = "🔖 TABS",
    priority = 10,
    tags = {"tab", "window"},
    items = {
      { "<leader>tN", "New tab" },
      { "<leader>tn", "Next tab" },
      { "<leader>tp", "Prev tab" },
      { "<leader>tc", "Close tab" },
      { "<leader>ts", "Tab split" },
    }
  },
  {
    section = "🗄️ DATABASE",
    priority = 11,
    tags = {"database", "sql", "dbui", "dadbod", "db", "cache", "postgres"},
    items = {
      { "<leader>db", "Toggle DBUI" },
      { "<leader>dr", "Refresh cache ⭐" },
      { "<leader>df", "Find DB buffer" },
      { "<leader>S", "Execute query" },
      { "<leader>de", "Execute SQL (vis)" },
      { "<leader>dE", "Execute buffer" },
      { "<leader>dc", "Edit connections" },
      { ":DBUI", "Open database UI" },
      { ":DBCompletionClearCache", "Clear cache (cmd)" },
      { ":DBUIShowConnections", "Show connections" },
      { "Enter (DBUI)", "Expand/open" },
      { "o (DBUI)", "Open in buffer" },
      { "S (DBUI)", "Open in vsplit" },
      { "A (DBUI)", "Add connection" },
      { "R (DBUI)", "Rename" },
      { "d (DBUI)", "Delete" },
      { "q (DBUI)", "Close DBUI" },
    }
  },
}

-- Distribute sections into columns
local function distribute_columns(sections, num_cols)
  local columns = {}
  for i = 1, num_cols do
    columns[i] = {}
  end

  -- Sort by priority
  table.sort(sections, function(a, b)
    return a.priority < b.priority
  end)

  -- Distribute sections across columns evenly
  local col_idx = 1
  for _, section in ipairs(sections) do
    table.insert(columns[col_idx], section)
    col_idx = col_idx + 1
    if col_idx > num_cols then
      col_idx = 1
    end
  end

  return columns
end

-- Generate section block
local function generate_section_block(section)
  local lines = {}
  table.insert(lines, section.section)
  table.insert(lines, string.rep("─", 38))

  for _, item in ipairs(section.items) do
    local key = item[1]
    local desc = item[2]
    -- Compact format: key padded to 20 chars + desc
    local line = string.format("%-20s %s", key, desc)
    table.insert(lines, line)
  end

  return lines
end

-- Pad line to width
local function pad_line(line, width)
  local len = vim.fn.strdisplaywidth(line)
  if len < width then
    return line .. string.rep(" ", width - len)
  end
  return line:sub(1, width)
end

-- Generate multi-column grid layout
local function generate_lines()
  local lines = {}

  -- Add header
  for _, line in ipairs(header) do
    table.insert(lines, line)
  end

  -- Determine number of columns (4 columns for width 160+)
  local num_cols = 4
  local col_width = 40

  -- Get sections to display (filtered if searching)
  local sections_to_show = reference_content
  if state.search_query ~= "" then
    sections_to_show = filter_sections(reference_content, state.search_query)

    -- Add search indicator
    table.insert(lines, "")
    table.insert(lines, "  🔎 Searching for: '" .. state.search_query .. "'")
  end

  -- Distribute sections into columns
  local columns = distribute_columns(sections_to_show, num_cols)

  -- Generate section blocks for each column
  local column_blocks = {}
  local max_height = 0

  for col_idx, col_sections in ipairs(columns) do
    column_blocks[col_idx] = {}
    for _, section in ipairs(col_sections) do
      local block = generate_section_block(section)
      for _, line in ipairs(block) do
        table.insert(column_blocks[col_idx], line)
      end
      table.insert(column_blocks[col_idx], "") -- spacing between sections
    end
    max_height = math.max(max_height, #column_blocks[col_idx])
  end

  -- Combine columns side by side
  table.insert(lines, "")
  for row = 1, max_height do
    local row_line = ""
    for col_idx = 1, num_cols do
      local col_line = column_blocks[col_idx][row] or ""
      row_line = row_line .. "  " .. pad_line(col_line, col_width)
    end
    table.insert(lines, row_line)
  end

  -- Footer
  table.insert(lines, "")
  table.insert(lines, string.rep("─", 160))
  if state.search_query == "" then
    table.insert(lines, "  Press / or i to search  •  q or <Esc> to close  •  <leader>ref to toggle")
  else
    if #sections_to_show == 0 then
      table.insert(lines, "  ❌ No matches found - Press <Esc> to clear search")
    else
      table.insert(lines, "  ✓ Found " .. #sections_to_show .. " sections - Press <Esc> to clear  •  q to close")
    end
  end

  return lines
end

-- Filter sections based on search query
function filter_sections(sections, query)
  local filtered = {}
  local query_lower = query:lower()

  for _, section_data in ipairs(sections) do
    local section_matches = false
    local matching_items = {}

    -- Check if section name or tags match
    local section_lower = section_data.section:lower()
    for _, tag in ipairs(section_data.tags) do
      if tag:find(query_lower, 1, true) or section_lower:find(query_lower, 1, true) then
        section_matches = true
        break
      end
    end

    -- Check each item
    for _, item in ipairs(section_data.items) do
      local key_lower = item[1]:lower()
      local desc_lower = item[2]:lower()
      if key_lower:find(query_lower, 1, true) or desc_lower:find(query_lower, 1, true) or section_matches then
        table.insert(matching_items, item)
      end
    end

    -- Add section if it has matches
    if #matching_items > 0 then
      local filtered_section = vim.deepcopy(section_data)
      filtered_section.items = matching_items
      table.insert(filtered, filtered_section)
    end
  end

  return filtered
end

-- Update buffer content
local function update_buffer_content()
  if not state.buf_id or not vim.api.nvim_buf_is_valid(state.buf_id) then
    return
  end

  local lines = generate_lines()
  vim.api.nvim_buf_set_option(state.buf_id, 'modifiable', true)
  vim.api.nvim_buf_set_lines(state.buf_id, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(state.buf_id, 'modifiable', false)

  apply_highlights()
end

-- Apply syntax highlighting
function apply_highlights()
  if not state.buf_id or not vim.api.nvim_buf_is_valid(state.buf_id) then
    return
  end

  -- Define enhanced highlight groups
  vim.api.nvim_set_hl(0, 'RefHeader', { fg = '#89b4fa', bold = true })
  vim.api.nvim_set_hl(0, 'RefTitle', { fg = '#cba6f7', bold = true })
  vim.api.nvim_set_hl(0, 'RefSection', { fg = '#f9e2af', bold = true })
  vim.api.nvim_set_hl(0, 'RefKey', { fg = '#a6e3a1', bold = true })
  vim.api.nvim_set_hl(0, 'RefDesc', { fg = '#cdd6f4' })
  vim.api.nvim_set_hl(0, 'RefBorder', { fg = '#45475a' })
  vim.api.nvim_set_hl(0, 'RefFooter', { fg = '#6c7086', italic = true })
  vim.api.nvim_set_hl(0, 'RefSearch', { fg = '#f38ba8', bold = true })

  -- Apply highlights
  local lines = vim.api.nvim_buf_get_lines(state.buf_id, 0, -1, false)
  for i, line in ipairs(lines) do
    local line_num = i - 1

    -- Header ASCII art
    if line:match("███") or line:match("╗") or line:match("╚") then
      vim.api.nvim_buf_add_highlight(state.buf_id, -1, 'RefHeader', line_num, 0, -1)
    -- Section headers with emoji
    elseif line:match("^%s*[🔧🐛🧪🏗️🔍📝🔀🗂️⚡🔖]") then
      vim.api.nvim_buf_add_highlight(state.buf_id, -1, 'RefSection', line_num, 0, -1)
    -- Borders
    elseif line:match("^%s*─+$") or line:match("^─+$") then
      vim.api.nvim_buf_add_highlight(state.buf_id, -1, 'RefBorder', line_num, 0, -1)
    -- Search indicator
    elseif line:match("🔎 Searching") or line:match("No matches") or line:match("Found.*sections") then
      vim.api.nvim_buf_add_highlight(state.buf_id, -1, 'RefSearch', line_num, 0, -1)
    -- Footer
    elseif line:match("Press.*to") then
      vim.api.nvim_buf_add_highlight(state.buf_id, -1, 'RefFooter', line_num, 0, -1)
    -- Title
    elseif line:match("Searchable") then
      vim.api.nvim_buf_add_highlight(state.buf_id, -1, 'RefTitle', line_num, 0, -1)
    -- Keybindings (highlight keys in green, rest in default)
    else
      -- Find keybinding patterns and highlight them
      local key_patterns = {
        "<leader>%w+", "<space>%w+", "<C%-%w+>", "<Esc>",
        "F%d+", "%[%w+", "%]%w+", "gd", "gr", "gi", "gf", "gk", "gj", "K"
      }
      for _, pattern in ipairs(key_patterns) do
        local start = 1
        while true do
          local s, e = line:find(pattern, start)
          if not s then break end
          vim.api.nvim_buf_add_highlight(state.buf_id, -1, 'RefKey', line_num, s - 1, e)
          start = e + 1
        end
      end
    end
  end
end

-- Create the floating window
local function create_window()
  -- Calculate window size (large, NvChad-style)
  local width = math.min(165, vim.o.columns - 10)
  local height = math.min(55, vim.o.lines - 6)
  local row = math.floor((vim.o.lines - height) / 2) - 1
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create buffer
  state.buf_id = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(state.buf_id, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(state.buf_id, 'filetype', 'reference')

  -- Set content
  local lines = generate_lines()
  vim.api.nvim_buf_set_lines(state.buf_id, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(state.buf_id, 'modifiable', false)

  -- Window configuration
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Quick Reference ',
    title_pos = 'center',
  }

  -- Create window
  state.win_id = vim.api.nvim_open_win(state.buf_id, true, opts)
  vim.api.nvim_win_set_option(state.win_id, 'winblend', 0)
  vim.api.nvim_win_set_option(state.win_id, 'cursorline', false)
  vim.api.nvim_win_set_option(state.win_id, 'wrap', false)

  apply_highlights()
  setup_keymaps()
end

-- Setup keymaps
function setup_keymaps()
  if not state.buf_id then return end

  local opts = { noremap = true, silent = true, buffer = state.buf_id }

  -- Close
  vim.keymap.set('n', 'q', function() M.close() end, opts)
  vim.keymap.set('n', '<Esc>', function()
    if state.search_query ~= "" then
      state.search_query = ""
      update_buffer_content()
    else
      M.close()
    end
  end, opts)

  -- Search
  vim.keymap.set('n', '/', function() M.enter_search_mode() end, opts)
  vim.keymap.set('n', 'i', function() M.enter_search_mode() end, opts)
end

-- Enter search mode
function M.enter_search_mode()
  if not state.buf_id then return end

  vim.ui.input({
    prompt = '🔍 Search: ',
    default = state.search_query,
  }, function(input)
    if input then
      state.search_query = input
      update_buffer_content()
    end
  end)
end

-- Close the window
function M.close()
  if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
    vim.api.nvim_win_close(state.win_id, true)
  end
  state.win_id = nil
  state.buf_id = nil
  state.search_query = ""
end

-- Toggle the window
function M.toggle()
  if state.win_id and vim.api.nvim_win_is_valid(state.win_id) then
    M.close()
  else
    state.search_query = ""
    create_window()
  end
end

return M
