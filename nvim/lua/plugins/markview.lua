-- https://github.com/OXY2DEV/markview.nvim
return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  config = function(_, opts)
    local presets = require 'markview.presets'

    require('markview').setup {
      preview = {
        enable = true,
        filetypes = { 'md', 'rmd', 'quarto', 'typst', 'markdown' },
        -- ignore_buftypes = { 'nofile' },
        ignore_buftypes = {},
        ignore_previews = {},

        modes = { 'n', 'no', 'c' },
        hybrid_modes = {},
        debounce = 50,
        draw_range = { vim.o.lines, vim.o.lines },
        edit_range = { 1, 0 },

        callbacks = {},

        splitview_winopts = { split = 'left' },
      },
      markdown = {
        enable = true,

        block_quotes = {},
        code_blocks = {
          label_direction = 'left',
        },
        headings = presets.headings.glow,
        horizontal_rules = {},
        list_items = {
          enable = true,
          wrap = true,
          indent_size = 0,
          shift_width = 1,
        },
        metadata_plus = {},
        metadata_minus = {},
        tables = {},
      },
      markdown_inline = {
        enable = true,

        block_references = {},
        checkboxes = {},
        emails = {},
        embed_files = {},
        entities = {},
        escapes = {},
        footnotes = {},
        highlights = {},
        hyperlinks = {},
        images = {},
        inline_codes = {},
        internal_links = {},
        uri_autolinks = {},
      },
      typst = {
        enable = true,

        code_blocks = {
          text_direction = 'left',
        },
        code_spans = {},
        escapes = {},
        headings = {},
        labels = {},
        list_items = {},
        math_blocks = {},
        math_spans = {},
        raw_blocks = {
          label_direction = 'right',
        },
        raw_spans = {},
        reference_links = {},
        subscripts = {},
        superscript = {},
        symbols = {},
        terms = {},
        url_links = {},
      },
      yaml = {
        enable = true,

        properties = {},
      },
    }
  end,
}
