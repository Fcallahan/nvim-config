return {
  "johannww/tts.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "TTS", "TTSFile", "TTSSetLanguage", "TTSSetBackend" },
  opts = {
  backend = "openai",
  language = "en",
  speed = 1.2,
  languages_to_voice = {
    edge = {
      ["en"] = "en-US-ChristopherNeural",
    },
  },
  openai = {
    voice = "onyx",
    model = "tts-1-hd",
  },
  remove_syntax = true,
  syntax_removal_method = "simple",
},
  keys = {
    { "<leader>tc", "<cmd>edit ~/.config/nvim/lua/plugins/tts.lua<CR>", desc = "Open TTS settings" },
    { "<leader>tx", "<cmd>TTS<CR>", mode = "x", desc = "TTS speak selection" },
    { "<leader>tX", "<cmd>TTSFile<CR>", mode = "x", desc = "TTS save selection to file" },
    {
      "<leader>tl",
      function()
        vim.cmd("normal! V")
        vim.cmd("TTS")
      end,
      mode = "n",
      desc = "TTS speak current line",
    },
    {
      "<leader>tp",
      function()
        local pid_file = vim.fn.stdpath("data") .. "/tts-nvim/pid.txt"
        local f = io.open(pid_file, "r")
        if f then
          local pid = f:read("*l")
          f:close()
          if pid and pid ~= "" then
            vim.fn.system("kill -STOP " .. pid)
            print("TTS paused")
          else
            print("No active TTS to pause")
          end
        else
          print("No active TTS to pause")
        end
      end,
      mode = "n",
      desc = "Pause TTS playback",
    },
    {
      "<leader>tr",
      function()
        local pid_file = vim.fn.stdpath("data") .. "/tts-nvim/pid.txt"
        local f = io.open(pid_file, "r")
        if f then
          local pid = f:read("*l")
          f:close()
          if pid and pid ~= "" then
            vim.fn.system("kill -CONT " .. pid)
            print("TTS resumed")
          else
            print("No paused TTS to resume")
          end
        else
          print("No paused TTS to resume")
        end
      end,
      mode = "n",
      desc = "Resume TTS playback",
    },
    {
      "<leader>tE",
      function()
        vim.cmd("'<,'>w !espeak-ng -v en -s 140")
      end,
      mode = "x",
      desc = "TTS fallback with espeak-ng",
    },
  },
}
