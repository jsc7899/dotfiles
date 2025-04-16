-- Autocompletion
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
  },
  config = function()
    local cmp = require 'cmp'
    cmp.setup {
      completion = { completeopt = 'menu,menuone,noinsert' },
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        -- ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        -- ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        -- ['<Tab>'] = cmp.mapping.confirm { select = true },
        -- If you prefer more traditional completion keymaps,
        -- you can uncomment the following lines
        -- ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<CR>'] = cmp.mapping(function(fallback)
          -- use the internal non-blocking call to check if cmp is visible
          if cmp.core.view:visible() then
            cmp.confirm { select = true }
          else
            fallback()
          end
        end),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        -- ['<C-C>'] = cmp.mapping.complete {},
        ['<C-a>'] = require('minuet').make_cmp_map(),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        per_filetype = {
          codecompanion = { 'codecompanion' },
        },
        -- {
        --   name = 'minuet',
        --   group_index = 1,
        --   priority = 100,
        -- },
      },

      performance = {
        -- It is recommended to increase the timeout duration due to
        -- the typically slower response speed of LLMs compared to
        -- other completion sources. This is not needed when you only
        -- need manual completion.
        fetching_timeout = 2000,
      },
    }
    -- Enable 'minuet' source for specific file types
    local filetypes_with_minuet = { 'python', 'sh', 'lua' }
    for _, ft in ipairs(filetypes_with_minuet) do
      cmp.setup.filetype(ft, {
        sources = cmp.config.sources {
          { name = 'minuet', group_index = 1, priority = 100 },
          { name = 'nvim_lsp' },
          { name = 'path' },
        },
      })
    end
  end,
}
