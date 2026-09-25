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

vim.keymap.set({ 'n', 'v' }, '<C-a>', '<cmd>CodeCompanionActions<cr>', { desc = '[C]odeCompanion [A]ctions' })
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>a', '<cmd>CodeCompanionCLI<cr>', { desc = 'Toggle the [A]gent CLI' })
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>cp', function()
  return require('codecompanion').cli { prompt = true }
end, { desc = '[C]odeCompanion [P]rompt the agent' })
vim.keymap.set({ 'n', 'v' }, '<LocalLeader>ca', function()
  return require('codecompanion').cli('#{this}', { focus = false })
end, { desc = '[C]odeCompanion [A]dd context to the agent' })
vim.keymap.set('n', '<LocalLeader>cd', function()
  return require('codecompanion').cli('#{diagnostics} Can you fix these?', { focus = false, submit = true })
end, { desc = '[C]odeCompanion send [D]iagnostics to the agent' })
vim.keymap.set('n', '<LocalLeader>ct', function()
  return require('codecompanion').cli('#{terminal} Sharing the output from the terminal. Can you fix it?', { focus = false, submit = true })
end, { desc = '[C]odeCompanion send [T]erminal output to the agent' })
