-- https://github.com/nvim-lualine/lualine.nvim
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',

  config = function()
    local custom_codedark = require 'lualine.themes.codedark'
    custom_codedark.normal.a.bg = '#5f8700'
    custom_codedark.normal.b.fg = '#5f8700'
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = custom_codedark,
        -- https://github.com/scottmckendry/cyberdream.nvim/blob/main/lua/lualine/themes/cyberdream.lua
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            path = 2, -- 0 filename, 1 relative path, 2 absolute path
            file_stats = true, -- readonly/modified
          },
        },
        lualine_x = { require 'minuet.lualine', 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
