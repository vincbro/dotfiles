vim.keymap.set({ 'n', 'v' }, 'U', '<CMD>redo<CR>', { desc = 'Redo' })

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard (before cursor)' })

vim.keymap.set({ 'n', 'v' }, 'L', 'g_', { desc = 'Select to end of line' })
vim.keymap.set({ 'n', 'v' }, 'H', '^', { desc = 'Select to start of line' })
vim.keymap.set({ 'n', 'v' }, 'J', '<C-d>', { noremap = true, desc = 'Select half-page down' })
vim.keymap.set({ 'n', 'v' }, 'K', '<C-u>', { noremap = true, desc = 'Select half-page up' })

vim.keymap.set({ 'n', 'v' }, 'M', 'm', { noremap = true, desc = 'Set Mark' })

vim.keymap.set({ 'n', 'v' }, '<leader>e', "<CMD>Oil<CR>", { desc = 'Open parent directory' })

vim.keymap.set('n', '<leader>f', '<CMD>Pick files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', '<CMD>Pick grep_live<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>d', '<CMD>Pick diagnostic<CR>', { desc = 'Live grep' })
