# csharp-ls Setup Guide (WSL Compatible)

## What Was Changed

✅ **Switched from OmniSharp to csharp-ls** - Known to have better WSL path handling  
✅ **Mason Configuration Updated** - `csharp_ls` added to `ensure_installed`  
✅ **LSP Config Updated** - Proper csharp_ls setup with WSL optimizations  
✅ **Simplified Setup** - Fewer settings that can conflict in WSL  

## Why csharp-ls is Better for WSL

- **Better Path Handling**: Designed to work with WSL path translation
- **Simpler Architecture**: Less complex than OmniSharp, fewer edge cases
- **Active Development**: More recent and actively maintained for LSP compatibility
- **Roslyn-Based**: Uses the same underlying engine as VS Code's C# extension
- **WSL Focus**: Developed with cross-platform compatibility in mind

## Testing Steps

### 1. Restart Neovim Completely
```bash
# Close all nvim instances
:qa!
```

### 2. Auto-Install via Mason
```bash
cd /mnt/c/Work/Emsmart2.0-Audit
nvim src/Application/ConfigureServices.cs

# Mason should auto-install csharp_ls on first .cs file open
# Check installation:
# :Mason
# Look for "csharp_ls" in installed packages
```

### 3. Verify LSP Attachment
```vim
" In nvim with .cs file open
:LspInfo

" Should show:
" - csharp_ls client attached
" - Root directory detected
" - No errors
```

### 4. Test Core Features
- **Hover Documentation**: `K` on any symbol
- **Go to Definition**: `gd` on method/class names  
- **Find References**: `gr` on symbols
- **Code Actions**: `<leader>ca`
- **Rename**: `<leader>rn`

### 5. Check for Improvements
- **No "No symbol found" errors**
- **Clean diagnostic display**
- **Proper IntelliSense**
- **No path-related issues**

## Expected Benefits

### ✅ Should Work Better
- Proper symbol resolution
- Clean diagnostics without flooding
- Better project/solution detection
- Stable performance over time

### ✅ WSL Compatibility
- Handles `/mnt/c/` paths correctly
- No Windows/Linux path translation issues
- Works with WSL-mounted Windows projects

## Troubleshooting

### csharp_ls Not Installing
```bash
# Manual Mason install
:Mason
# Find csharp_ls and press 'i' to install
```

### LSP Not Working
```bash
# Check Mason binary
ls ~/.local/share/nvim/mason/bin/csharp_ls

# Check dotnet availability
which dotnet
dotnet --version
```

### Still Getting Errors
```bash
# Clean and rebuild project
cd /mnt/c/Work/Emsmart2.0-Audit
dotnet clean
dotnet restore
dotnet build

# Restart nvim
```

## Fallback Options

### Switch Back to OmniSharp
If csharp_ls doesn't work, you can revert by changing in lsp.lua:
```lua
-- Change ensure_installed back to:
"omnisharp",  -- instead of "csharp_ls"

-- And update the setup call to:
lspconfig.omnisharp.setup({...})
```

### Switch Back to Roslyn
```bash
mv ~/.config/nvim/lua/plugins/roslyn.lua.disabled ~/.config/nvim/lua/plugins/roslyn.lua
# Remove csharp_ls from ensure_installed
```

## Key Differences from OmniSharp

| Feature | OmniSharp | csharp-ls |
|---------|-----------|-----------|
| WSL Paths | ❌ Issues | ✅ Better handling |
| Complexity | ❌ High | ✅ Simpler |
| Performance | ❌ Can degrade | ✅ More stable |
| Setup | ❌ Complex | ✅ Minimal config |
| Diagnostics | ❌ Can flood | ✅ Cleaner output |