return {
  "cormacrelf/dark-notify",
  enabled = false, -- set to true to enable
  config = function()
    -- Theme Configuration - Change only these two lines!
    local DARK_THEME = "tokyonight-night"
    local LIGHT_THEME = "tokyonight-day"

    local dn = require("dark_notify")

    -- Set initial colorscheme based on current background
    local initial_mode = vim.o.background == "light" and "light" or "dark"
    if initial_mode == "dark" then
      vim.cmd("colorscheme " .. DARK_THEME)
    else
      vim.cmd("colorscheme " .. LIGHT_THEME)
    end

    -- Configure https://github.com/cormacrelf/dark-notify
    dn.run({
      schemes = {
        dark = {
          background = "dark",
          colorscheme = DARK_THEME,
        },
        light = {
          background = "light",
          colorscheme = LIGHT_THEME,
        },
      },
      onchange = function(mode)
        -- Ensure mode is valid
        if mode ~= "dark" and mode ~= "light" then
          mode = "dark" -- fallback to light mode
        end

        if mode == "dark" then
          vim.o.background = "dark"
          vim.cmd("colorscheme " .. DARK_THEME)
        else
          vim.o.background = "light"
          vim.cmd("colorscheme " .. LIGHT_THEME)
        end

        -- Refresh UI components after theme change
        vim.cmd("redraw!")
      end,
    })
  end,
}
