-- Re-enabled for superior file picking with absolute paths. snacks.nvim handles other UI.
-- Based on original main branch configuration with comprehensive keybindings
return {
  "ibhagwan/fzf-lua",
  enabled = false, -- Disabled: migrated to snacks-picker
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#default-options
    -- calling `setup` is optional for customization
    local actions = require("fzf-lua").actions
    require("fzf-lua").setup({
      keymap = {
        fzf = {
          -- sets filtered items to quickfix list
          ["enter"] = "accept",
          ["ctrl-a"] = "select-all",
          ["ctrl-t"] = "toggle-all",
        },
      },
      grep = {
        rg_opts = "--hidden --follow --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      },
      files = {
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
          ["ctrl-h"] = { actions.toggle_hidden },
        },
      },
      actions = {
        ["files"] = {
          -- dont want to open multiple files in quickfix list, just edit them all on multiselect
          ["enter"] = actions.file_edit,
          ["ctrl-q"] = actions.file_sel_to_qf,

        },
      },
      winopts = {
        fullscreen = true,
        preview = {
          -- default = "bat",
          horizontal = "right:40%",
        },
      },
    })
  end,
  keys = {
    -- CORE PICKERS (based on original main branch mappings)
    {
      "<leader><space>",
      function()
        require("fzf-lua").files({
          resume = false,
        })
      end,
      desc = "Fuzzy find files in cwd"
    },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Select Buffer" },

    -- FILE PICKERS (matching original main branch behavior)
    {
      "<leader>ff",
      function()
        require("fzf-lua").files({
          cwd = vim.fn.expand("%:p:h"),
          resume = false,
        })
      end,
      desc = "Fuzzy find files in current buffer dir"
    },
    {
      "<leader>fF",
      function()
        require("fzf-lua").files({
          cwd = vim.fn.expand("%:p:h"),
          resume = true,
        })
      end,
      desc = "[Resume] Fuzzy find files in current buffer dir"
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").oldfiles({
          cwd_only = true,
          include_current_session = true,
          resume = false,
        })
      end,
      desc = "Old files in current dir"
    },
    {
      "<leader>fR",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Fuzzy find recent files across sessions"
    },

    -- GREP / SEARCH (matching original patterns)
    { "<leader>fs", "<cmd>FzfLua live_grep_glob resume=true<cr>", desc = "Live grep with rg --glob support" },
    {
      "<leader>fd",
      function()
        require("fzf-lua").live_grep_glob({
          cwd = vim.fn.expand("%:p:h"),
          resume = false,
        })
      end,
      desc = "Live grep in current buffer directory"
    },
    {
      "<leader>fD",
      function()
        require("fzf-lua").live_grep_glob({
          cwd = vim.fn.expand("%:p:h"),
          resume = true,
        })
      end,
      desc = "[Resume]Live grep in current buffer directory"
    },
    { "<leader>fc", "<cmd>FzfLua grep_cword<cr>", desc = "Find string under cursor in cwd" },
    { "<leader>fl", "<cmd>FzfLua lgrep_curbuf resume=true<cr>", desc = "Live grep in current buffer" },

    -- COMMANDS / HISTORY (from original main)
    { "<leader>:", "<cmd>FzfLua commands<cr>", desc = "FzfLua commands" },
    { "q:", "<cmd>FzfLua command_history<cr>", desc = "Command history" },

    -- ADDITIONAL USEFUL PICKERS FOR COMPREHENSIVE COVERAGE
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
    { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
    { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "Jump List" },

    -- LSP PICKERS
    { "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "LSP Definitions" },
    { "gr", "<cmd>FzfLua lsp_references<cr>", desc = "LSP References" },
    { "gi", "<cmd>FzfLua lsp_implementations<cr>", desc = "LSP Implementations" },
    { "gt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "LSP Type Definitions" },

    -- GIT PICKERS
    { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
    { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
    { "<leader>gb", "<cmd>FzfLua git_bcommits<cr>", desc = "Git Buffer Commits" },
  },
}
