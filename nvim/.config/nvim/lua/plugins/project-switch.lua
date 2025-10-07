-- Project switcher plugin for navigating between git repositories
-- Now using external project-switcher.nvim repository

return {
  "CaptShanks/project-switcher.nvim",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim", -- Enhanced vim.ui.select for better picker UI
  },
  config = function()
    require("project-switcher").setup({
      -- Customize these directories to match where your git repos are located
      search_dirs = {
        "~/",
        "~/projects",
        "~/code",
        "~/work",
        "~/dev",
        "~/dotfiles",
        "~/Documents/git", -- Added git folder in Documents
        -- Add more directories where you keep git repos
      },
      additional_folders = {
        "/Users/sjc-lp03742/Documents/temp",
      },
      max_depth = 3,
      show_hidden = false, -- Set to true if you want to see repos like .config, .dotfiles
      use_cache = true,
    })

    -- Disable default keymaps since we define our own
    vim.g.project_switcher_no_default_keymaps = true
  end,
  keys = {
    -- Main project switcher
    {
      "<leader>fp",
      function()
        require("project-switcher").pick_project()
      end,
      desc = "Switch Project",
    },

    -- Refresh project cache
    {
      "<leader>fP",
      function()
        require("project-switcher").refresh_projects()
      end,
      desc = "Refresh Projects",
    },

    -- Quick access to common directories (these change nvim's working directory)
    {
      "<leader>fh",
      function()
        vim.cmd("cd ~")
        vim.notify("Changed to home directory")
      end,
      desc = "Go to Home",
    },
    {
      "<leader>fC",
      function()
        vim.cmd("cd " .. vim.fn.stdpath("config"))
        vim.notify("Changed to nvim config")
      end,
      desc = "Go to Config",
    },
  },
}
