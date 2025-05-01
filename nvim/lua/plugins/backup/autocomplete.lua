-- Autocompletion
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'saadparwaiz1/cmp_luasnip', -- snippet completions
    'L3MON4D3/LuaSnip', -- snippet engine
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    cmp.setup {
      -- don't auto-insert or select; show menu and ghost-text
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
        ghost_text = true,
      },

      mapping = {
        ['<C-B>'] = cmp.mapping.complete(), -- manual trigger
        ['<CR>'] = cmp.mapping.confirm { select = true },

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-a>'] = require('minuet').make_cmp_map(), -- AI trigger
      },

      sources = cmp.config.sources {
        { name = 'minuet', group_index = 1, priority = 1000 },
        { name = 'nvim_lsp', priority = 900 },
        { name = 'luasnip', priority = 800 },
        { name = 'path', priority = 700 },
        { name = 'buffer', priority = 600 },
      },

      formatting = {
        format = function(entry, vim_item)
          local icons = {
            minuet = '[AI]',
            nvim_lsp = '[LSP]',
            luasnip = '[SNIP]',
            path = '[PATH]',
            buffer = '[BUF]',
          }
          vim_item.menu = icons[entry.source.name] or ''
          return vim_item
        end,
      },

      performance = {
        debounce = 100, -- ms after last keystroke
        fetching_timeout = 3000, -- ms before giving up on slow sources
      },
    }

    -- filetype-specific overrides now optional, since `minuet` is in global sources
  end,
}
