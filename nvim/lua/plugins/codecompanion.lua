return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'j-hui/fidget.nvim',
  },
  -- cmd = { 'CodeCompanion', 'CodeCompanionActions', 'CodeCompanionChat' }, -- Load only when commands are used
  keys = {
    { '<Leader>ca', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Actions' },
    { '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr><cmd>set ft=markdown<cr>', mode = { 'n', 'v' }, desc = 'Toggle CodeCompanion Chat' },
    { '<Leader>cv', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'CodeCompanion Inline' },
  },
  opts = {
    adapters = {
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          schema = {
            model = {
              default = 'gpt-4.1-mini',
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
      ['4.1-nano'] = {
        strategy = 'inline',
        description = 'inline 4.1-nano',
        opts = {
          index = 1,
          is_default = false,
          is_slash_cmd = false,
          user_prompt = true,
          placement = 'add',
          adapter = {
            name = 'openai',
            model = '4.1-nano',
          },
        },
        prompts = {
          {
            role = 'system',
            content = function(context)
              return 'I want you to act as a senior '
                .. context.filetype
                .. ' developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.'
            end,
          },
          {
            role = 'user',
            content = function(context)
              local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

              return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
      ['o3-mini'] = {
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
    },
  },
  init = function()
    require('plugins.codecompanion.fidget-spinner'):init()
  end,
}
