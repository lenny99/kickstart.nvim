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
  ui = {
    output = {
      rendering = {
        -- opencode's built-in Markview integration runs `:Markview render <buf>`.
        -- A user command receives its arguments as strings, but Markview's
        -- `actions.render()` requires a numeric buffer id, so it silently
        -- aborts. The panel then never re-renders after the initial attach and
        -- tables (which Markview draws with virtual text) stay raw.
        -- Call Markview's API directly with the number instead.
        on_data_rendered = function(buf)
          local ok, markview = pcall(require, 'markview.actions')
          if ok and markview.render then pcall(markview.render, buf) end
        end,
      },
    },
  },
}
