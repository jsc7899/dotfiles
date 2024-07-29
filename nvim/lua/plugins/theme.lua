return {
  'scottmckendry/cyberdream.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  italic_comments = true,
  init = function()
    -- Load the colorscheme here.
    vim.cmd.colorscheme 'cyberdream'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=italic'
  end,

  -- https://github.com/andreasvc/vim-256noir
  -- 'andreasvc/vim-256noir',
  -- config = function()
  --   vim.cmd 'colorscheme 256_noir'
  --   vim.cmd.hi 'Comment gui=italic'
  -- end,
}
