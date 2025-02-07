return {
  'sbdchd/neoformat',
  config = function()
    -- Set Ruff as the Python formatter
    vim.g.neoformat_enabled_python = { 'ruff_isort', 'ruff' }

    -- Enable Ruff to sort imports
    vim.g.neoformat_python_ruff_isort = {
      exe = 'ruff',
      args = { 'check', '--fix', '--select', 'I', '-' }, -- Fixes and sorts imports
      stdin = 1,
    }
    -- Define a custom formatter for Ruff if it's not predefined
    vim.g.neoformat_python_ruff = {
      exe = 'ruff',
      args = { 'format', '--silent', '-' }, -- Formats the file quietly using stdin
      stdin = 1,
    }

    -- Make sure both format and import sorting run together
    vim.g.neoformat_enabled_python = { 'ruff', 'ruff_isort' }

    -- Create an augroup to manage the autocommand
    vim.api.nvim_create_augroup('fmt', { clear = true })

    -- Define an autocommand that runs Neoformat before saving the buffer
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = 'fmt',
      pattern = '*.py', -- Apply only to Python files
      callback = function()
        -- Join the current changes with the upcoming Neoformat changes in the undo history
        vim.cmd 'undojoin'
        -- Run Neoformat to format the buffer and sort imports
        vim.cmd 'Neoformat'
      end,
    })
  end,
}
