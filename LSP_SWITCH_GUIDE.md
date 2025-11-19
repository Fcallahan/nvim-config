# C# LSP Switch Guide

## Current Status
- **Roslyn LSP**: Disabled (backed up as `roslyn.lua.disabled`)
- **OmniSharp LSP**: Active (`omnisharp.lua`)

## Files Created/Modified
- `lua/plugins/omnisharp.lua` - OmniSharp LSP configuration
- `lua/plugins/roslyn.lua.backup` - Original roslyn backup
- `lua/plugins/roslyn.lua.disabled` - Disabled roslyn config

## To Switch Back to Roslyn
```bash
# Disable OmniSharp
mv ~/.config/nvim/lua/plugins/omnisharp.lua ~/.config/nvim/lua/plugins/omnisharp.lua.disabled

# Re-enable Roslyn
mv ~/.config/nvim/lua/plugins/roslyn.lua.disabled ~/.config/nvim/lua/plugins/roslyn.lua

# Restart nvim
```

## To Switch to OmniSharp (Current)
```bash
# Already done - OmniSharp is currently active
```

## Key Differences

### OmniSharp Advantages
- More stable in WSL environments
- Better project loading
- Fewer "No symbol found" errors
- More mature codebase

### Roslyn Advantages  
- Microsoft's official new LSP server
- Better performance (when working)
- More modern architecture
- Better .NET 8/9 support

## Keybindings (Same for both)
- `<leader>lg` - LazyGit
- `gd` - Go to definition
- `gr` - Go to references  
- `<leader>ca` - Code actions
- `<leader>rn` - Rename
- `<leader>lr` - Restart LSP
- `<leader>ld` - Clear diagnostics

## Testing OmniSharp
1. Restart nvim
2. Open a .cs file in your project: `/mnt/c/Work/Emsmart2.0-Audit/src/Application/ConfigureServices.cs`
3. Check if diagnostics appear (should be much cleaner)
4. Test go to definition on a symbol
5. Test code completion

## OmniSharp Installation Location
`~/.local/share/nvim/omnisharp/OmniSharp`