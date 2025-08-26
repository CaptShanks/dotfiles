return {
  -- name inferred as filename (bashls)
  filetypes = { "bash", "sh" },
  root_dir = function(fname)
    return require('lspconfig.util').root_pattern('.git')(fname) or vim.loop.cwd()
  end,
}
