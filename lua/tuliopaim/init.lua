require("tuliopaim.commands")
require("tuliopaim.remap")
require("tuliopaim.set")

-- Auto-start pi_review when PI_REVIEW_ROOT env var is set (from Pi extension)
if vim.env.PI_REVIEW_ROOT and vim.env.PI_REVIEW_JSON then
  vim.schedule(function()
    local ok_mod, mod = pcall(require, "tuliopaim.pi_review")
    if not ok_mod then
      vim.notify("pi_review not loaded: " .. tostring(mod), vim.log.levels.WARN, { title = "pi-review" })
      return
    end
    local ok, err = pcall(mod.start)
    if not ok then
      vim.notify("pi_review start failed: " .. tostring(err), vim.log.levels.ERROR, { title = "pi-review" })
    end
  end)
end

