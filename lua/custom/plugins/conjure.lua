return {
  'Olical/conjure',
  ft = { 'lisp', 'asd' },
  init = function()
    vim.g['conjure#filetypes#lisp#command'] = {
      'sbcl',
      '--eval', '(ql:quickload :swank)',
      '--eval', '(swank:create-server :dont-close t :port 4005)',
    }
    vim.g['conjure#debug'] = true

    vim.keymap.set('n', '<leader>cs', '<cmd>ConjureSchool<cr>', { desc = '[C]onjure [S]chool' })
    vim.keymap.set('n', '<leader>cl', '<cmd>ConjureLog<cr>',    { desc = '[C]onjure [L]og' })
    vim.keymap.set('n', '<leader>ci', '<cmd>ConjureInterrupt<cr>', { desc = '[C]onjure [I]nterrupt' })
  end,
  dependencies = {
    {
      'PaterJason/cmp-conjure',
      ft = { 'lisp', 'asd' },
      config = function()
        local cmp = require('cmp')
        local config = cmp.get_config()
        config.sources = config.sources or {}
        table.insert(config.sources, { name = 'conjure' })
        cmp.setup(config)
      end,
    },
  },
}