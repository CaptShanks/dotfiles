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

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end


-- Function to restart LSPs using native Neovim LSP
vim.api.nvim_create_user_command("LspRestartInfo", function()
  -- Get current buffer's attached clients
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })

  if #clients == 0 then
    vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
    return
  end

  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
    -- Stop the client
    client.stop()
  end

  vim.notify("Stopping LSP clients: " .. table.concat(client_names, ", "), vim.log.levels.INFO)

  -- Wait for clients to stop, then restart by triggering FileType autocmd
  vim.defer_fn(function()
    local filetype = vim.bo[buf].filetype
    if filetype and filetype ~= "" then
      vim.cmd("doautocmd FileType " .. filetype)

      -- Check what restarted after a brief delay
      vim.defer_fn(function()
        local new_clients = vim.lsp.get_clients({ bufnr = buf })
        if #new_clients > 0 then
          local new_names = {}
          for _, client in ipairs(new_clients) do
            table.insert(new_names, client.name)
          end
          vim.notify("LSP clients restarted: " .. table.concat(new_names, ", "), vim.log.levels.INFO)
        else
          vim.notify("No LSP clients restarted", vim.log.levels.WARN)
        end
      end, 1000)
    end
  end, 500)
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
