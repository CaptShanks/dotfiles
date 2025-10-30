   -- https://gpanders.com/blog/whats-new-in-neovim-0-11/
-- LSP settings
   -- Enable the lsp-servers
local servers = {
  'lua_ls',
  'gopls',
  'bashls',
  'pyright',
  'terraformls',
  'yamlls',
  'graphql',
  'helm_ls',
  'kcl'
}

-- Add folding capabilities for UFO
-- This enables LSP servers to provide folding range information
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    }
  }
})

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end


-- Function to restart LSPs using native Neovim LSP
vim.api.nvim_create_user_command("LspRestartInfo", function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  
  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.WARN)
    return
  end
  
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
    vim.notify("Restarting: " .. client.name, vim.log.levels.INFO)
    -- Stop and immediately restart using stored config
    local config = client.config
    vim.lsp.stop_client(client.id, true)
    vim.lsp.start(config)
  end
  
  -- Ensure Treesitter highlighting is maintained after LSP restart
  vim.defer_fn(function()
    if vim.treesitter.highlighter.active[buf] then
      vim.treesitter.stop(buf)
    end
    vim.treesitter.start(buf)
  end, 100)
  
  vim.notify("Restarted: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
end, { desc = "Restart LSP clients for current buffer using native LSP" })


-- Diagnostics
vim.diagnostic.config({
  -- Use the default configuration
  -- virtual_lines = true

  -- Alternatively, customize specific options
  virtual_lines = {
    -- Only show virtual line diagnostics for the current cursor line
    current_line = true,
  },
})
