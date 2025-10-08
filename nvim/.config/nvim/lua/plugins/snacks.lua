-- snacks.nvim aggregated replacement layer
-- Centralizes core UX previously provided by fzf-lua, telescope, nvim-tree,
-- noice/nvim-notify, indent-blankline/indentscope, toggleterm (partial), etc.
-- Rollback: remove this spec & re-enable the old plugin specs (they remain commented in their files after migration).

return {
  "folke/snacks.nvim",
  enabled = true, -- Re-enabled with scroll module fix
  version = false,
  lazy = false, -- load early so UI modules are ready
  priority = 1000,
  -- Fix deactivate module error by patching the metatable before any access
  init = function()
    -- Create a stub package.preload entry for snacks.deactivate
    package.preload["snacks.deactivate"] = function()
      return function()
        return true
      end
    end

    -- Additional early fix
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      once = true,
      callback = function()
        local ok, snacks = pcall(require, "snacks")
        if ok and not snacks.deactivate then
          snacks.deactivate = function()
            return true
          end
        end
      end,
    })
  end,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = {
          [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
          [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
          [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
          [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
          [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
          [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        },
        keys = {
          { icon = " ", key = "e", desc = "New File", action = "enew" },
          {
            icon = "󰱼 ",
            key = "f",
            desc = "Find File",
            action = function()
              require("snacks.picker").files()
            end,
          },
          {
            icon = " ",
            key = "g",
            desc = "Live Grep",
            action = function()
              require("snacks.picker").grep()
            end,
          },
          { icon = " ", key = "t", desc = "nvim-tree", action = ":NvimTreeToggle<CR>" },
          { icon = "󰁯 ", key = "s", desc = "Sessions", action = ":SessionSearch<CR>" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa<CR>" },
        },
        layout = {
          { section = "header", padding = 1 },
          { section = "keys", padding = 1 },
          { section = "footer", padding = 1 },
        },
        footer = function()
          local stats = require("lazy").stats()
          return { ("Loaded %d/%d plugins"):format(stats.loaded, stats.count) }
        end,
      },
    },
    bigfile = { enabled = false },
    notifier = { enabled = true },
    statuscolumn = { enabled = true },
    indent = { enabled = true, scope = { enabled = true } },
    words = { enabled = true },
    scroll = { enabled = false }, -- Disabled: interferes with G key navigation
    hover = { enabled = true },
    terminal = { enabled = true },
    explorer = {
      enabled = false, -- Disabled in favor of nvim-tree
    },
    lazygit = { enabled = true },
    picker = {
      enabled = true,
      prompt = " ",
      focus = "input",
      ui_select = true,
      auto_close = true,
      -- Layout configuration with dynamic preset selection
      layout = {
        layout = {
          box = "horizontal",
          width = 0.95,
          min_width = 120,
          height = 0.95,
          {
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
          { win = "preview", title = "{preview}", border = "rounded", width = 0.3 },
        },
      },
      -- layout = {
      --   cycle = true,
      --   preset = function()
      --     return vim.o.columns >= 120 and "telescope" or "vertical"
      --   end,
      -- },
      -- Enhanced matcher configuration
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        sort_empty = false,
        filename_bonus = true,
        file_pos = true,
        cwd_bonus = true,
        frecency = true,
        history_bonus = false,
      },

      -- Sort configuration
      sort = {
        fields = { "score:desc", "#text", "idx" },
      },

      -- Formatter configurations
      formatters = {
        file = {
          filename_first = true,
          truncate = 200,
          filename_only = false,
          icon_width = 2,
          git_status_hl = true,
        },
        text = {
          ft = nil,
        },
        selected = {
          show_always = false,
          unselected = true,
        },
      },

      -- Source-specific configurations
      sources = {
        files = {
          hidden = false, -- Include hidden files/directories (dotfiles)
          ignored = false, -- Include ignored files (git submodules, etc.)
          follow = true,
        },
        grep = {
          hidden = false,
          ignored = false,
          regex = true,
          live = true,
          need_search = true,
        },
        buffers = {
          sort_lastused = true,
          current = true,
          hidden = false,
          unloaded = true,
          nofile = true,
          modified = false,
        },
        recent = {
          filter = { cwd = false },
        },
      },

      -- Toggles configuration
      toggles = {
        follow = "f",
        hidden = "h",
        ignored = "i",
        modified = "m",
        regex = { icon = "R", value = false },
      },

      -- Icons configuration
      icons = {
        files = {
          enabled = true,
          dir = "󰉋 ",
          dir_open = "󰝰 ",
          file = "󰈔 ",
        },
        git = {
          enabled = true,
          staged = "●",
          added = "",
          deleted = "",
          modified = "○",
          untracked = "?",
        },
      },

      -- Enhanced window keybindings
      win = {
        input = {
          keys = {
            -- Enhanced navigation
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },
            ["<Down>"] = { "list_down", mode = { "i", "n" } },
            ["<Up>"] = { "list_up", mode = { "i", "n" } },

            -- Actions
            ["<CR>"] = { "confirm", mode = { "n", "i" } },
            ["<Esc>"] = "cancel",
            ["<C-c>"] = { "cancel", mode = "i" },
            ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
            ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },

            -- Split/tab actions
            ["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
            ["<C-s>"] = { "edit_split", mode = { "i", "n" } },
            ["<C-t>"] = { "tab", mode = { "n", "i" } },

            -- Toggles
            ["<A-p>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<A-h>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<A-i>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<A-f>"] = { "toggle_follow", mode = { "i", "n" } },
            ["<C-g>"] = { "toggle_live", mode = { "i", "n" } },

            -- History navigation
            ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
            ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },

            -- Insert helpers
            ["<C-r><C-w>"] = { "insert_cword", mode = "i" },
            ["<C-r><C-f>"] = { "insert_file", mode = "i" },
            ["<C-r>%"] = { "insert_filename", mode = "i" },

            -- Selection and other
            ["<C-a>"] = { "select_all", mode = { "n", "i" } },
            ["<C-q>"] = { "qflist", mode = { "i", "n" } },
            ["?"] = "toggle_help_input",
            ["/"] = "toggle_focus",
          },
        },
        list = {
          keys = {
            -- Enhanced list navigation
            ["j"] = "list_down",
            ["k"] = "list_up",
            ["G"] = "list_bottom",
            ["gg"] = "list_top",
            ["<C-d>"] = "list_scroll_down",
            ["<C-u>"] = "list_scroll_up",

            -- Actions
            ["<CR>"] = "confirm",
            ["<2-LeftMouse>"] = "confirm",
            ["<Esc>"] = "cancel",
            ["q"] = "close",

            -- Selection
            ["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
            ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
            ["<C-a>"] = "select_all",

            -- Preview scrolling
            ["<C-f>"] = "preview_scroll_down",
            ["<C-b>"] = "preview_scroll_up",

            -- Focus and help
            ["i"] = "focus_input",
            ["/"] = "toggle_focus",
            ["?"] = "toggle_help_list",
          },
        },
      },
    },
  },
  keys = function()
    local S = require("snacks")
    local P = require("snacks.picker")
    local E = require("snacks.explorer")

    return {
      {
        "<leader>G",
        function()
          S.lazygit()
        end,
        desc = "Lazy Git",
      },
      { "<leader>fN", "<cmd>enew<CR>", desc = "New Buffer" },
      { "<leader>fx", "<cmd>BufferDelete<CR>", desc = "Close Buffer" },

      -- TERMINAL (minimal replacement of toggleterm)
      {
        "<C-t>",
        function()
          require("snacks.terminal").toggle()
        end,
        mode = { "n", "t" },
        desc = "Terminal Toggle",
      },

      -- Core pickers
      {
        "<leader><space>",
        function()
          P.smart()
        end,
        desc = "Smart Find",
      },
      {
        "<leader>fb",
        function()
          P.buffers()
        end,
        desc = "Buffers",
      },

      -- File pickers
      {
        "<leader>ff",
        function()
          P.files({ cwd = vim.fn.getcwd() })
        end,
        desc = "Files (CWD)",
      },
      {
        "<leader>fF",
        function()
          P.files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Find Files (current dir)",
      },
      {
        "<leader>fr",
        function()
          P.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fR",
        function()
          P.recent({ filter = { cwd = true } })
        end,
        desc = "Recent Files (cwd)",
      },

      -- Grep/Search pickers
      {
        "<leader>fs",
        function()
          P.grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>fd",
        function()
          P.grep({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Grep (current dir)",
      },
      {
        "<leader>fD",
        function()
          P.grep({ cwd = vim.fn.expand("%:p:h"), live = true })
        end,
        desc = "Live Grep (current dir)",
      },
      {
        "<leader>fc",
        function()
          P.grep_word()
        end,
        desc = "Grep word under cursor",
      },
      {
        "<leader>fl",
        function()
          P.lines()
        end,
        desc = "Lines in open buffers",
      },

      -- Commands and History
      {
        "<leader>:",
        function()
          P.commands()
        end,
        desc = "Commands",
      },
      {
        "q:",
        function()
          P.command_history()
        end,
        desc = "Command History",
      },

      -- Additional pickers
      {
        "<leader>fh",
        function()
          P.help()
        end,
        desc = "Help Tags",
      },
      {
        "<leader>fk",
        function()
          P.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fm",
        function()
          P.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>fj",
        function()
          P.jumps()
        end,
        desc = "Jumps",
      },

      -- LSP pickers
      {
        "gd",
        function()
          P.lsp_definitions()
        end,
        desc = "LSP: Go to Definition",
      },
      {
        "gr",
        function()
          P.lsp_references()
        end,
        desc = "LSP: References",
      },
      {
        "gi",
        function()
          P.lsp_implementations()
        end,
        desc = "LSP: Implementations",
      },
      {
        "gt",
        function()
          P.lsp_type_definitions()
        end,
        desc = "LSP: Type Definitions",
      },

      -- Git pickers
      {
        "<leader>gs",
        function()
          P.git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gc",
        function()
          P.git_log()
        end,
        desc = "Git Commits",
      },
      {
        "<leader>gb",
        function()
          P.git_branches()
        end,
        desc = "Git Branches",
      },
    }
  end,
  config = function(_, opts)
    local ok, Snacks = pcall(require, "snacks")
    if not ok then
      vim.notify("Failed to load snacks.nvim", vim.log.levels.ERROR)
      return
    end

    Snacks.setup(opts)

    -- Ensure Snacks picker/input become the default vim.ui handlers
    if Snacks.picker and vim.ui.select ~= Snacks.picker.select then
      vim.ui.select = Snacks.picker.select
    end
    if Snacks.input and vim.ui.input ~= Snacks.input.input then
      vim.ui.input = Snacks.input.input
    end
  end,
}
