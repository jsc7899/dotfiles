-- debug.lua

return {
  'mfussenegger/nvim-dap',
  cmd = { 'DapContinue', 'DapToggleBreakpoint', 'DapStepOver', 'DapStepInto', 'DapStepOut', 'DapTerminate' },
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',

    'theHamsta/nvim-dap-virtual-text', -- https://github.com/theHamsta/nvim-dap-virtual-text
    'Weissle/persistent-breakpoints.nvim',
  },
  config = function()
    -- DAP config
    local dap = require 'dap'
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy',
      },
    }
    vim.keymap.set('n', '<leader>dbo', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>dbc', dap.close, { desc = 'Debug: Close' })
    vim.keymap.set('n', '<leader>dbt', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>dbr', dap.restart, { desc = 'Debug: Restart' })
    vim.keymap.set('n', '<leader>dbsi', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader>dbsv', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader>dbb', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>dbl', function()
      if vim.fn.filereadable '.vscode/launch.json' then
        require('dap.ext.vscode').load_launchjs(nil, { cpptools = { 'c', 'cpp' } })
      end
      require('dap').continue()
    end, { desc = 'load debug config' })

    -- DAPUI config
    local dapui = require 'dapui'
    -- Keybindings to open, close, and toggle DAP UI
    vim.api.nvim_set_keymap('n', '<leader>dui', ':lua require("dapui").open()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>duc', ':lua require("dapui").close()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>dut', ':lua require("dapui").toggle()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>dur', ":lua require('dapui').open({reset = true})<CR>", { noremap = true })
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>dul', dapui.toggle, { desc = 'Debug: See last session result.' })

    require('nvim-dap-virtual-text').setup { virt_text_pos = 'inline' }

    vim.fn.sign_define('DapBreakpoint', { text = '⭕', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.

      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 80, -- Adjust size of the sidebar (columns)
          position = 'right', -- Can be "left" or "right"
        },
        {
          elements = {
            'console',
            'repl',
          },
          size = 0.25, -- Adjust height of the bottom window (percent of total lines)
          position = 'bottom', -- Can be "bottom" or "top"
        },
      },
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- persistent breakpoints
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
    keymap('n', '<leader>dbp', "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>", opts)
    keymap('n', '<leader>dbcl', "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>", opts)

    -- Install golang specific config
    require('dap-go').setup {
      -- :help dap-configuration
      dap_configurations = {
        {
          -- Must be "go" or it will be ignored by the plugin
          type = 'go',
          name = 'Attach remote',
          mode = 'remote',
          request = 'attach',
        },
      },
      -- delve configurations
      delve = {
        -- the path to the executable dlv which will be used for debugging.
        -- by default, this is the "dlv" executable on your PATH.
        path = '/opt/homebrew/bin/dlv',
        -- time to wait for delve to initialize the debug session.
        -- default to 20 seconds
        initialize_timeout_sec = 20,
        -- a string that defines the port to start delve debugger.
        -- default to string "${port}" which instructs nvim-dap
        -- to start the process in a random available port
        port = '${port}',
        -- additional args to pass to dlv
        args = {},
        -- the build flags that are passed to delve.
        -- defaults to empty string, but can be used to provide flags
        -- such as "-tags=unit" to make sure the test suite is
        -- compiled during debugging, for example.
        -- passing build flags using args is ineffective, as those are
        -- ignored by delve in dap mode.
        build_flags = '',
        -- whether the dlv process to be created detached or not. there is
        -- an issue on Windows where this needs to be set to false
        -- otherwise the dlv server creation will fail.
        detached = true,
        -- the current working directory to run dlv from, if other than
        -- the current working directory.
        cwd = nil,
      },
    }
  end,
}
