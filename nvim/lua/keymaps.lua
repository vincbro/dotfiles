vim.keymap.set({ 'n', 'v' }, 'U', '<CMD>redo<CR>', { desc = 'Redo' })

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard (before cursor)' })

vim.keymap.set({ 'n', 'v' }, 'L', 'g_', { desc = 'Select to end of line' })
vim.keymap.set({ 'n', 'v' }, 'H', '^', { desc = 'Select to start of line' })
vim.keymap.set({ 'n', 'v' }, 'J', '<C-d>', { noremap = true, desc = 'Select half-page down' })
vim.keymap.set({ 'n', 'v' }, 'K', '<C-u>', { noremap = true, desc = 'Select half-page up' })

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
vim.keymap.set('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

vim.keymap.set({ 'n', 'v' }, 'M', 'm', { noremap = true, desc = 'Set Mark' })

vim.keymap.set({ 'n', 'v' }, '<leader>e', "<CMD>Oil<CR>", { desc = 'Open parent directory' })

vim.keymap.set('n', '<leader>f', '<CMD>Pick files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', '<CMD>Pick grep_live<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>d', '<CMD>Pick diagnostic<CR>', { desc = 'Live grep' })
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { noremap = true, silent = true })
