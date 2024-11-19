-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes
return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- optionally enable 24-bit colour
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

    -- mappings
    vim.keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>')
    vim.keymap.set('n', '<leader>nf', ':NvimTreeFocus<CR>')
    vim.keymap.set('n', '<leader>ns', ':NvimTreeFindFile<CR>')
    vim.keymap.set('n', '<leader>nc', ':NvimTreeCollapse<CR>')
  end,
}
