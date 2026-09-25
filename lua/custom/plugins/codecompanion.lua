return {
  'olimorris/codecompanion.nvim',
  version = '^19.0.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  cmd = {
    'CodeCompanion',
    'CodeCompanionChat',
    'CodeCompanionCLI',
    'CodeCompanionCmd',
    'CodeCompanionActions',
  },
  init = function()
    vim.cmd [[cab cc CodeCompanion]]
  end,
  keys = {
    { '<C-a>', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = '[C]odeCompanion [A]ctions' },
    { '<LocalLeader>a', '<cmd>CodeCompanionCLI<cr>', mode = { 'n', 'v' }, desc = 'Toggle the [A]gent CLI' },
    {
      '<LocalLeader>cp',
      function()
        return require('codecompanion').cli { prompt = true }
      end,
      mode = { 'n', 'v' },
      desc = '[C]odeCompanion [P]rompt the agent',
    },
    {
      '<LocalLeader>ca',
      function()
        return require('codecompanion').cli('#{this}', { focus = false })
      end,
      mode = { 'n', 'v' },
      desc = '[C]odeCompanion [A]dd context to the agent',
    },
    {
      '<LocalLeader>cd',
      function()
        return require('codecompanion').cli('#{diagnostics} Can you fix these?', { focus = false, submit = true })
      end,
      mode = 'n',
      desc = '[C]odeCompanion send [D]iagnostics to the agent',
    },
    {
      '<LocalLeader>ct',
      function()
        return require('codecompanion').cli('#{terminal} Sharing the output from the terminal. Can you fix it?', { focus = false, submit = true })
      end,
      mode = 'n',
      desc = '[C]odeCompanion send [T]erminal output to the agent',
    },
  },
  opts = function()
    local cmd = vim.fn.expand '~/src/autolith/bin/autolith'
    if vim.fn.executable(cmd) ~= 1 then
      cmd = 'autolith'
    end

    return {
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
  end,
}
