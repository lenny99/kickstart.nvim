vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }

-- The plugin provides seamless Ctrl+hjkl mappings. Add Alt+arrows too.
vim.keymap.set('n', '<M-Left>', '<cmd>TmuxNavigateLeft<cr>', { desc = 'Move left across splits and tmux panes' })
vim.keymap.set('n', '<M-Down>', '<cmd>TmuxNavigateDown<cr>', { desc = 'Move down across splits and tmux panes' })
vim.keymap.set('n', '<M-Up>', '<cmd>TmuxNavigateUp<cr>', { desc = 'Move up across splits and tmux panes' })
vim.keymap.set('n', '<M-Right>', '<cmd>TmuxNavigateRight<cr>', { desc = 'Move right across splits and tmux panes' })
