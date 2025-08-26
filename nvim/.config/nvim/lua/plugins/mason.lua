return {
  "williamboman/mason.nvim",
  lazy = false, -- load immediately so that lspconfig dependency handlers have it
  priority = 1000, -- ensure very early
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- mason-lspconfig: only ensure servers not otherwise custom managed
    local mlsp = require("mason-lspconfig")
    mlsp.setup({
      ensure_installed = {
        -- keep this minimal; main list lives in lspconfig.lua to avoid duplication
        -- leaving empty so that lspconfig.lua owns ensure list
      },
    })

    -- external tools (fmt, lint) installer
    local mti = require("mason-tool-installer")
    mti.setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "black",
        "shellcheck",
        "selene",
        "markdownlint",
        "yamllint",
        "terraform_fmt",
        "tflint",
        "eslint_d",
      },
      auto_update = false,
      run_on_start = false,
    })
  end,
}
