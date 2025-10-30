return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Treesitter main-branch setup (new API)
    require('nvim-treesitter').setup({
      install_dir = vim.fn.stdpath('data') .. '/site',
    })

    -- Map terraform-vars filetype to hcl parser (terraform-vars has no dedicated parser)
    vim.treesitter.language.register('hcl', 'terraform-vars')

    -- Install parsers (async, only if not already installed)
    require('nvim-treesitter').install({
      'java', 'hcl', 'groovy', 'json', 'javascript', 'typescript', 'tsx', 'yaml', 'html', 'css',
      'markdown', 'markdown_inline', 'graphql', 'bash', 'lua', 'vim', 'dockerfile', 'gitignore',
      'query', 'vimdoc', 'c', 'python', 'toml', 'sql', 'go', 'rust', 'terraform'
    })

    -- Enable treesitter highlighting for common filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {
        -- Languages
        'lua', 'vim', 'bash', 'sh', 'python', 'javascript', 'typescript', 'go', 'rust', 'java', 'groovy', 'c',
        -- Data formats
        'json', 'yaml', 'toml', 'xml',
        -- Markup/Documentation
        'markdown', 'html', 'css',
        -- DevOps/Infrastructure
        'dockerfile', 'terraform', 'terraform-vars', 'hcl',
        -- Database
        'sql',
        -- Other
        'graphql', 'tsx', 'jsx'
      },
      callback = function()
        vim.treesitter.start()
      end,
    })

    -- setup autotag
    require("nvim-ts-autotag").setup()
  end,
}
