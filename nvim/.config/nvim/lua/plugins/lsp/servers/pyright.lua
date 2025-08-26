return {
  filetypes = { 'python' },
  root_dir = function(fname)
    local util = require('lspconfig.util')
    return util.root_pattern('pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git')(fname) or util.path.dirname(fname)
  end,
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'basic',
      },
    },
  },
}
