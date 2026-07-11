require('options')

vim.pack.add({
	-- UI & Theme
	{ src = 'https://github.com/vague-theme/vague.nvim' },
	{ src = "https://github.com/alexvzyl/nordic.nvim" },
	{ src = "https://github.com/cocopon/iceberg.vim" },
	{ src = "https://github.com/savq/melange-nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
	{ src = "https://github.com/zenbones-theme/zenbones.nvim" },
	{ src = "https://github.com/ramojus/mellifluous.nvim" },

	{ src = 'https://github.com/rktjmp/lush.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.icons' },
	{ src = 'https://github.com/nvim-mini/mini.statusline' },
	{ src = 'https://github.com/folke/snacks.nvim' },


	-- Navigation
	{ src = 'https://github.com/nvim-mini/mini.pick' },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/cbochs/grapple.nvim' },
	{ src = 'https://github.com/max397574/better-escape.nvim' },

	-- LSP & Completion
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/Saghen/blink.cmp',                           version = vim.version.range('*') },
	{ src = 'https://github.com/folke/lazydev.nvim' },

	-- Syntax & Highlighting
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
	{ src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },

	-- Editing & Keymaps
	{ src = 'https://github.com/nvim-mini/mini.surround' },
	{ src = 'https://github.com/nvim-mini/mini.pairs' },
	{ src = 'https://github.com/abecodes/tabout.nvim' },
	{ src = 'https://github.com/wansmer/treesj' },

	-- Git
	{ src = 'https://github.com/lewis6991/gitsigns.nvim' },

	-- Utilities
	{ src = 'https://github.com/nvim-mini/mini.sessions' },
	{ src = 'https://github.com/j-hui/fidget.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.extra' },
	{ src = 'https://github.com/shortcuts/no-neck-pain.nvim' },
	{ src = 'https://github.com/folke/twilight.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.indentscope' },
})

-- Setups
require('no-neck-pain').setup({
	width = 80,
	autocmds = {
		enableOnVimEnter = false,
	},
	mappings = {
		enabled = true,
		scratchPad = false,
	},
})

require('mini.indentscope').setup()
require('mini.surround').setup(
	{
		highlight_duration = 500,
		mappings = {
			add = 'ms',
			delete = 'md',
			find = 'mf',
			find_left = 'mF',
			highlight = 'mh',
			replace = 'mr',

			suffix_last = 'N',
			suffix_next = 'n',
		},
	})

local function keep_single_center_window()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'no-neck-pain' then
			vim.api.nvim_set_current_win(win)
			break
		end
	end
	pcall(vim.cmd, 'only')
end

require('mini.sessions').setup({
	autoread = true,
	hooks = {
		pre = { write = keep_single_center_window },
		post = {
			read = function()
				keep_single_center_window()
				require('no-neck-pain').enable()
			end,
		},
	},
})

vim.api.nvim_create_autocmd('VimEnter', {
	once = true,
	callback = function()
		vim.schedule(function()
			if vim.v.this_session == '' then
				require('no-neck-pain').enable()
			end
		end)
	end,
})
require('mini.pairs').setup({})
require('mini.statusline').setup({})
local icons = require('mini.icons')
icons.setup({})
icons.mock_nvim_web_devicons()
require('mini.extra').setup()
require('oil').setup({})
require('render-markdown').setup({})
require('fidget').setup({})
require('tabout').setup({
	ignore_beginning = false
})

require('mini.pick').setup()

require('twilight').setup({})

require('keymaps')

local grapple = require('grapple')
grapple.setup({
	scope = 'git',
})

vim.keymap.set('n', '<leader>j', grapple.toggle, { desc = 'Grapple toggle tag' })
vim.keymap.set('n', '<leader>l', grapple.toggle_tags, { desc = 'Grapple open tags' })
for i = 1, 9 do
	vim.keymap.set('n', '<leader>' .. i, function()
		grapple.select({
			index = i,
		})
	end, { desc = 'Grapple select ' .. i })
end

local tto = require('nvim-treesitter-textobjects')
local ttos = require('nvim-treesitter-textobjects.select')
tto.setup({})
vim.keymap.set({ 'x', 'o' }, 'af', function()
	ttos.select_textobject('@function.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'if', function()
	ttos.select_textobject('@function.inner', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ac', function()
	ttos.select_textobject('@class.outer', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'ic', function()
	ttos.select_textobject('@class.inner', 'textobjects')
end)
vim.keymap.set({ 'x', 'o' }, 'as', function()
	ttos.select_textobject('@local.scope', 'locals')
end)

local treesj = require('treesj')
treesj.setup({
	use_default_keymaps = false,
})
vim.keymap.set('n', '<leader>m', treesj.toggle)

-- Theme
vim.cmd('set termguicolors')
vim.cmd('set bg=dark')
vim.cmd.colorscheme('iceberg')


require('better_escape').setup()

require('lsp')
