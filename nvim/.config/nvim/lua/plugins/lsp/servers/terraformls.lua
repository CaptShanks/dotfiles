return {
  filetypes = { 'terraform', 'terraform-vars', 'tf', 'tfvars' },
  root_dir = function(fname)
    local util = require('lspconfig.util')
    return util.root_pattern('.terraform', '.git')(fname) or util.path.dirname(fname)
  end,
}
