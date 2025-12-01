return {
  'sudormrfbin/cheatsheet.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
  },
  event = "VeryLazy",
  config = function()
    require("cheatsheet").setup({
      -- Include bundled cheatsheets (vim, nerd-fonts, regex, markdown, etc.)
      bundled_cheatsheets = true,

      -- Include plugin cheatsheets from installed plugins
      bundled_plugin_cheatsheets = true,

      -- Only show cheatsheets for installed plugins
      include_only_installed_plugins = true,

      -- Telescope mappings
      telescope_mappings = {
        ['<CR>'] = require('cheatsheet.telescope.actions').select_or_fill_commandline,
        ['<C-Y>'] = require('cheatsheet.telescope.actions').copy_cheat_value,
        ['<C-E>'] = require('cheatsheet.telescope.actions').edit_user_cheatsheet,
      }
    })
  end,
  keys = {
    { "<leader>ch", "<cmd>Cheatsheet<CR>", desc = "Open cheatsheet" },
    { "<leader>?", "<cmd>CheatsheetEdit<CR>", desc = "Edit cheatsheet" },
  }
}
