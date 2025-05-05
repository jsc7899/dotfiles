-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.keymap.set('i', 'jj', '<Esc>')

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- save and quit keymaps
vim.api.nvim_set_keymap('n', '<leader>x', ':w<CR>', { desc = 'save', noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>xx', ':wa<CR>:q<CR>', { desc = 'save all', noremap = true, silent = true })
vim.keymap.set('n', '<leader>Q', ':qa<CR>', { desc = 'quit all', noremap = true, silent = true })
vim.keymap.set('n', '<leader>qa', ':qa!<CR>', { desc = 'quit all without saving', noremap = true, silent = true })

-- notifications
-- vim.keymap.set('n', '<leader>hh', function()
--   require('notify').history()
-- end, { desc = 'quit all without saving', noremap = true, silent = true })

-- <space> ex opens file explorer
vim.keymap.set('n', '<leader>ex', vim.cmd.Ex)

-- <C-o> switches to last open file
vim.keymap.set('n', '<leader>o', '<C-^>', { noremap = true, silent = true })

-- disable inline diagnostics
vim.keymap.set('n', '<leader>di', function()
  local current_config = vim.diagnostic.config()
  if current_config and current_config.virtual_text ~= nil then
    vim.diagnostic.config { virtual_text = not current_config.virtual_text }
  else
    vim.diagnostic.config { virtual_text = true }
  end
end)

-- neogit

vim.keymap.set('n', '<leader>gg', ':Neogit<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gi', ':Neogit commit<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gp', ':Neogit pull<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gP', ':Neogit push<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gB', ':G blame<CR>', { silent = true, noremap = true })

-- keymap  leader gpt to run :Chatgpt
-- vim.keymap.set('n', '<leader>cc', ':ChatGPT<CR>', { silent = true, noremap = true })
-- vim.keymap.set('v', '<leader>ce', ':ChatGPTEditWithInstructions<CR>', { silent = true, noremap = true })
-- vim.keymap.set('v', '<leader><tab>', ':ChatGPTRun complete_code<CR>', { silent = true, noremap = true })
-- vim.keymap.set('v', '<leader>cf', ':ChatGPTRun fix_code_issues<CR>', { silent = true, noremap = true })

-- markdown
vim.keymap.set('n', '<leader>toc', ':MDToc<CR><C-W>L:vertical resize 35<CR>', { noremap = true, silent = true })

-- seach next newline
-- vim.keymap.set('n', '<leader>n', '/^\\n<CR>', { noremap = true, silent = true })

-- bash shebang
vim.keymap.set('n', '<leader>sh', function()
  local lines = { '#!/usr/bin/env bash', 'set -euo pipefail', '' }
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  vim.cmd 'startinsert'
end, { silent = true, noremap = true, desc = 'Insert Bash shebang' })

-- python shebang
vim.keymap.set('n', '<leader>py', function()
  local lines = { '#!/usr/bin/env python', '' }
  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
  vim.cmd 'startinsert'
end, { silent = true, noremap = true, desc = 'Insert Python shebang' })

-- quickfix
vim.keymap.set('n', '<leader>nn', '<cmd>cnext<CR>')
vim.keymap.set('n', '<leader>pp', '<cmd>cnext<CR>')
vim.keymap.set('n', '<leader>pp', '<cmd>cnext<CR>')

-- registers
-- Function to prompt for register and yank in normal mode
vim.keymap.set('n', '<leader>y', function()
  local reg = vim.fn.input 'Yank to register: '
  if reg ~= '' then
    vim.cmd('normal! "' .. reg .. 'yy')
  end
end, { noremap = true, silent = true, desc = 'Yank line to specified register' })

-- Function to prompt for register and yank in visual mode
vim.keymap.set('v', '<leader>y', function()
  local reg = vim.fn.input 'Yank to register: '
  if reg ~= '' then
    vim.cmd('normal! "' .. reg .. 'y')
  end
end, { noremap = true, silent = true, desc = 'Yank selection to specified register' })

-- Function to prompt for register and paste in normal mode
vim.keymap.set({ 'n', 'v' }, '<leader>p', function()
  local reg = vim.fn.input 'Paste from register: '
  if reg ~= '' then
    vim.cmd('normal! "' .. reg .. 'p')
  end
end, { noremap = true, silent = true, desc = 'Paste from specified register' })

-- View content of registers
vim.keymap.set('n', '<leader>r', ':registers<CR>', { noremap = true, silent = true, desc = 'View registers' })

-- Yank to system clipboard in normal and visual modes
vim.keymap.set({ 'n', 'v' }, '<leader>Y', '"+y', { noremap = true, silent = true, desc = 'Yank to system clipboard' })

-- Paste from system clipboard in normal mode
vim.keymap.set('n', '<leader>P', '"+p', { noremap = true, silent = true, desc = 'Paste from system clipboard' })
