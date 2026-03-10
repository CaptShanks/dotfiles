local function copilot_enabled()
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then
    return false
  end

  local plugin = lazy_config.plugins["copilot.lua"] or lazy_config.plugins["zbirenbaum/copilot.lua"]
  return plugin ~= nil and plugin.enabled ~= false
end

local function copilot_provider()
  return {
    name = "copilot",
    module = "blink-cmp-copilot",
    score_offset = 100,
    async = true,
    transform_items = function(_, items)
      local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
      local kind_idx = #CompletionItemKind + 1
      CompletionItemKind[kind_idx] = "Copilot"
      for _, item in ipairs(items) do
        item.kind = kind_idx
      end
      return items
    end,
  }
end

return {
  "saghen/blink.cmp",
  lazy = false,
  version = "v1.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "giuxtaposition/blink-cmp-copilot",
      enabled = copilot_enabled,
    },
  },
  opts = function()
    local default_sources = { "lsp", "path", "snippets", "buffer" }
    local providers = {}

    if copilot_enabled() then
      table.insert(default_sources, "copilot")
      providers.copilot = copilot_provider()
    end

    return {
      keymap = {
        preset = "default",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      sources = {
        default = default_sources,
        providers = providers,
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = false,
        },
      },

      signature = {
        enabled = true,
      },

      snippets = {
        preset = "luasnip",
      },
    }
  end,
  opts_extend = { "sources.default" },
}
