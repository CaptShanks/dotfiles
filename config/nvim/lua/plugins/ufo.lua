return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      -- Neovim code-fold settings
      -- vim.opt.foldmethod = 'syntax'
      -- vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- vim.opt.foldcolumn = '1'
      -- vim.opt.foldtext = ''
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldnestmax = 4
      vim.opt.foldcolumn = '1'
      vim.opt.foldenable = true
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'lsp', 'indent' }
        end,
      }
    end,
  },
}
