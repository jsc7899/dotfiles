-- https://github.com/NeogitOrg/neogit
return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration

    -- Only one of these is needed, not both.
    'nvim-telescope/telescope.nvim', -- optional
    -- 'ibhagwan/fzf-lua', -- optional
  },
  config = true,

  conf = function()
    local neogit = require 'neogit'
    vim.keymap.set('n', '<leader>et', neogit.open, { silent = true, noremap = true })

    vim.keymap.set('n', '<leader>gi', ':Neogit commit<CR>', { silent = true, noremap = true })

    vim.keymap.set('n', '<leader>gp', ':Neogit pull<CR>', { silent = true, noremap = true })

    vim.keymap.set('n', '<leader>gP', ':Neogit push<CR>', { silent = true, noremap = true })

    vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', { silent = true, noremap = true })

    vim.keymap.set('n', '<leader>gB', ':G blame<CR>', { silent = true, noremap = true })
  end,
}
