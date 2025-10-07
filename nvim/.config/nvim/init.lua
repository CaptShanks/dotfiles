-- reference https://www.josean.com/posts/how-to-setup-neovim-2024
    require("config.keymaps")
    require("config.options")
    require("config.lazy")
    require("config.lsp")

-- Handle jobs gracefully on exit
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.cmd("silent! LspStop")
    -- Give jobs time to cleanup
    vim.wait(100)
  end,
})
