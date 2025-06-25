-- reference https://www.josean.com/posts/how-to-setup-neovim-2024
if vim.g.vscode then
    -- VSCode extension
    require("config.keymaps")
    require("config.lazy")
else
    -- ordinary Neovim
    require("config.keymaps")
    require("config.options")
    require("config.lazy")
end
