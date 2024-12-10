-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- automatically determine filetype for ansible
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '/opt/ansible*/*.yaml' },
  command = 'set filetype=yaml.ansible',
})

-- Create an autocommand to adjust tab settings for yaml.ansible files
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
  pattern = { '*.yml', '*.yaml' },
  callback = function()
    if vim.bo.filetype == 'yaml.ansible' then
      vim.bo.expandtab = true -- Use spaces instead of tabs
      vim.bo.shiftwidth = 2 -- Size of an indent
      vim.bo.tabstop = 2 -- Number of spaces tabs count for
      vim.bo.softtabstop = 2 -- See tabstops at 2 spaces
    end
  end,
})

-- Enable spell checking for markdown and .md files
vim.api.nvim_create_autocmd({ 'FileType', 'BufRead', 'BufNewFile' }, {
  pattern = { 'markdown', '*.md' },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { 'en_us' }
  end,
})
