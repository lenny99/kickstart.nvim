-- Local org-work plugin: ~/Entwickler/src/org-work
-- Keeps design docs and agent-owned tasks in Org, with Beads as the ledger.
-- Requires Neovim 0.12+, org.nvim, and `bd` on PATH.
vim.pack.add {
  { src = vim.fn.expand '~/Entwickler/src/org-work' },
  { src = 'https://github.com/xheisenbugx/org.nvim' },
}

require('org-work').setup {}

local root = vim.fs.root(vim.fn.getcwd(), { '.work' }) or vim.fn.getcwd()

require('org').setup {
  org_directory = root,
  agenda_files = { root .. '/**/.work/**/*.org', root .. '/docs/**/*.org' },
  default_notes_file = root .. '/.work/hen.org',
}
