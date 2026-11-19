-- Allium is not a Neovim plugin (https://github.com/juxt/allium is a skills/CLI repo).
-- Wire up the allium-lsp language server manually with Neovim's native LSP support.
-- Requires the `allium-lsp` binary on your PATH (from https://github.com/juxt/allium-tools).

-- Teach Neovim that *.allium files have filetype `allium` (ftdetect)
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPre' }, {
  pattern = '*.allium',
  callback = function()
    vim.bo.filetype = 'allium'
  end,
})

vim.lsp.config('allium', {
  cmd = { 'allium-lsp', '--stdio' },
  filetypes = { 'allium' },
  root_markers = { 'allium.config.json', '.git' },
  settings = {},
})

vim.lsp.enable('allium')

-- LSP keymaps for allium buffers (gd, K, gr are already built into native LSP)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= 'allium' then
      return
    end
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
    end
    map('gd', vim.lsp.buf.definition, 'Goto Definition')
    map('gr', vim.lsp.buf.references, 'References')
    map('K', vim.lsp.buf.hover, 'Hover')
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format')
    map('[d', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev Diagnostic')
    map(']d', function() vim.diagnostic.jump({ count = 1 }) end, 'Next Diagnostic')
    map('<leader>q', vim.diagnostic.setloclist, 'Diagnostic Loclist')
  end,
})
