vim.pack.add { 'https://github.com/sudo-tee/opencode.nvim' }

require('opencode').setup {
  -- Keep the agent keymaps under <leader>a, matching the old setup
  keymap_prefix = '<leader>a',
  keymap = {
    editor = {
      ['<leader>an'] = { 'open_input_new_session', desc = 'OpenCode new session' },
      ['<leader>ap'] = { 'open_input', desc = 'OpenCode prompt' },
      ['<leader>ar'] = { 'diff_open', desc = 'OpenCode review changes' },
      ['<leader>at'] = { 'toggle', desc = 'OpenCode toggle panel' },
      ['<leader>af'] = { 'toggle_focus', desc = 'OpenCode toggle focus' },
      ['<leader>am'] = { 'configure_provider', desc = 'OpenCode select model' },
    },
  },
}
