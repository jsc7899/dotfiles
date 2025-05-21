-- https://github.com/folke/trouble.nvim
return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' },
  cmd = 'Trouble',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      '<leader>tt',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>tT',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>tL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>tQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
  -- keys = {
  --   { '<leader>tt', '<cmd>TroubleToggle<CR>' },
  --   { '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<CR>' },
  --   { '<leader>td', '<cmd>TroubleToggle document_diagnostics<CR>' },
  --   { '<leader>tq', '<cmd>TroubleToggle quickfix<CR>' },
  --   { '<leader>tl', '<cmd>TroubleToggle loclist<CR>' },
  --   { '<leader>to', '<cmd>ToDoTrouble<CR>' },
  -- },
}
