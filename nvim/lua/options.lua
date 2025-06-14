-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable swap
vim.opt.swapfile = false

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = false

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99

-- Spelling
vim.opt.spelllang = 'en_us'
--vim.opt.spell = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- vim.opt.guicursor = 'n-v-c-i:block'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- theme options
vim.opt.termguicolors = true

-- filetypes
vim.filetype.add {
  extension = {
    nomad = 'hcl',
    bashrc = 'bash',
  },
  pattern = {
    ['/opt/.*/searches/.*'] = 'spl',
    ['[.]?blerc'] = 'bash',
    ['.*/ansible/.*/.*%.ya?ml'] = 'yaml.ansible',
    ['.*.typ?st'] = 'typst',
  },
}

-- Set tab width to 2 specifically for markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
  end,
})

-- change register for delete
-- vim.api.nvim_set_keymap('n', 'd', '"dd', { noremap = true })
-- vim.api.nvim_set_keymap('x', 'd', '"dd', { noremap = true })

-- set paste mode so that text is pasted to the left of the cursor (on the block cursor) automatically
-- Normal mode remaps
-- vim.keymap.set('n', 'p', 'P', { noremap = true })
-- vim.keymap.set('n', 'P', 'p', { noremap = true })

-- Visual mode remaps
-- vim.keymap.set('v', 'p', 'P', { noremap = true })
-- vim.keymap.set('v', 'P', 'p', { noremap = true })

vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
