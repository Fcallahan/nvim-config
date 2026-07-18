local M = {}

local doc_filetypes = {
  markdown = true,
  text = true,
  help = true,
  gitcommit = true,
}

local doc_winhighlight_keys = {
  Normal = true,
  NormalNC = true,
}

local function set_doc_highlights()
  -- Soft blue-gray: lower glare than white, still readable on dark themes.
  vim.api.nvim_set_hl(0, "DocNormal", { fg = "#bac2de" })
  vim.api.nvim_set_hl(0, "DocNormalNC", { fg = "#a6adc8" })
end

local function without_doc_winhighlights(value)
  if value == nil or value == "" then
    return {}
  end

  local kept = {}
  for part in string.gmatch(value, "[^,]+") do
    local key = part:match("^%s*([^:]+):")
    if key and not doc_winhighlight_keys[key] then
      table.insert(kept, part)
    end
  end

  return kept
end

local function apply_doc_window_highlights()
  local ft = vim.bo.filetype
  local parts = without_doc_winhighlights(vim.wo.winhighlight)

  if doc_filetypes[ft] then
    table.insert(parts, "Normal:DocNormal")
    table.insert(parts, "NormalNC:DocNormalNC")
  end

  vim.wo.winhighlight = table.concat(parts, ",")
end

function M.setup()
  set_doc_highlights()

  local group = vim.api.nvim_create_augroup("TuliopaimDocColors", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = set_doc_highlights,
  })

  vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
    group = group,
    callback = apply_doc_window_highlights,
  })
end

return M
