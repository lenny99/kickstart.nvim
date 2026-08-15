return {
  'flix/nvim',
  name = 'Flix',
  lazy = false,
  config = function()
    require('flix').setup {
      cmd = { 'java', '-jar', '/opt/flix/flix.jar', 'lsp' },
      filetypes = { 'flix' },
      --root_dir = function(bufnr)
      --  return vim.fs.root(bufnr, { 'flix.toml' })
      --    or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')
      --end,
    }
    vim.lsp.enable 'flix'
  end,
}
