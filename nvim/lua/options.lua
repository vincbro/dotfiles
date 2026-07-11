vim.o.winborder = 'none'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.showtabline = 0
vim.o.signcolumn = 'yes'
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.autoread = true
vim.o.swapfile = false
vim.o.scrolloff = 999
vim.g.mapleader = ' '
vim.cmd([[hi @lsp.type.number gui=bold]])
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

local function sync_width()
	if vim.bo.filetype == 'no-neck-pain' then
		return
	end
	local width = (vim.bo.textwidth > 0 and vim.bo.textwidth) or 80
	vim.opt_local.colorcolumn = tostring(width)
	pcall(function()
		require('no-neck-pain').resize(width)
	end)
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
	callback = sync_width,
})
