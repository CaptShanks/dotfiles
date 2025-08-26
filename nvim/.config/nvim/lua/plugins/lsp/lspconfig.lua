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

    -- (Reverted) previously removed builtin copilot definition to avoid duplicate client.
    -- Keeping default lspconfig copilot plus copilot.lua as per user request.

    -- import mason_lspconfig plugin (mason already initialized in its own spec)
    local mason_ok, _ = pcall(require, "mason")
    if not mason_ok then
      vim.notify("mason.nvim not loaded before lspconfig; check mason.lua spec", vim.log.levels.ERROR)
    end
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin

    -- Wrapper restart with notification
    vim.api.nvim_create_user_command("LspRestartInfo", function()
      local before = {}
      for _, c in ipairs(vim.lsp.get_active_clients()) do
        before[c.id] = c.name
      end
      vim.cmd("LspRestart")
      vim.defer_fn(function()
        local after_names = {}
        local seen = {}
        for _, c in ipairs(vim.lsp.get_active_clients()) do
          if not seen[c.name] then
            table.insert(after_names, c.name)
            seen[c.name] = true
          end
        end
        table.sort(after_names)
        if #after_names == 0 then
          vim.notify("LSP restart: no active clients", vim.log.levels.INFO)
          return
        end
        vim.notify("LSP restarted: " .. table.concat(after_names, ", "), vim.log.levels.INFO)
      end, 150)
    end, { desc = "Restart LSP and show restarted clients" })
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

        opts.desc = "Restart LSP (info)"
        keymap.set("n", "<leader>r", ":LspRestartInfo<CR>", opts)
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

    -- Dynamic per-server configuration discovery
    local server_dir = vim.fn.stdpath('config') .. '/lua/plugins/lsp/servers'
    local server_files = {}
    local scan_ok, fs = pcall(require, 'plenary.scandir')
    if scan_ok then
      server_files = fs.scan_dir(server_dir, { depth = 1, add_dirs = false, search_pattern = '%.lua$' })
    else
      -- fallback to vim.loop if plenary missing
      local uv = vim.loop
      local fd = uv.fs_scandir(server_dir)
      if fd then
        while true do
          local name, t = uv.fs_scandir_next(fd)
          if not name then break end
            if name:match('%.lua$') then
              table.insert(server_files, server_dir .. '/' .. name)
            end
        end
      end
    end

    local per_server = {}
    for _, filepath in ipairs(server_files) do
      local modname = filepath:match('plugins/lsp/(servers/.+)%.lua$')
      if modname then
        local ok, conf = pcall(require, 'plugins.lsp.' .. modname:gsub('/', '.'))
        if ok and type(conf) == 'table' then
          local server = conf.name or filepath:match('([^/]+)%.lua$')
          per_server[server] = conf
        end
      end
    end

    -- Setup servers via mason-lspconfig (ensure mason already configured above)
    local ensure = { "bashls", "lua_ls", "graphql", "terraformls", "helm_ls", "gopls", "pyright", "yamlls" }

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
          local conf = per_server[server_name] or {}
          conf.capabilities = vim.tbl_deep_extend('force', capabilities, conf.capabilities or {})
          if conf.on_attach == nil then
            -- rely on LspAttach autocmd for keymaps; allow custom on_attach in file
          end
          lspconfig[server_name].setup(conf)
        end,
      },
    })

    -- Manually setup servers not managed by mason (e.g., kcl)
    if per_server["kcl"] then
      local conf = per_server["kcl"]
      conf.capabilities = vim.tbl_deep_extend('force', capabilities, conf.capabilities or {})
      lspconfig.kcl.setup(conf)
    end

    return -- done
  end,
}
