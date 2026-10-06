vim.pack.add {
  { src = 'https://github.com/olimorris/codecompanion.nvim', version = vim.version.range('^19.0.0') },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
}

local cmd = vim.fn.expand '~/src/autolith/bin/autolith'
if vim.fn.executable(cmd) ~= 1 then
  cmd = 'autolith'
end

require('codecompanion').setup {
  interactions = {
    cli = {
      agent = 'autolith',
      agents = {
        autolith = {
          cmd = cmd,
          args = {},
          description = 'Autolith CLI',
          provider = 'terminal',
        },
      },
    },
  },
}

vim.cmd [[cab cc CodeCompanion]]

---Return the active CLI session, opening a new one when none exists
---@return CodeCompanion.CLI|nil
local function active_session()
  local cli = require 'codecompanion.interactions.cli'
  local instance = cli.get_visible() or cli.last_cli() or cli.create()
  if instance and not instance.ui:is_visible() then
    instance.ui:open()
  end
  return instance
end

---Return an "@relative/path:line" reference for the cursor location
---@return string|nil
local function cursor_reference()
  local name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  if name == '' then
    return nil
  end
  local line = vim.api.nvim_win_get_cursor(0)[1]
  return string.format('@%s:%d', vim.fn.fnamemodify(name, ':.'), line)
end

-- Start a new agent session
vim.keymap.set({ 'n', 'v' }, '<leader>an', function()
  require('codecompanion').cli()
  local instance = require('codecompanion.interactions.cli').last_cli()
  if instance then
    instance:focus()
  end
end, { desc = 'CodeCompanion [A]gent [N]ew session' })

-- Send the box text plus the cursor line reference to the active session
vim.keymap.set({ 'n', 'v' }, '<leader>ap', function()
  local reference = cursor_reference()
  require('codecompanion.interactions.shared.input').open {
    title = ' CodeCompanion Prompt ',
    on_submit = function(text)
      local instance = active_session()
      if not instance then
        return
      end
      if reference then
        text = string.format('%s\n%s', text, reference)
      end
      instance:send(text, { submit = true })
      instance:focus()
    end,
  }
end, { desc = 'CodeCompanion [A]gent [P]rompt at the cursor line' })
