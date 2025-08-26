return {
  filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
  root_dir = function(fname)
    local util = require('lspconfig.util')
    return util.root_pattern('graphql.config.*', '.graphqlrc.*', '.graphql.config.*', 'schema.graphql')(fname) or util.find_git_ancestor(fname) or vim.loop.cwd()
  end,
}
