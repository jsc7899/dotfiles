return {
  'stevearc/conform.nvim',
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff', 'ruff_format' }, -- Use ruff_format for Python
        markdown = { 'markdownlint-cli2' },
        bash = { 'beautysh' },
        zsh = { 'beautysh' },
        go = { 'gofmt' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      formatters = {
        ruff = {
          command = 'ruff',
          args = { 'check', '--select', 'I', '--fix', '--exit-zero', '-' },
          stdin = true,
        },
      },
    }

    -- Define a user command for manual formatting
    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      require('conform').format { async = true, lsp_format = 'fallback', range = range }
    end, { range = true })
  end,
}
