return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- mason & mason-lspconfig now configured in separate early-loading mason.lua
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    { "towolf/vim-helm" },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- remove builtin copilot lspconfig (to avoid duplicate client with copilot.lua)
    local ok_configs, configs = pcall(require, "lspconfig.configs")
    if ok_configs and configs.copilot then
      configs.copilot = nil
    end

    -- import mason_lspconfig plugin (mason already initialized in its own spec)
    local mason_ok, _ = pcall(require, "mason")
    if not mason_ok then
      vim.notify("mason.nvim not loaded before lspconfig; check mason.lua spec", vim.log.levels.ERROR)
    end
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Go to definition"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- opts.desc = "Show LSP definitions"
        -- keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>FzfLua lsp_definitions<CR>", opts)

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>r", ":LspRestartSafe<CR>", opts)
      end,
    })

    -- bashls will be installed & started via mason-lspconfig handlers (no manual autostart needed)

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- KCL, Install language server from Brew, dont use mason: https://github.com/kcl-lang/kcl.nvim/issues/18
    lspconfig.kcl.setup({})

    -- helm https://github.com/mrjosh/helm-ls?tab=readme-ov-file#nvim-lspconfig-setup
    lspconfig.helm_ls.setup({
      settings = {
        ["helm-ls"] = {
          yamlls = {
            path = "yaml-language-server",
            config = {
              schemas = {
                kubernetes = "**/templates/**",
              },
              completion = true,
              hover = true,
              -- any other config from https://github.com/redhat-developer/yaml-language-server#language-server-settings
            },
          },
        },
      },
    })

    -- Safe LSP restart command that skips non-standard virtual clients like copilot
    vim.api.nvim_create_user_command("LspRestartSafe", function()
      local clients = vim.lsp.get_active_clients()
      for _, client in ipairs(clients) do
        if client.name ~= "copilot" then
          client.stop(true)
        end
      end
      vim.defer_fn(function()
        -- Reattach by triggering FileType which lspconfig uses via mason-lspconfig handlers
        local bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(bufs) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
            vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
          end
        end
      end, 100)
    end, { desc = "Restart active LSP servers except Copilot" })

    -- Setup servers via mason-lspconfig (ensure mason already configured above)
    local ensure = { "bashls", "html", "cssls", "lua_ls", "graphql", "terraformls", "helm_ls", "gopls", "jedi_language_server" }

    -- Rotate LSP log automatically if > 50MB when loading this plugin
    do
      local log = vim.lsp.log.get_filename()
      pcall(function()
        local stat = vim.loop.fs_stat(log)
        if stat and stat.size > 50 * 1024 * 1024 then
          local suffix = os.date('%Y%m%d-%H%M%S')
          local rotated = log .. '.' .. suffix
          os.rename(log, rotated)
          vim.notify(('Rotated large LSP log (%.1f MB) to %s'):format(stat.size/1024/1024, rotated), vim.log.levels.WARN)
        end
      end)
    end

    mason_lspconfig.setup({
      ensure_installed = ensure,
      handlers = {
        function(server_name)
          lspconfig[server_name].setup({ capabilities = capabilities })
        end,
        terraformls = function()
          lspconfig.terraformls.setup({
            capabilities = capabilities,
            filetypes = { "terraform", "terraform-vars", "tf", "tfvars" },
          })
        end, -- added tf/tfvars explicitly
        graphql = function()
          lspconfig.graphql.setup({
            capabilities = capabilities,
            filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
          })
        end,
        lua_ls = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                completion = { callSnippet = "Replace" },
              },
            },
          })
        end,
        bashls = function()
          lspconfig.bashls.setup({ capabilities = capabilities })
        end,
      },
    })

    return -- done
  end,
}
