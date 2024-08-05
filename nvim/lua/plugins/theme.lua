return {
  'srcery-colors/srcery-vim',
  init = function()
    -- https://github.com/srcery-colors/srcery-terminal
    -- vim.g.srcery_bg_passthrough = 0
    -- vim.g.srcery_black = '#1A1A1A'
    vim.g.srcery_bright_white = '#FFFFFF'
    vim.g.srcery_bright_black = '#737373'
    vim.g.srcery_bright_green = '#5f8700'
    -- vim.g.srcery_bg = { 'NONE', 'NONE' }
    vim.cmd.colorscheme 'srcery'
    vim.cmd.hi 'Comment gui=italic'
  end,
  -- 'scottmckendry/cyberdream.nvim',
  -- priority = 1000, -- Make sure to load this before all the other start plugins.
  -- italic_comments = true,
  -- init = function()
  --   -- Load the colorscheme here.
  --   vim.cmd.colorscheme 'cyberdream'
  --
  --   -- You can configure highlights by doing something like:
  --   vim.cmd.hi 'Comment gui=italic'
  -- end,

  -- https://github.com/andreasvc/vim-256noir
  -- 'andreasvc/vim-256noir',
  -- config = function()
  --   vim.cmd 'colorscheme 256_noir'
  --   vim.cmd.hi 'Comment gui=italic'
  -- end,
}
