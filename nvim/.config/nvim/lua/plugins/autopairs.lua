return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "saghen/blink.cmp",
  },
  enabled = true,
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")

    -- configure autopairs
    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })

    -- Rely on blink.cmp's built-in auto_brackets on accept
    -- (see blink-cmp.lua: completion.accept.auto_brackets.enabled = true)
  end,
}
