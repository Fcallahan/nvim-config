# OmniSharp Testing Guide

## Configuration Applied
✅ **Mason Setup**: OmniSharp added to `ensure_installed` in lsp.lua  
✅ **LSP Config**: Proper OmniSharp configuration with WSL optimizations  
✅ **File Detection**: C# filetype autocmd added to set.lua  
✅ **Root Detection**: Enhanced to find .sln, .csproj, and git repos  

## Testing Steps

### 1. Restart Neovim Completely
```bash
# Close all nvim instances, then restart
exit  # or :qa!
```

### 2. Install OmniSharp via Mason
```bash
# In nvim
:Mason
# Look for "omnisharp" - it should auto-install on first C# file open
# Or manually press 'i' on omnisharp if listed
```

### 3. Navigate to Project & Test
```bash
cd /mnt/c/Work/Emsmart2.0-Audit
nvim src/Application/ConfigureServices.cs
```

### 4. Verify Installation
```vim
" In nvim with .cs file open
:LspInfo

" Should show:
" - omnisharp client attached
" - Root directory: /mnt/c/Work/Emsmart2.0-Audit
" - No errors in client info
```

### 5. Test LSP Features
- **Hover**: Place cursor on symbol, press `K`
- **Go to Definition**: Place cursor on symbol, press `gd`  
- **References**: Place cursor on symbol, press `gr`
- **Code Actions**: Press `<leader>ca`
- **Rename**: Press `<leader>rn`
- **Diagnostics**: Should appear without flooding

### 6. Check for Improvements
- **No "No symbol found" spam**
- **Cleaner diagnostics**
- **Faster project loading**
- **Better symbol resolution**

## Troubleshooting

### OmniSharp Not Installing
```vim
:Mason
" Manually find and install omnisharp
```

### LSP Not Attaching
```vim
:LspInfo
:LspRestart
" Check Mason binary path:
" ~/.local/share/nvim/mason/bin/omnisharp
```

### Still Getting Symbol Errors
```bash
# Force rebuild packages
cd /mnt/c/Work/Emsmart2.0-Audit
dotnet clean
dotnet restore
dotnet build

# Then restart nvim
```

### Check Logs
```vim
:LspLog
" Look for OmniSharp initialization messages
```

## Expected vs Previous Behavior

### ✅ Expected (Good)
- LSP attaches within 10-30 seconds
- Clean diagnostics (warnings/errors only)  
- Go to definition works
- Hover shows documentation
- No console spam

### ❌ Previous (Bad)  
- "No symbol found" flooding logs
- Red squiggles everywhere
- LSP stops working after few minutes
- Diagnostic namespace errors

## Switch Back to Roslyn (If Needed)
```bash
# Disable OmniSharp in lsp.lua (comment out the setup)
# Re-enable roslyn
mv ~/.config/nvim/lua/plugins/roslyn.lua.disabled ~/.config/nvim/lua/plugins/roslyn.lua
```