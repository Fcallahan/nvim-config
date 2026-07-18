local function setup_markdown_preview_browser()
    if vim.g.__mkdp_browserfunc_initialized then
        return
    end

    vim.g.__mkdp_browserfunc_initialized = true
    vim.g.mkdp_browserfunc = "MkdpOpenBrowser"

    vim.cmd([[ 
function! MkdpOpenBrowser(url) abort
  if executable('wslview')
    call jobstart(['wslview', a:url], {'detach': v:true})
    return
  endif

  if executable('xdg-open')
    call jobstart(['xdg-open', a:url], {'detach': v:true})
    return
  endif

  if filereadable('/mnt/c/Windows/System32/cmd.exe')
    call jobstart(['/mnt/c/Windows/System32/cmd.exe', '/C', 'start', '', a:url], {'detach': v:true})
    return
  endif

  echohl ErrorMsg
  echom 'markdown-preview.nvim: no opener found (wslview, xdg-open, cmd.exe)'
  echohl None
endfunction
]])
end

-- Neovim 0.12+ treesitter uses coroutine.yield internally, which crashes across
-- vim.schedule's C-call boundary. Patch render-markdown's decorator scheduling
-- to call callbacks directly instead of through vim.schedule.
local function patch_render_markdown_schedule()
    local decorator = require("render-markdown.lib.decorator")
    local original = decorator.schedule
    decorator.schedule = function(self, debounce, ms, callback)
        if debounce and ms > 0 then
            self.timer:start(ms, 0, function()
                self.running = false
            end)
            if not self.running then
                self.running = true
                callback()
            end
        else
            callback()
        end
    end
end

return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        keys = {
            {
                "<leader>md",
                "<cmd>MarkdownPreviewToggle<cr>",
                desc = "Toggle markdown preview",
                ft = "markdown",
            },
        },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_theme = "dark"
            if vim.fn.has("wsl") == 1 then
                vim.g.mkdp_open_to_the_world = 1
            end
            setup_markdown_preview_browser()
        end,
        ft = { "markdown" },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        ft = { "markdown", "codecompanion" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("render-markdown").setup({
                heading = {
                    enabled = false,
                },
                latex = { enabled = false },
            })
            -- Neovim 0.12+ treesitter yield-across-C-call fix for render-markdown
            patch_render_markdown_schedule()
        end,
    },
}
