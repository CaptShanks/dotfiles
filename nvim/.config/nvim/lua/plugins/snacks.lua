-- snacks.nvim aggregated replacement layer
-- Centralizes core UX previously provided by fzf-lua, telescope, nvim-tree,
-- noice/nvim-notify, indent-blankline/indentscope, toggleterm (partial), etc.
-- Rollback: remove this spec & re-enable the old plugin specs (they remain commented in their files after migration).

return {
  "folke/snacks.nvim",
  version = false,
  lazy = false, -- load early so UI modules are ready
  priority = 1000,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = {
          [[=================     ===============     ===============   ========  ========]],
          [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
            [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||]],
            [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
            [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
            [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||]],
            [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||]],
            [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||]],
            [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \\  / |-_.||]],
            [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||]],
            [[||    `'         || ||         `'    || ||    `'         || ||   | \\  / |   ||]],
            [[||            .===' `===.         .==='.`===.         .===' /==. |  \\/  |   ||]],
            [[||         .=='   \_|-_ `===. .=='   _|_   `===. .==' _-|/   `==  \\/  |   ||]],
            [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \\/  |   ||]],
            [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
            [[||.=='    _-'                                                     `' |  /==.||]],
            [[=='    _-'                        N E O V I M                         \\/   `==]],
            [[\   _-'                                                                `-_   /]],
            [[ `''                                                                      ``' ]],
        },
        keys = {
          { icon = ' ', key = 'e', desc = 'New File', action = ':enew<CR>' },
          { icon = '󰱼 ', key = 'f', desc = 'Find File', action = function() require('snacks.picker').files() end },
          { icon = ' ', key = 'g', desc = 'Live Grep', action = function() require('snacks.picker').grep() end },
          { icon = ' ', key = 'E', desc = 'Explorer', action = function() require('snacks.explorer').open() end },
          { icon = '󰁯 ', key = 's', desc = 'Sessions', action = ':SessionSearch<CR>' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa<CR>' },
        },
        footer = function()
          local stats = require('lazy').stats()
          return { ('Loaded %d/%d plugins'):format(stats.loaded, stats.count) }
        end,
      },
    },
    bigfile = { enabled = true },
    notifier = { enabled = true },
    statuscolumn = { enabled = true },
    indent = { enabled = true, scope = { enabled = true } },
    words = { enabled = true },
    scroll = { enabled = true },
    hover = { enabled = true },
    terminal = { enabled = true },
    explorer = {
      enabled = true,
      replace_netrw = true,
      width = 40,
      git = { enabled = true },
      follow = true,
      auto_close = false,
      hidden = true,
      hijack_netrw = true,
    },
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true, follow = true },
        grep = { hidden = true, follow = true, regex = false },
      },
      layout = { preset = "default" },
    },
  },
  keys = function()
    local P = require("snacks.picker")
    local E = require("snacks.explorer")

    local function curdir()
      local name = vim.api.nvim_buf_get_name(0)
      if name == "" then return vim.loop.cwd() end
      return vim.fn.fnamemodify(name, ":p:h")
    end

    return {
      -- FILES
      { "<leader> ", function() P.files({ cwd = vim.loop.cwd() }) end, desc = "Files (CWD)" },
      { "<leader>ff", function() P.files({ cwd = curdir() }) end, desc = "Files (Buffer Dir)" },
      { "<leader>fF", function() P.resume({ picker = "files", cwd = curdir() }) end, desc = "[Resume] Files (Buf Dir)" },
      { "<leader>fr", function() P.recent({ filter = { cwd = true } }) end, desc = "Recent (CWD)" },
      { "<leader>fR", function() P.recent() end, desc = "Recent (All)" },
      { "<leader>fb", function() P.buffers() end, desc = "Buffers" },
      { "<leader>fN", "<cmd>enew<CR>", desc = "New Buffer" },
      { "<leader>fx", "<cmd>BufferDelete<CR>", desc = "Close Buffer" },

      -- GREP
      { "<leader>fs", function() P.grep() end, desc = "Live Grep" },
      { "<leader>fd", function() P.grep({ cwd = curdir() }) end, desc = "Live Grep (Buf Dir)" },
      { "<leader>fD", function() P.resume({ picker = "grep" }) end, desc = "[Resume] Grep" },
      { "<leader>fc", function() P.grep_word() end, desc = "Grep Word" },
      { "<leader>fl", function() P.lines() end, desc = "Search Buffer Lines" },

      -- COMMANDS / HISTORY
      { "q:", function() P.command_history() end, mode = {"n","v"}, desc = "Command History" },
      { "<leader>:", function() P.commands() end, mode = {"n","v"}, desc = "Commands" },

      -- LSP pickers (global fallbacks if buffer not yet attached)
      { "gr", function() P.lsp_references() end, desc = "LSP References" },
      { "gi", function() P.lsp_implementations() end, desc = "LSP Implementations" },
      { "gt", function() P.lsp_type_definitions() end, desc = "LSP Type Defs" },
      { "<leader>D", function() P.diagnostics({ buffer = 0 }) end, desc = "Buffer Diagnostics" },

      -- EXPLORER (replacing nvim-tree)
      { "<leader>et", function() E.toggle() end, desc = "Explorer Toggle" },
      { "<leader>ee", function() E.focus() end, desc = "Explorer Focus" },
      { "<leader>ef", function() E.focus({ reveal = true }) end, desc = "Explorer Reveal File" },
      { "<leader>ec", function() E.close() end, desc = "Explorer Close" },
      { "<leader>er", function() E.refresh() end, desc = "Explorer Refresh" },

      -- TERMINAL (minimal replacement of toggleterm)
      { "<C-t>", function() require("snacks.terminal").toggle() end, mode = {"n","t"}, desc = "Terminal Toggle" },
    }
  end,
  config = function(_, opts)
    local Snacks = require("snacks")
    Snacks.setup(opts)
    -- Ensure Snacks picker/input become the default vim.ui handlers (so health check passes)
    if Snacks.picker and vim.ui.select ~= Snacks.picker.select then
      vim.ui.select = Snacks.picker.select
    end
    if Snacks.input and vim.ui.input ~= Snacks.input.input then
      vim.ui.input = Snacks.input.input
    end
  end,
}
