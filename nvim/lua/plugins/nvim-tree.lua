-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  cmd = { 'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFindFile', 'NvimTreeFocus', 'NvimTreeCollapse' }, -- Load only when a command is used
  keys = {
    { '<leader>nt', ':NvimTreeToggle<CR>', desc = 'Toggle NvimTree' },
    { '<leader>nf', ':NvimTreeFocus<CR>', desc = 'Focus NvimTree' },
    { '<leader>ns', ':NvimTreeFindFile<CR>', desc = 'Find file in NvimTree' },
    { '<leader>nc', ':NvimTreeCollapse<CR>', desc = 'Collapse NvimTree' },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    -- Disable netrw at the very start
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Enable 24-bit color support
    vim.opt.termguicolors = true

    require('nvim-tree').setup {
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    }
  end,
}
