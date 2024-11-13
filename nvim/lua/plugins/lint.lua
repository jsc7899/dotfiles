local HOME = os.getenv 'HOME'
return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        bash = { 'shellcheck' },
        markdown = { 'markdownlint-cli2' },
        -- ansible = { 'ansible_lint' },
        -- lua = { 'luacheck' },
        python = { 'ruff' },
      }
      local markdownlint_cli2 = require('lint').linters['markdownlint-cli2']
      markdownlint_cli2.args = {
        '--config',
        -- '/opt/dotfiles/config/.markdownlint-cli2.yaml',
        HOME .. '/dotfiles/config/.markdownlint-cli2.yaml',
        '--',
      }
      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
