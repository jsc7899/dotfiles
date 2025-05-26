return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    enabled = false,
    disable_mouse = false,
    restriction_mode = 'hint',
    restricted_keys = {
      ['h'] = { 'n', 'x' },
      -- ['j'] = { 'n', 'x' },
      -- ['k'] = { 'n', 'x' },
      ['l'] = { 'n', 'x' },
      ['+'] = { 'n', 'x' },
      ['gj'] = { 'n', 'x' },
      ['gk'] = { 'n', 'x' },
      ['<C-M>'] = { 'n', 'x' },
      ['<C-N>'] = { 'n', 'x' },
      ['<C-P>'] = { 'n', 'x' },
    },
  },
}
