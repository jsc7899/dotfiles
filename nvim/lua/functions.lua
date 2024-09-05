-- Function to open a buffer with Ansible documentation for the word under the cursor
local function open_ansible_doc()
  -- Get the word under the cursor
  local word = vim.fn.expand '<cword>'

  if word == '' then
    print 'No word under the cursor.'
    return
  end

  -- Run the ansible-doc command with the word under the cursor
  local output = vim.fn.systemlist('ansible-doc ' .. word)

  -- Check if the ansible-doc command was successful
  if vim.v.shell_error ~= 0 or #output == 0 then
    print('Ansible documentation not found for: ' .. word)
    return
  end

  -- Open a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Open the buffer in a new split window
  vim.api.nvim_command 'split'
  vim.api.nvim_set_current_buf(buf)

  -- Temporarily make the buffer writable to insert the documentation
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Set buffer options for a better experience
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(buf, 'readonly', true)

  -- Run the AnsiEsc command to apply ANSI color escape sequences
  vim.api.nvim_command 'AnsiEsc'
end

-- Bind <leader>ad to open Ansible documentation for the word under the cursor
vim.api.nvim_set_keymap('n', '<leader>ad', ':lua require("functions").open_ansible_doc()<CR>', { noremap = true, silent = true })

-- Export the function if needed elsewhere
return {
  open_ansible_doc = open_ansible_doc,
}
