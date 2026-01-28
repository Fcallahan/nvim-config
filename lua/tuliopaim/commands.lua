-- Custom command for CLI-style find/replace
-- Usage: :FindReplace foo bar src/**/*.cs
vim.api.nvim_create_user_command('FindReplace', function(opts)
    local args = vim.split(opts.args, ' ')
    if #args >= 2 then
        require('grug-far').grug_far({
            prefills = {
                search = args[1],
                replacement = args[2],
                paths = args[3] or ''
            }
        })
    else
        vim.notify("Usage: FindReplace <search> <replacement> [paths]", vim.log.levels.ERROR)
    end
end, { nargs = '+' })
