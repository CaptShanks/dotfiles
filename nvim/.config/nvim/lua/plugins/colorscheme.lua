return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "day", -- The theme is used when the background is set to light
        transparent = true, -- Enable transparent background
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "transparent", -- style for sidebars, see below
          floats = "transparent", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
        hide_inactive_statusline = false, -- Enabling this option will hide inactive statuslines
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
      })
      vim.cmd([[colorscheme tokyonight]])
      -- Using style = "night" above forces dark theme always
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = true,
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    enabled = true,
    priority = 1000,
  },
  -- Additional colorschemes
  {
    "GustavoPrietoP/doom-themes.nvim",
    enabled = true,
    priority = 1000,
  },
  {
    "sontungexpt/witch",
    enabled = true,
    priority = 1000,
  },
  {
    "0xstepit/flow.nvim",
    enabled = true,
    priority = 1000,
  },
  {
    "glepnir/zephyr-nvim",
    enabled = true,
    priority = 1000,
  },
}
