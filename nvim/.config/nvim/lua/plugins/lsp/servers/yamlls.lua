return {
  filetypes = { 'yaml', 'yml', 'helm' },
  settings = {
    yaml = {
      schemas = {
        kubernetes = '**/templates/**.yaml',
      },
      completion = true,
      hover = true,
    },
  },
}
