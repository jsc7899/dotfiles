return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'j-hui/fidget.nvim',
  },
  cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' }, -- Load only when commands are used
  keys = {
    { '<Leader>cv', '<cmd>CodeCompanion<cr>', mode = 'v', desc = 'Run CodeCompanion' },
    { '<Leader>ca', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Actions' },
    { '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'Toggle CodeCompanion Chat' },
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = 'Add to CodeCompanion Chat' },
  },
  config = function()
    require('codecompanion').setup {
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            schema = {
              model = {
                default = 'gpt-4o',
              },
              reasoning_effort = {
                default = 'high',
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
          keymaps = {
            accept_change = {
              modes = { n = 'ga' },
              description = 'Accept the suggested change',
            },
            reject_change = {
              modes = { n = 'gr' },
              description = 'Reject the suggested change',
            },
          },
        },
      },
      display = {
        inline = {
          layout = 'vertical', -- vertical|horizontal|buffer
        },
        diff = {
          enabled = false,
          -- close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          -- layout = 'vertical', -- vertical|horizontal split for default provider
          -- opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
          -- provider = 'default', -- default|mini_diff
        },
      },
      prompt_library = {
        ['Code Expert'] = {
          strategy = 'inline',
          description = 'Get some special advice from an LLM',
          opts = {
            -- mapping = '<Leader>ce',
            -- modes = { 'v' },
            short_name = 'expert',
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = false,
            placement = 'replace',
            -- adapter = {
            --   name = 'openai',
            --   model = 'o3-mini',
            --   reasoning_effort = {
            --     default = 'low',
            --   },
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                return 'You are a senior ' .. context.filetype .. ' developer. ' .. text .. ''
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ['Fixer'] = {
          strategy = 'inline',
          description = 'Fix code',
          opts = {
            short_name = 'fixer',
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = false,
            placement = 'replace',
            ignore_system_prompt = true,
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                return 'You are a senior ' .. context.filetype .. ' developer. Identify and fix any errors the follwing code \n' .. text .. '\n```\n\n'
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ['Ansible Expert'] = {
          strategy = 'inline',
          description = 'Get ansible help from an LLM',
          opts = {
            short_name = 'ansible',
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = false,
            placement = 'replace',
            ignore_system_prompt = true,
            adapter = {
              name = 'openai',
              model = 'gpt-4o',
              -- reasoning_effort = {
              --   default = 'medium',
              -- },
            },
          },
          prompts = {
            {
              role = 'system',
              content = function(context)
                local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
                return 'You are an expert in Ansible. Your only goal is to write one or more Ansible tasks, not a playbook. Under no circumstances should you output hosts:, ---, or any part of a playbook structure. You must use fully qualified module names. You must follow Ansible best practices and adhere to ansible-lint guidelines.\n'
                  .. text
                  .. '\n'
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    }
    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd [[cab cc CodeCompanion]]

    vim.keymap.set('v', '<Leader>ce', function()
      require('codecompanion').prompt 'expert'
    end, { noremap = true, silent = true, desc = 'expert' })

    vim.keymap.set('v', '<Leader>cf', function()
      require('codecompanion').prompt 'fixer'
    end, { noremap = true, silent = true, desc = 'fixer' })

    vim.keymap.set('v', '<Leader>cn', function()
      require('codecompanion').prompt 'fixer'
    end, { noremap = true, silent = true, desc = 'ansible' })
  end,
}
