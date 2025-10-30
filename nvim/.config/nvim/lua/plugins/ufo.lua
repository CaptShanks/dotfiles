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
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
        open_fold_hl_timeout = 400,
        close_fold_kinds_for_ft = {},
        enable_get_fold_virt_text = false,
      })
      
      -- Keymaps for UFO
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      
      -- Auto-refresh UFO for terraform-vars files (workaround for fold not updating)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "terraform-vars",
        callback = function(args)
          local ufo = require("ufo")
          -- Delay attachment to ensure treesitter is ready
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              ufo.detach(args.buf)
              ufo.attach(args.buf)
            end
          end, 100)
        end,
      })
      
      -- Force UFO to refresh folds
      vim.api.nvim_create_user_command("UfoRefresh", function()
        local ufo = require("ufo")
        local bufnr = vim.api.nvim_get_current_buf()
        
        -- Detach and reattach UFO
        ufo.detach(bufnr)
        vim.wait(100)
        ufo.attach(bufnr)
        
        print("UFO refreshed for buffer " .. bufnr)
      end, {})
      
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
        
        -- Check parser
        local parser_ok, parser = pcall(vim.treesitter.get_parser, 0)
        if parser_ok and parser then
          print("Parser lang: " .. parser:lang())
          
          -- Check for foldable nodes
          local tree = parser:parse()[1]
          local root = tree:root()
          local fold_query = vim.treesitter.query.get(parser:lang(), 'folds')
          
          if fold_query then
            local matches = {}
            for id, node in fold_query:iter_captures(root, 0) do
              local start_row = node:range()
              table.insert(matches, {row = start_row + 1, type = node:type()})
            end
            print("Foldable nodes found: " .. #matches)
            for _, m in ipairs(matches) do
              print("  Line " .. m.row .. ": " .. m.type)
            end
          else
            print("No fold query found for " .. parser:lang())
          end
        else
          print("Parser: none")
        end
      end, {})
    end,
  },
}
