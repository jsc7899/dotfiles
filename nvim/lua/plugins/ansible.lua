return {
  'mfussenegger/nvim-ansible',
  ft = { 'yaml', 'yaml.ansible' },
  config = function()
    if vim.filetype then
      vim.filetype.add {
        pattern = {
          ['.*/host_vars/.*%.ya?ml'] = 'yaml.ansible',
          ['.*/group_vars/.*%.ya?ml'] = 'yaml.ansible',
          ['.*/group_vars/.*/.*%.ya?ml'] = 'yaml.ansible',
          ['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
          ['.*/plays/.*%.ya?ml'] = 'yaml.ansible',
          ['.*/roles/.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
          ['.*/roles/.*/handlers/.*%.ya?ml'] = 'yaml.ansible',
          ['.*site%.ya?ml'] = 'yaml.ansible',
        },
      }
    else
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = {
          '*/host_vars/*.yml',
          '*/host_vars/*.yaml',
          '*/group_vars/*.yml',
          '*/group_vars/*.yaml',
          '*/group_vars/*/*.yml',
          '*/group_vars/*/*.yaml',
          '*/playbooks/*.yml',
          '*/playbooks/*.yaml',
          '.*/plays/.*%.ya?ml',
          '*/roles/*/tasks/*.yml',
          '*/roles/*/tasks/*.yaml',
          '*/roles/*/handlers/*.yml',
          '*/roles/*/handlers/*.yaml',
          '.*site%.ya?ml',
        },
        callback = function()
          vim.bo.filetype = 'yaml.ansible'
        end,
      })
    end
  end,
}
