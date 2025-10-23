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

    -- core setup
    local install_dir = vim.fn.stdpath('data') .. '/site'
    require('nvim-treesitter').setup({
      install_dir = install_dir,
    })
    -- ensure Neovim can find installed parsers/queries
    pcall(function()
      vim.opt.runtimepath:append(install_dir)
    end)

    -- install parsers (async)
    require('nvim-treesitter').install({
      'java','hcl','groovy','json','javascript','typescript','tsx','yaml','html','css',
      'markdown','markdown_inline','graphql','bash','lua','vim','dockerfile','gitignore',
      'query','vimdoc','c'
    })

    -- enable features via native Neovim APIs below
    -- enable folding via Treesitter
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true



  end,
}
