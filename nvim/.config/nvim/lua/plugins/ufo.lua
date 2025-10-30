return {
  {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      -- UFO fold settings - let UFO manage foldmethod/foldexpr
      vim.opt.foldcolumn = '1'
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      
      -- Custom fold text handler
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      -- Setup UFO (must be called before setting keymaps)
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          -- UFO only supports {main, fallback} - max 2 providers
          -- Use Treesitter (accurate for languages with fold queries) > Indent (universal fallback)
          -- Can also use: { "lsp", "indent" } if LSP folding is preferred
          
          -- Debug: force indent provider for terraform-vars to test
          if filetype == "terraform-vars" then
            return { "indent" }
          end
          
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
      })
      
      -- Keymaps for UFO
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      
      -- Debug command for terraform-vars folding
      vim.api.nvim_create_user_command("UfoDebug", function()
        local ufo = require("ufo")
        local bufnr = vim.api.nvim_get_current_buf()
        local line = vim.fn.line(".")
        
        print("=== UFO Debug Info ===")
        print("Filetype: " .. vim.bo.filetype)
        print("Buftype: " .. vim.bo.buftype)
        print("UFO attached: " .. tostring(ufo.hasAttached(bufnr)))
        print("Foldmethod: " .. vim.wo.foldmethod)
        print("Foldenable: " .. tostring(vim.wo.foldenable))
        print("Foldlevel: " .. vim.wo.foldlevel)
        print("Current line: " .. line)
        print("Foldlevel at cursor: " .. vim.fn.foldlevel(line))
        print("Foldclosed at cursor: " .. vim.fn.foldclosed(line))
        print("Parser lang: " .. (pcall(function() return vim.treesitter.get_parser(0):lang() end) and vim.treesitter.get_parser(0):lang() or "none"))
      end, {})
    end,
  },
}
