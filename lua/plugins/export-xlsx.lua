return {
  {
    "tuliopaim/dadbod-export-xlsx.nvim",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql", "dbout" },
    cmd = { "ExportXlsx", "ExportXlsxBuild" },
    config = function()
      require("dadbod_export_xlsx").setup({
        default_dir = "~/Downloads",
        keymap = "<leader>dx",
        filetypes = { "sql", "mysql", "plsql", "dbout" },
      })
    end,
  },
}
