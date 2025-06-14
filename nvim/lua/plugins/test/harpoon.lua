return {
  'theprimeagen/harpoon',
  global_settings = {
    -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
    save_on_toggle = false,

    -- saves the harpoon file upon every change. disabling is unrecommended.
    save_on_change = true,

    -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
    enter_on_sendcmd = false,

    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = false,

    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { 'harpoon' },

    -- set marks specific to each git branch inside git repository
    mark_branch = false,

    -- enable tabline with harpoon marks
    tabline = true,
    tabline_prefix = 'p   ',
    tabline_suffix = 's   ',
  },

  config = function()
    local mark = require 'harpoon.mark'
    vim.keymap.set('n', '<leader>m', function()
      mark.add_file()
    end)

    local ui = require 'harpoon.ui'
    vim.keymap.set('n', '<leader>ht', function()
      ui.toggle_quick_menu()
    end)

    -- todo fix
    require('telescope').load_extension 'harpoon'
    vim.keymap.set('n', '<leader>sh', function()
      toggle_telescope(harpoon)
    end, { desc = 'Open harpoon window' })
  end,
}
