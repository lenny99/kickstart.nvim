-- Magit-style git UI: status, staging, commits, branches and log, plus
-- side-by-side diffs through diffview.nvim.
vim.pack.add {
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/sindrets/diffview.nvim',
}

require('neogit').setup {
  integrations = {
    diffview = true,
    telescope = true,
  },
}

-- Open the Neogit status buffer. Most git actions are available from there
-- with single keys (s stage, c commit, P push, F pull, b branch, l log).
vim.keymap.set('n', '<leader>gg', function()
  require('neogit').open { kind = 'split' }
end, { desc = 'Git status' })

-- Jump straight to the most common actions without opening the status buffer.
vim.keymap.set('n', '<leader>gc', function()
  require('neogit').open { 'commit' }
end, { desc = 'Git commit' })
vim.keymap.set('n', '<leader>gl', function()
  require('neogit').open { 'log' }
end, { desc = 'Git log' })
vim.keymap.set('n', '<leader>gb', function()
  require('neogit').open { 'branch' }
end, { desc = 'Git branches' })

-- Side-by-side diff of the working tree against HEAD.
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git [d]iff working tree' })
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewClose<cr>', { desc = 'Git close [D]iffview' })
