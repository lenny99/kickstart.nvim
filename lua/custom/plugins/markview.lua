vim.pack.add { 'https://github.com/OXY2DEV/markview.nvim' }

-- Inline preview for Markdown (plus LaTeX, Typst, YAML and HTML when their
-- tree-sitter parsers are installed). Custom plugins load at the end of
-- init.lua, so this runs after the colorscheme and picks up its palette.
require('markview').setup {
  preview = {
    -- Render opencode.nvim's output panel too. Its filetype is not one of
    -- Markview's defaults, and the panel is a scratch (`nofile`) buffer,
    -- which Markview ignores by default.
    filetypes = { 'markdown', 'quarto', 'rmd', 'typst', 'asciidoc', 'opencode_output' },
    ignore_buftypes = {},
  },
}
