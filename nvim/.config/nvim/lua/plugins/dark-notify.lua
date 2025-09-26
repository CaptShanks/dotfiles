return {
  "cormacrelf/dark-notify",
  config = function()
    local dn = require("dark_notify")

    -- Configure https://github.com/cormacrelf/dark-notify
    dn.run({
      schemes = {
        dark = {
          background = "dark",
          colorscheme = "tokyonight-night"
        },
        light = {
          background = "light", 
          colorscheme = "tokyonight-night"
        }
      },
      onchange = function(mode)
        -- Ensure mode is valid
        if mode ~= "dark" and mode ~= "light" then
          mode = "light" -- fallback to light mode
        end

        if mode == "dark" then
          vim.o.background = "dark"
          vim.cmd([[colorscheme tokyonight-night]])
        else
          vim.o.background = "light"
          vim.cmd([[colorscheme tokyonight-night]])
          -- vim.cmd([[colorscheme gruvbox]])
        end

        -- for all windows except the current one, set background based on dark mode
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if win ~= vim.api.nvim_get_current_win() then
            set_background_based_dark_mode(win, false)
          end
        end
      end,
    })
  end,
}
