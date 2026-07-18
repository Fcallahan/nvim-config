return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    image = { enabled = false },
    bigfile = { enabled = true },
    lazygit = {
      enabled = true,
      -- Use WSL wrapper if in WSL environment
      cmd = os.getenv("WSL_DISTRO_NAME") and "lazygit-wsl" or "lazygit",
      win = {
        width = 0.95,
        height = 0.95,
      },
    },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = (function()
          local hour = tonumber(os.date("%H"))

          -- Figlet-style ASCII art quotes - FULL SIZE quote + author
          local quotes = {
            morning = {
              [[
 _____ _          _     ____        _             _   _                                     
|  ___(_)_ __ ___| |_  / ___|  ___ | |_   _____  | |_| |__   ___                            
| |_  | | '__/ __| __| \___ \ / _ \| \ \ / / _ \ | __| '_ \ / _ \                           
|  _| | | |  \__ \ |_   ___) | (_) | |\ V /  __/ | |_| | | |  __/                           
|_|__ |_|_|  |___/\__| |____/ \___/|_| \_/ \___|  \__|_| |_|\___|                           
|  _ \ _ __ ___ | |__ | | ___ _ __ ___                                                      
| |_) | '__/ _ \| '_ \| |/ _ \ '_ ` _ \                                                     
|  __/| | | (_) | |_) | |  __/ | | | | |                                                    
|_|___|_|_ \___/|_.__/|_|\___|_| |_| |_|  _     _     _   _                          _      
  |_   _| |__   ___ _ __   |  _ \(_) __ _| |__ | |_  | |_| |__   ___    ___ ___   __| | ___ 
    | | | '_ \ / _ \ '_ \  | |_) | |/ _` | '_ \| __| | __| '_ \ / _ \  / __/ _ \ / _` |/ _ \
    | | | | | |  __/ | | | |  _ <| | (_| | | | | |_  | |_| | | |  __/ | (_| (_) | (_| |  __/
    |_| |_| |_|\___|_| |_| |_| \_\_|\__, |_| |_|\__|  \__|_| |_|\___|  \___\___/ \__,_|\___|
                                    |___/                                                                        - John Johnson
]],
              [[
 __  __       _          _ _                        _    
|  \/  | __ _| | _____  (_) |_  __      _____  _ __| | __
| |\/| |/ _` | |/ / _ \ | | __| \ \ /\ / / _ \| '__| |/ /
| |  | | (_| |   <  __/ | | |_   \ V  V / (_) | |  |   < 
|_|  |_|\__,_|_|\_\___| |_|\__|   \_/\_/ \___/|_|  |_|\_\
|  \/  | __ _| | _____  (_) |_   _ __(_) __ _| |__ | |_  
| |\/| |/ _` | |/ / _ \ | | __| | '__| |/ _` | '_ \| __| 
| |  | | (_| |   <  __/ | | |_  | |  | | (_| | | | | |_  
|_|  |_|\__,_|_|\_\___| |_|\__| |_|_ |_|\__, |_| |_|\__| 
|  \/  | __ _| | _____  (_) |_   / _| __|___/_| |_       
| |\/| |/ _` | |/ / _ \ | | __| | |_ / _` / __| __|      
| |  | | (_| |   <  __/ | | |_  |  _| (_| \__ \ |_       
|_|  |_|\__,_|_|\_\___| |_|\__| |_|  \__,_|___/\__|      

                     - Kent Beck
]],

            },
            afternoon = {
              [[
 ____  _                 _ _      _ _                          
/ ___|(_)_ __ ___  _ __ | (_) ___(_) |_ _   _                  
\___ \| | '_ ` _ \| '_ \| | |/ __| | __| | | |                 
 ___) | | | | | | | |_) | | | (__| | |_| |_| |                 
|____/|_|_|_|_|_|_| .__/|_|_|\___|_|\__|\__, |               _ 
|_ _|___  | |_| |_|_| ___  | |_| |__   _|___/___  ___  _   _| |
 | |/ __| | __| '_ \ / _ \ | __| '_ \ / _ \ / __|/ _ \| | | | |
 | |\__ \ | |_| | | |  __/ | |_| | | |  __/ \__ \ (_) | |_| | |
|___|___/_ \__|_|_|_|\___| _\__|_|_|_|\___| |___/\___/ \__,_|_|
 / _ \ / _| | ____|/ _|/ _(_) ___(_) ___ _ __   ___ _   _      
| | | | |_  |  _| | |_| |_| |/ __| |/ _ \ '_ \ / __| | | |     
| |_| |  _| | |___|  _|  _| | (__| |  __/ | | | (__| |_| |     
 \___/|_|   |_____|_| |_| |_|\___|_|\___|_| |_|\___|\__, |     
                                                    |___/      

                     - Austin Freeman
]],
              [[
____       _                       _
|  _ \  ___| |__  _   _  __ _  __ _(_)_ __   __ _
| | | |/ _ \ '_ \| | | |/ _` |/ _` | | '_ \ / _` |
| |_| |  __/ |_) | |_| | (_| | (_| | | | | | (_| |
|____/ \___|_.__/ \__,_|\__, |\__, |_|_| |_|\__, |
                        |___/ |___/         |___/
_       _           _
(_)___  | |___      _(_) ___ ___
| / __| | __\ \ /\ / / |/ __/ _ \
| \__ \ | |_ \ V  V /| | (_|  __/
|_|___/  \__| \_/\_/ |_|\___\___|

             _                     _
 __ _ ___    | |__   __ _ _ __ __| |
/ _` / __|   | '_ \ / _` | '__/ _` |
| (_| \__ \   | | | | (_| | | | (_| |
\__,_|___/   |_| |_|\__,_|_|  \__,_|

                                  _ _   _
 __ _ ___  __      ___ __(_) |_(_)_ __   __ _
/ _` / __| \ \ /\ / / '__| | __| | '_ \ / _` |
| (_| \__ \  \ V  V /| |  | | |_| | | | | (_| |
\__,_|___/   \_/\_/ |_|  |_|\__|_|_| |_|\__, |
                                        |___/
_   _                          _
| |_| |__   ___    ___ ___   __| | ___
| __| '_ \ / _ \  / __/ _ \ / _` |/ _ \
| |_| | | |  __/ | (_| (_) | (_| |  __/
\__|_| |_|\___|  \___\___/ \__,_|\___|

                     - Brian Kernighan
]],
              [[
 _  _____ ____ ____                                                                       
| |/ /_ _/ ___/ ___|                                                                      
| ' / | |\___ \___ \                                                                      
| . \ | | ___) |__) |                                                                     
|_|\_\___|____/____/   _ _         _                 _            _               _     _ 
| |/ /___  ___ _ __   (_) |_   ___(_)_ __ ___  _ __ | | ___   ___| |_ _   _ _ __ (_) __| |
| ' // _ \/ _ \ '_ \  | | __| / __| | '_ ` _ \| '_ \| |/ _ \ / __| __| | | | '_ \| |/ _` |
| . \  __/  __/ |_) | | | |_  \__ \ | | | | | | |_) | |  __/ \__ \ |_| |_| | |_) | | (_| |
|_|\_\___|\___| .__/  |_|\__| |___/_|_| |_| |_| .__/|_|\___| |___/\__|\__,_| .__/|_|\__,_|
              |_|                             |_|                          |_|            
]],
            },
            evening = {
              [[
 ____   ___  _   _ _____   ___ ____       
|  _ \ / _ \| \ | | ____| |_ _/ ___|      
| | | | | | |  \| |  _|    | |\___ \      
| |_| | |_| | |\  | |___   | | ___) |     
|____/ \___/|_|_\_|_____|_|___|____/      
| __ )| ____|_   _|_   _| ____|  _ \      
|  _ \|  _|   | |   | | |  _| | |_) |     
| |_) | |___  | |   | | | |___|  _ <      
|____/|_____|_|_|_ _|_|_|_____|_| \_\     
|_   _| | | | ____| \ | |                 
  | | | |_| |  _| |  \| |                 
  | | |  _  | |___| |\  |                 
 _|_| |_|_|_|_____|_|_\_|_____ ____ _____ 
|  _ \| ____|  _ \|  ___| ____/ ___|_   _|
| |_) |  _| | |_) | |_  |  _|| |     | |  
|  __/| |___|  _ <|  _| | |__| |___  | |  
|_|   |_____|_| \_\_|   |_____\____| |_|  

                     - Sheryl Sandberg
]],
              [[
 ____  _        _    _   _   _______        _____ ____ _____ 
|  _ \| |      / \  | \ | | |_   _\ \      / /_ _/ ___| ____|
| |_) | |     / _ \ |  \| |   | |  \ \ /\ / / | | |   |  _|  
|  __/| |___ / ___ \| |\  |   | |   \ V  V /  | | |___| |___ 
|_|___|_____/_/_  \_\_| \_|___|_|   _\_/\_/ _|___\____|_____|
 / ___/ _ \|  _ \| ____|  / _ \| \ | |/ ___| ____|           
| |  | | | | | | |  _|   | | | |  \| | |   |  _|             
| |__| |_| | |_| | |___  | |_| | |\  | |___| |___            
 \____\___/|____/|_____|  \___/|_| \_|\____|_____|           
]],
            },
            night = {
              [[
 _____     _ _      _        ____ _                                                   
|_   _|_ _| | | __ (_)___   / ___| |__   ___  __ _ _ __                               
  | |/ _` | | |/ / | / __| | |   | '_ \ / _ \/ _` | '_ \                              
  | | (_| | |   <  | \__ \ | |___| | | |  __/ (_| | |_) |                             
  |_|\__,_|_|_|\_\ |_|___/  \____|_| |_|\___|\__,_| .__/                              
 ____  _                                      _   |_|           ____          _       
/ ___|| |__   _____      __  _ __ ___   ___  | |_| |__   ___   / ___|___   __| | ___  
\___ \| '_ \ / _ \ \ /\ / / | '_ ` _ \ / _ \ | __| '_ \ / _ \ | |   / _ \ / _` |/ _ \ 
 ___) | | | | (_) \ V  V /  | | | | | |  __/ | |_| | | |  __/ | |__| (_) | (_| |  __/ 
|____/|_| |_|\___/ \_/\_/  _|_| |_| |_|\___|  \__|_| |_|\___|  \____\___/_\__,_|\___| 
                    | |   (_)_ __  _   _ ___  |_   _|__  _ ____   ____ _| | __| |___  
             _____  | |   | | '_ \| | | / __|   | |/ _ \| '__\ \ / / _` | |/ _` / __| 
            |_____| | |___| | | | | |_| \__ \   | | (_) | |   \ V / (_| | | (_| \__ \ 
                    |_____|_|_| |_|\__,_|___/   |_|\___/|_|    \_/ \__,_|_|\__,_|___/ 
]],
              [[
 ____  _     _____ _____ ____    _   _ _____ _     ____  ____  
/ ___|| |   | ____| ____|  _ \  | | | | ____| |   |  _ \/ ___| 
\___ \| |   |  _| |  _| | |_) | | |_| |  _| | |   | |_) \___ \ 
 ___) | |___| |___| |___|  __/  |  _  | |___| |___|  __/ ___) |
|____/|_____|_____|_____|_| ____|_| |_|_____|_____|_|   |____/ 
|  \/  | ____| |  _ \| ____| __ )| | | |/ ___|                 
| |\/| |  _|   | | | |  _| |  _ \| | | | |  _                  
| |  | | |___  | |_| | |___| |_) | |_| | |_| |                 
|_|  |_|_____| |____/|_____|____/ \___/ \____|                 
]],

              [[

 _____ ___ __  __ _____   _____ ___     ____ ___  ____  _____ _ 
|_   _|_ _|  \/  | ____| |_   _/ _ \   / ___/ _ \|  _ \| ____| |
  | |  | || |\/| |  _|     | || | | | | |  | | | | | | |  _| | |
  | |  | || |  | | |___    | || |_| | | |__| |_| | |_| | |___|_|
  |_| |___|_|  |_|_____|   |_| \___/   \____\___/|____/|_____(_)

]],
            },
          }

          local period
          if hour >= 5 and hour < 12 then
            period = "morning"
          elseif hour >= 12 and hour < 17 then
            period = "afternoon"
          elseif hour >= 17 and hour < 21 then
            period = "evening"
          else
            period = "night"
          end

          math.randomseed(os.time())
          local pool = quotes[period]
          local quote = pool[math.random(#pool)]

          return "\n" .. quote .. "\n"
        end)(),
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    zen = {
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
      },
    },
  },
  keys = {
    { "<leader>fs",  function() Snacks.picker.smart({ hidden = true }) end, desc = "Find files - smart" },
    { "<leader>ff",  function() Snacks.picker.files({ hidden = true }) end, desc = "Find files" },
    { "<leader><leader>",  function() Snacks.picker.buffers() end, desc = "Find buffers" },
    { "<leader>fg",  function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fw",  function() Snacks.picker.grep_word() end, desc = "Grep word" },
    { "<leader>fp",  function() Snacks.picker() end, desc = "Pickers" },
    { "<leader>fb",  function() Snacks.picker.git_branches() end, desc = "Find git branches" },
    { "<leader>fc",  function() Snacks.picker.commands() end, desc = "Find commands" },
    { "<leader>fh",  function() Snacks.picker.help() end, desc = "Find help" },
    { "<leader>fk",  function() Snacks.picker.keymaps() end, desc = "Find keymaps" },
    { "<leader>fd",  function() Snacks.picker.diagnostics() end, desc = "Find diagnostics" },
    { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>es", function() Snacks.picker.explorer({ hidden = true }) end, desc = "Find Config File" },
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>db", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gfl", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "<leader>[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
