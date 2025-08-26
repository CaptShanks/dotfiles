return {
  -- Not managed by mason (brew install kcl-language-server)
  filetypes = { "kcl" },
  root_dir = function(fname)
    local util = require('lspconfig.util')
    return util.root_pattern('kcl.mod', 'kcl.yaml', '.git')(fname) or util.path.dirname(fname)
  end,
}
