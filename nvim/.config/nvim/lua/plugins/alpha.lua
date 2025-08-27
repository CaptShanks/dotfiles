return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
     [[=================     ===============     ===============   ========  ========]],
     [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
     [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
     [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
     [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
     [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
     [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
     [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
     [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
     [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
     [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
     [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
     [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
     [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
     [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
     [[||.=='    _-'                                                     `' |  /==.||]],
     [[=='    _-'                        N E O V I M                         \/   `==]],
     [[\   _-'                                                                `-_   /]],
     [[ `''                                                                      ``' ]],
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      -- dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"), -- Replaced by snacks explorer
      dashboard.button("SPC ee", "  > Toggle file explorer", function() require('snacks.explorer').toggle() end),
      -- dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"), -- Replaced by snacks picker
      dashboard.button("SPC ff", "󰱼 > Find File", function() require('snacks.picker').files() end),
      -- dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"), -- Replaced by snacks picker
      dashboard.button("SPC fs", "  > Find Word", function() require('snacks.picker').grep() end),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
