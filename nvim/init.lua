vim.opt.winborder = "none"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.signcolumn = "yes"
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.o.relativenumber = true
vim.g.mapleader = " "
vim.cmd([[hi @lsp.type.number gui=bold]])

vim.pack.add({
	-- UI & Theme
	{ src = "https://github.com/zenbones-theme/zenbones.nvim" },
	{ src = "https://github.com/rktjmp/lush.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },

	-- Navigation
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	{ src = "https://github.com/nvim-mini/mini.files" },
	{ src = "https://github.com/max397574/better-escape.nvim" },
	{ src = "https://github.com/ThePrimeagen/harpoon",                       version = "harpoon2" },

	-- LSP & Completion
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/Saghen/blink.cmp",                           version = vim.version.range("*") },
	{ src = "https://github.com/folke/lazydev.nvim" },

	-- Syntax & Highlighting
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },

	-- Editing & Keymaps
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/nvim-mini/mini.pairs" },
	{ src = "https://github.com/abecodes/tabout.nvim" },
	{ src = "https://github.com/wansmer/treesj" },

	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	-- Utilities
	{ src = "https://github.com/ThePrimeagen/99" },
	{ src = "https://github.com/folke/persistence.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/nvim-mini/mini.extra" },
})


-- 99
local _99 = require("99")
_99.setup({
	provider = _99.Providers.GeminiCLIProvider,
	-- model = "gemini-3.1-pro-preview",
	model = "auto",
	tmp_dir = "./.tmp",
	completion = {
		custom_rules = {
			vim.fn.expand("~/Documents/skills/"),
		},
	}

})
vim.keymap.set("v", "<leader>q", function()
	_99.visual({})
end, { desc = 'Query 99' })
vim.keymap.set({ "n", "v" }, "<leader>9x", function()
	_99.stop_all_requests()
end, { desc = 'Kill all 99 requests' })
vim.keymap.set("n", "<leader>9s", function()
	_99.search({})
end, { desc = 'Search 99' })

-- Persistence
local persistence = require("persistence")
persistence.setup()
vim.keymap.set("n", "<leader>ss", function() persistence.load() end, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>sl", function() persistence.load({ last = true }) end,
	{ desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>sd", function() persistence.stop() end, { desc = "Don't Save Current Session" })
vim.keymap.set("n", "<leader>sS", function() require("persistence").select() end, { desc = "Select a session to load" })
vim.api.nvim_create_autocmd("VimEnter", {
	nested = true,
	callback = function()
		if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
			local session = persistence.current()
			if session and vim.fn.filereadable(session) ~= 0 then
				if vim.fn.confirm("Load last session?", "&Yes\n&No", 1) == 1 then
					persistence.load()
				end
			end
		end
	end,
})

-- Setups
require("mini.surround").setup(
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
require("mini.pairs").setup({})
require('mini.extra').setup()
require('render-markdown').setup({})
require("better_escape").setup()
require("fidget").setup({})
require("tabout").setup({
	ignore_beginning = false
})
require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"icon",
	},
	float = {
		max_width = 0.3,
		max_height = 0.6,
		border = "rounded",
	},
})

require('mini.pick').setup()

-- Keymaps
vim.keymap.set({ 'n', 'v' }, 'U', '<CMD>redo<CR>', { desc = 'Redo' })

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard (before cursor)' })

vim.keymap.set({ 'n', 'v' }, 'L', 'g_', { desc = "Select to end of line" })
vim.keymap.set({ 'n', 'v' }, 'H', '^', { desc = "Select to start of line" })
vim.keymap.set({ 'n', 'v' }, 'J', '<C-d>', { noremap = true, desc = "Select half-page down" })
vim.keymap.set({ 'n', 'v' }, 'K', '<C-u>', { noremap = true, desc = "Select half-page up" })

vim.keymap.set({ 'n', 'v' }, 'M', 'm', { noremap = true, desc = "Set Mark" })



vim.keymap.set({ "n", "v" }, "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set('n', '<leader>f', "<CMD>Pick files<CR>", { desc = 'Find files' })
vim.keymap.set('n', '<leader>g', "<CMD>Pick grep_live<CR>", { desc = 'Live grep' })
vim.keymap.set('n', '<leader>d', "<CMD>Pick diagnostic<CR>", { desc = 'Live grep' })

local tto = require("nvim-treesitter-textobjects")
local ttos = require("nvim-treesitter-textobjects.select")
tto.setup({})
vim.keymap.set({ "x", "o" }, "af", function()
	ttos.select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	ttos.select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	ttos.select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	ttos.select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
	ttos.select_textobject("@local.scope", "locals")
end)

local treesj = require("treesj")
treesj.setup({
	use_default_keymaps = false,
})
vim.keymap.set('n', '<leader>m', treesj.toggle)

-- Theme
vim.cmd("set termguicolors")
vim.cmd("set bg=dark")
vim.cmd.colorscheme("zenwritten")
require('lualine').setup({
	options = {
		component_separators = "",
		section_separators = "",
		theme = 'zenwritten',
		globalstatus = true,
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
})

require("lsp")
