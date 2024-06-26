return {
  'Weissle/persistent-breakpoints.nvim',
  config = function()
    require('persistent-breakpoints').setup {
      save_dir = vim.fn.stdpath 'data' .. '/nvim_checkpoints',
      -- when to load the breakpoints? "BufReadPost" is recommended.
      load_breakpoints_event = 'BufReadPost',
      -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
      perf_record = false,
      -- perform callback when loading a persisted breakpoint
      --- @param opts DAPBreakpointOptions options used to create the breakpoint ({condition, logMessage, hitCondition})
      --- @param buf_id integer the buffer the breakpoint was set on
      --- @param line integer the line the breakpoint was set on
      on_load_breakpoint = nil,
    }

    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_set_keymap
    -- Save breakpoints to file automatically.
    keymap('n', '<leader>b', "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>", opts)
    keymap('n', '<leader>dpb', "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
    keymap('n', '<leader>dbc', "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)
  end,
}
