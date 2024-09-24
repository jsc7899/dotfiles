-- https://github.com/tadmccorkle/markdown.nvim
return {
  'tadmccorkle/markdown.nvim',
  ft = 'markdown', -- or 'event = "VeryLazy"'
  opts = {
    -- configuration here or empty for defaults
  },
  -- config = function()
  --   vim.keymap.set('n', '<leader>toc', ':MDToc<CR><C-WL>')
  -- end,
  -- vim.api.nvim_set_keymap('n', '<leader>toc', ':MDToc<CR><C-WL>', { noremap = true, silent = true })
}
