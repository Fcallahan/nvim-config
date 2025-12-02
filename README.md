# Neovim Config

A Neovim configuration optimized for .NET/C# development in WSL, with modern plugin management via lazy.nvim.

## Installation

```bash
# Clone the config
git clone https://github.com/Fcallahan/nvim-config.git ~/.config/nvim

# Open nvim - lazy.nvim will auto-install all plugins
nvim
```

## Requirements

- Neovim >= 0.10
- Git
- Node.js (for some LSP servers)
- .NET SDK (for C# development)
- A [Nerd Font](https://www.nerdfonts.com/) for icons

## Features

### Language Support
- **C#/.NET**: Roslyn LSP with full IntelliSense, go-to-definition, references
- **DAP Debugging**: netcoredbg integration with breakpoints, step debugging, variable inspection
- **dotnet-tools.nvim**: Quick debug, test running, user secrets management

### Core Plugins
| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [roslyn.nvim](https://github.com/seblj/roslyn.nvim) | C# LSP (Roslyn) |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug Adapter Protocol |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | Debugging UI |
| [dotnet-tools.nvim](https://github.com/tuliopaim/dotnet-tools.nvim) | .NET utilities |
| [neotest](https://github.com/nvim-neotest/neotest) | Test runner |

### Editor Features
| Plugin | Purpose |
|--------|---------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder (via snacks.nvim) |
| [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer |
| [harpoon](https://github.com/ThePrimeagen/harpoon) | Quick file navigation |
| [which-key](https://github.com/folke/which-key.nvim) | Keybinding hints |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics list |

### Git Integration
| Plugin | Purpose |
|--------|---------|
| lazygit | Terminal UI for git |
| [octo.nvim](https://github.com/pwntester/octo.nvim) | GitHub PR reviews |
| gitsigns | Git diff in gutter |

### UI/Theme
| Plugin | Purpose |
|--------|---------|
| [catppuccin](https://github.com/catppuccin/nvim) | Color scheme |
| [lualine](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| nvim-dap-virtual-text | Inline debug values |

### AI Assistance
| Plugin | Purpose |
|--------|---------|
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot |
| supermaven | AI completions |

## Key Keybindings

Leader key: `<Space>`

### Navigation
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep word under cursor |
| `<leader><leader>` | Find buffers |
| `-` | Open Oil file explorer |

### LSP
| Key | Action |
|-----|--------|
| `gd` / `<leader>gd` | Go to definition |
| `gr` | Go to references |
| `gi` / `<leader>gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |

### Debugging
| Key | Action |
|-----|--------|
| `<leader>dd` | Start .NET debugging |
| `<F5>` / `<leader>dc` | Continue/Start |
| `<F9>` / `<leader>db` | Toggle breakpoint |
| `<F10>` / `<leader>dv` | Step over |
| `<F11>` / `<leader>di` | Step into |
| `<F8>` / `<leader>do` | Step out |
| `<leader>dX` | Force cleanup DAP session |
| `<space>?` | Evaluate variable under cursor |

### Testing
| Key | Action |
|-----|--------|
| `<leader>tr` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>dt` | Debug nearest test |
| `<leader>te` | Test explorer |

### Git
| Key | Action |
|-----|--------|
| `<leader>lg` | Open LazyGit |
| `<leader>fs` | Git status |
| `<leader>fc` | Git commits |
| `<leader>fb` | Git branches |

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── plugins/             # Plugin configurations
│   │   ├── dap.lua          # Debugging setup
│   │   ├── lsp.lua          # LSP configuration
│   │   ├── roslyn.lua       # C# LSP
│   │   └── ...
│   └── tuliopaim/           # Custom modules
│       ├── remap.lua        # Key mappings
│       └── set.lua          # Vim options
└── after/
    └── ftplugin/            # Filetype-specific settings
```

## Updating

```bash
# Update plugins
nvim
:Lazy update

# Pull config changes
cd ~/.config/nvim
git pull
```
