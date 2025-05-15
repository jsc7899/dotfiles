-- https://cmp.saghen.dev/installation
return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'milanglacier/minuet-ai.nvim' },
  -- dependencies = { 'milanglacier/minuet-ai.nvim', 'nvim-lua/plenary.nvim', 'rafamadriz/friendly-snippets' },
  -- after = 'minuet-ai.nvim',
  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = function()
    return {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-h>'] = { 'show', 'show_documentation', 'hide_documentation' },
        -- Manually invoke minuet completion.
        ['<C-a>'] = require('minuet').make_blink_map(),
      },
      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = { auto_show = false },
        trigger = {
          prefetch_on_insert = true,
          show_on_keyword = true, -- open after typing letters/numbers
          show_on_trigger_character = true, -- open after LSP trigger chars
        },
        menu = {
          auto_show = true,
        },
        ghost_text = { enabled = true },
      },

      fuzzy = { implementation = 'rust' },

      sources = {
        -- Enable minuet for autocomplete
        default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
        -- For manual completion only, remove 'minuet' from default
        providers = {
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            async = true,
            -- Should match minuet.config.request_timeout * 1000,
            -- since minuet.config.request_timeout is in seconds
            timeout_ms = 5000,
            score_offset = 50, -- Gives minuet higher priority among suggestions
          },
        },
      },
    }
  end,

  -- Set ghost text to a lighter gray with no background and italics
  vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', {
    fg = '#999999',
    bg = 'NONE',
    italic = true,
  }),
  opts_extend = { 'sources.default' },
}
