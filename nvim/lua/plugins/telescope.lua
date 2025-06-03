-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  event = 'VeryLazy',
  -- branch = '0.1.x',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'jonarrien/telescope-cmdline.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  ---------------------------------------------------------------------------
  -- Runtime configuration ---------------------------------------------------
  ---------------------------------------------------------------------------
  opts = function()
    local themes = require 'telescope.themes'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    local ignore_globs = {
      '!**/.git/*',
      '!**/.venv*/*',
    }

    -- helper to build a ripgrep file list respecting ignore_globs
    local function rg_find_command()
      local cmd = {
        'rg',
        '--files',
        '--hidden',
        '--no-ignore',
        '--no-ignore-vcs', -- ignore .gitignore
      }
      for _, glob in ipairs(ignore_globs) do
        vim.list_extend(cmd, { '--glob', glob })
      end
      return cmd
    end

    -------------------------------------------------------------------------
    -- Base theme: start from Ivy then layer our overrides via deep‑extend.
    -------------------------------------------------------------------------
    local ivy = themes.get_ivy()

    return vim.tbl_deep_extend('force', ivy, {
      defaults = {
        sorting_strategy = 'ascending', -- prompt at bottom fits Ivy
        border = true,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        winblend = 0,
        path_display = {},
        layout_config = {
          width = 0.87,
          height = 0.90,
          preview_cutoff = 100,
          horizontal = { prompt_position = 'bottom', preview_width = 0.60 },
          vertical = { mirror = true },
        },
        file_ignore_patterns = { '.git/' },
        mappings = {
          i = { ['<C-Enter>'] = 'to_fuzzy_refine' },
        },
        -- Universal ripgrep arguments
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--trim',
          '--no-ignore-vcs',
          '--glob',
          '!**/.git/*',
          '--glob',
          '!**/.venv/*',
        },
      },

      -----------------------------------------------------------------------
      -- Picker‑specific adjustments (all preserved from original file)
      -----------------------------------------------------------------------
      pickers = {
        find_files = {
          follow = true,
          hidden = true,
          no_ignore = true, -- ← do NOT respect .gitignore
          no_ignore_parent = true, -- ← also ignore parent .gitignore files
          theme = 'ivy',
          find_command = rg_find_command(), -- <‑ custom ripgrep list
        },
        live_grep = { theme = 'ivy' },
        help_tags = {
          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              vim.cmd('vert rightbelow help ' .. vim.fn.fnameescape(selection.value))
            end)
            return true
          end,
        },
      },

      -----------------------------------------------------------------------
      -- Extensions ----------------------------------------------------------
      -----------------------------------------------------------------------
      extensions = {
        fzf = {
          fuzzy = true, -- enable fuzzy matching
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          themes.get_dropdown(), -- minimal dropdown for vim.ui.select
        },
        cmdline = {
          picker = {
            layout_config = { width = 120, height = 25 },
          },
          mappings = {
            complete = '<Tab>',
            run_selection = '<C-CR>',
            run_input = '<CR>',
          },
          overseer = { enabled = false },
          output_pane = { enabled = false, min_lines = 5, max_height = 25 },
        },
      },
    })
  end,

  ---------------------------------------------------------------------------
  -- Final setup & *all* original keymaps   ---------------------------------
  ---------------------------------------------------------------------------
  config = function(_, opts)
    local telescope = require 'telescope'
    telescope.setup(opts) -- single, authoritative setup

    -- Load optional C module / extensions once
    telescope.load_extension 'fzf'
    telescope.load_extension 'ui-select'
    telescope.load_extension 'cmdline'

    -------------------------------------------------------------------------
    -- Keybindings (verbatim from original file, comments kept) -------------
    -------------------------------------------------------------------------
    local builtin = require 'telescope.builtin'
    local themes = require 'telescope.themes'
    local map = vim.keymap.set

    -- Core pickers
    map('n', '<leader>fh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>fk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>fs', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    map('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>fg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    -- map('n', '<leader>fd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>fr', builtin.resume, { desc = '[S]earch [R]esume' })
    map('n', '<leader>f.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    map('n', 'Q', '<cmd>Telescope cmdline<CR>', { desc = 'Cmdline' })
    map('n', '<leader>;', '<cmd>Telescope cmdline<CR>', { desc = 'Cmdline' })
    map('n', '<leader>N', '<cmd>Telescope notify<cr>', { desc = 'Filter Notifications', noremap = true, silent = true })

    -- Themed / contextual mappings
    map('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(themes.get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    map('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Project‑specific shortcuts (kept verbatim)
    map('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [N]eovim files' })
    map('n', '<leader>fc', function()
      builtin.find_files { cwd = '/opt/chomp' }
    end, { desc = '[F]ind [C]homp files' })
    map('n', '<leader>fa', function()
      builtin.find_files { cwd = '/opt/ansible' }
    end, { desc = '[F]ind [A]nsible files' })
    map('n', '<leader>fd', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [D]otfiles' })
    map('n', '<leader>sd', function()
      builtin.find_files { cwd = vim.fn.expand '%:p:h' }
    end, { desc = '[F]ind files in [D]irectory' })
  end,
}
