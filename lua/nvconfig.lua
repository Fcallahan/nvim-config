local options = {
  base46 = {
    theme = "chadracula-evondev",
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = false,
    theme_toggle = { "chadracula-evondev", "chadracula-evondev" },
  },

  ui = {
    cmp = {
      icons_left = false,
      style = "default",
      abbr_maxwidth = 60,
      format_colors = { lsp = true, icon = "*" },
    },

    telescope = { style = "borderless" },

    statusline = {
      enabled = true,
      theme = "default",
      separator_style = "default",
      order = nil,
      modules = nil,
    },

    tabufline = {
      enabled = true,
      lazyload = true,
      treeOffsetFt = "NvimTree",
      order = { "treeOffset", "buffers", "tabs", "btns" },
      modules = nil,
      bufwidth = 21,
    },
  },

  nvdash = {
    load_on_startup = false,
    header = {},
    buttons = {},
  },

  term = {
    startinsert = true,
    base46_colors = true,
    winopts = { number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid",
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" },
  },

  mason = { pkgs = {}, skip = {} },

  colorify = {
    enabled = true,
    mode = "virtual",
    virt_text = "* ",
    highlight = { hex = true, lspvars = true },
  },
}

local ok, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, ok and chadrc or {})
