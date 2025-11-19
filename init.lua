require("tuliopaim.set")
require("tuliopaim.remap")

-- Ensure .NET SDK is visible to language servers and dotnet tools are accessible
vim.env.DOTNET_ROOT = vim.fn.expand("~/.dotnet")
vim.env.PATH = vim.env.DOTNET_ROOT .. ":" .. vim.fn.expand("~/.dotnet/tools") .. ":" .. vim.env.PATH

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "plugins",
    change_detection = { notify = false },
})
