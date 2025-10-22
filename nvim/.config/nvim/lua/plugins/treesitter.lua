return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Treesitter main-branch setup

    -- map Terraform filetypes to HCL parser
    pcall(function()
      vim.treesitter.language.register("hcl", "terraform")
      vim.treesitter.language.register("hcl", "terraform-vars")
    end)

    -- core setup
    require('nvim-treesitter').setup({
      install_dir = vim.fn.stdpath('data') .. '/site'
    })

    -- install parsers (async)
    require('nvim-treesitter').install({
      'java','hcl','groovy','json','javascript','typescript','tsx','yaml','html','css',
      'markdown','markdown_inline','graphql','bash','lua','vim','dockerfile','gitignore',
      'query','vimdoc','c'
    })

    -- enable features via native Neovim APIs below



  end,
}
