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
    { '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr><cmd>set ft=markdown<cr>', mode = { 'n', 'v' }, desc = 'Toggle CodeCompanion Chat' },
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = 'Add to CodeCompanion Chat' },
  },
  opts = {
    adapters = {
      opts = {
        show_defaults = true,
      },
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
      action_palette = {
        width = 95,
        height = 10,
        prompt = 'Prompt ', -- Prompt used for interactive LLM calls
        provider = 'telescope', -- default|telescope|mini_pick
        opts = {
          show_default_actions = false, -- Show the default actions in the action palette?
          show_default_prompt_library = false, -- Show the default prompt library in the action palette?
        },
      },
      inline = {
        layout = 'vertical', -- vertical|horizontal|buffer
      },
      diff = {
        enabled = false,
      },
    },
    prompt_library = {
      ['4o-mini inline'] = {
        strategy = 'inline',
        description = 'Prompt the LLM from Neovim',
        opts = {
          index = 1,
          is_default = false,
          is_slash_cmd = false,
          user_prompt = true,
          placement = 'add',
          adapter = {
            name = 'openai',
            model = 'gpt-4o-mini',
          },
        },
        prompts = {
          {
            role = 'system',
            content = function(context)
              return string.format(
                [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
                context.filetype
              )
            end,
            opts = {
              visible = false,
              tag = 'system_tag',
            },
          },
        },
      },
      ['4o-mini chat'] = {
        strategy = 'chat',
        description = 'Chat with 4o-mini',
        opts = {
          index = 2,
        },
        prompts = {
          {
            role = 'system',
            content = '',
          },
          {
            role = 'user',
            content = '',
          },
        },
      },
      ['o3-mini inline'] = {
        strategy = 'inline',
        description = 'Prompt the LLM from Neovim',
        opts = {
          index = 3,
          is_default = false,
          is_slash_cmd = false,
          user_prompt = true,
          placement = 'add',
          adapter = {
            name = 'openai',
            model = 'o3-mini',
          },
        },
        prompts = {
          {
            role = 'system',
            content = function(context)
              return string.format(
                [[I want you to act as a senior %s developer. I will ask you specific questions and I want you to return raw code only (no codeblocks and no explanations). If you can't respond with code, respond with nothing]],
                context.filetype
              )
            end,
            opts = {
              visible = false,
              tag = 'system_tag',
            },
          },
        },
      },
      ['o3-mini chat'] = {
        strategy = 'chat',
        description = 'Chat with o3-mini',
        opts = {
          index = 4,
        },
        prompts = {
          {
            role = 'system',
            content = '',
          },
          {
            role = 'user',
            content = '',
          },
        },
      },
      ['Code Expert'] = {
        strategy = 'inline',
        description = 'Get some special advice from an LLM',
        opts = {
          -- mapping = '<Leader>ce',
          -- modes = { 'v' },
          index = 5,
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
          index = 6,
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
          index = 7,
          visible = false,
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
  },
  -- config = function()
  --   -- Expand 'cc' into 'CodeCompanion' in the command line
  --   vim.cmd [[cab cc CodeCompanion]]
  --
  --   vim.keymap.set('v', '<Leader>ce', function()
  --     require('codecompanion').prompt 'expert'
  --   end, { noremap = true, silent = true, desc = 'expert' })
  --
  --   vim.keymap.set('v', '<Leader>cf', function()
  --     require('codecompanion').prompt 'fixer'
  --   end, { noremap = true, silent = true, desc = 'fixer' })
  --
  --   vim.keymap.set('v', '<Leader>cn', function()
  --     require('codecompanion').prompt 'fixer'
  --   end, { noremap = true, silent = true, desc = 'ansible' })
  -- end,
  init = function()
    require('plugins.codecompanion.fidget-spinner'):init()
  end,
}
