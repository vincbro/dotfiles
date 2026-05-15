vim.opt.winborder = "none"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 4
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
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },

	-- Navigation
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },

	-- LSP & Completion
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/Saghen/blink.cmp",                         version = vim.version.range("*") },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },

	-- Syntax & Highlighting
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },

	-- Editing & Keymaps
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/nvim-mini/mini.pairs" },

	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	-- Utilities
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/ThePrimeagen/99" },
	{ src = "https://github.com/folke/persistence.nvim" },
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
require("actions-preview").setup({})
require('render-markdown').setup({})
require("which-key").setup()

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
vim.keymap.set({ "n", "v" }, "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
require('telescope').setup({
	defaults = {
		mappings = {
			i = {
				["<Tab>"] = actions.move_selection_next,
				["<S-Tab>"] = actions.move_selection_previous,
			},
			n = {
				["<Tab>"] = actions.move_selection_next,
				["<S-Tab>"] = actions.move_selection_previous,
			}
		}
	}
})
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>d', function()
	builtin.diagnostics({ bufnr = 0 })
end, { desc = "Document Diagnostics" })
vim.keymap.set('n', '<leader>D', builtin.diagnostics, { desc = "Workspace Diagnostics" })

require("bufferline").setup({})
vim.keymap.set({ 'n', 'v' }, '<Tab>', "<CMD>BufferLineCycleNext<CR>", { desc = 'Next buffer' })
vim.keymap.set({ 'n', 'v' }, '<S-Tab>', "<CMD>BufferLineCyclePrev<CR>", { desc = 'Prev buffer' })
vim.keymap.set({ 'n', 'v' }, '<leader>x', "<CMD>bd<CR>", { desc = 'Close buffer' })
vim.keymap.set({ 'n', 'v' }, '<leader>X', "<CMD>bd!<CR>", { desc = 'Force close buffer' })

-- Theme
vim.cmd("set termguicolors")
vim.cmd("set bg=dark")
vim.cmd.colorscheme("vague")
require('lualine').setup({
	options = {
		theme = 'vague',
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

-- LSP
require('gitsigns').setup({})

vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	virtual_lines = true,
	signs = true,
	update_in_insert = false,
})
require("blink.cmp").setup({
	keymap = {
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },

		["<CR>"] = { "accept", "fallback" },
	},
	completion = {
		list = {
			selection = {
				auto_insert = true
			}
		}
	}
})
vim.lsp.enable({
	"lua_ls", "cssls", "svelte", "tinymist", "basedpyright", "jsonls",
	"rust_analyzer", "clangd", "ruff",
	"glsl_analyzer", "haskell-language-server", "hlint",
	"intelephense", "tailwindcss", "ts_ls",
	"emmet_language_server", "emmet_ls", "solargraph", "zls", "pyright",
	"nil_ls", "nixd", "zls", "taplo"
})
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})
vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "basic",
				reportAny = false,
				reportUnknownMemberType = false,
				reportUnknownArgumentType = false,
			}
		}
	}
})
vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
				extraArgs = {
					"--",
					"-W", "clippy::all",
				},
			}
		}
	}
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local buf = vim.lsp.buf

		vim.keymap.set({ "n", "v" }, "<leader>k", buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP Hover' }))
		vim.keymap.set({ "n", "v" }, "gD", buf.declaration, vim.tbl_extend('force', opts, { desc = 'LSP Declaration' }))
		vim.keymap.set({ "n", "v" }, "gd", "<CMD>Telescope lsp_definitions<CR>",
			vim.tbl_extend('force', opts, { desc = 'LSP Definitions' }))
		vim.keymap.set({ "n", "v" }, "gr", "<CMD>Telescope lsp_references<CR>",
			vim.tbl_extend('force', opts, { desc = 'LSP References' }))
		vim.keymap.set({ "n", "v" }, "gi", "<CMD>Telescope lsp_implementations<CR>",
			vim.tbl_extend('force', opts, { desc = 'LSP Implementations' }))
		vim.keymap.set({ "n", "v" }, "<leader>r", buf.rename, vim.tbl_extend('force', opts, { desc = 'LSP Rename' }))
		vim.keymap.set({ "n", "v" }, "<leader>a", require("actions-preview").code_actions,
			vim.tbl_extend('force', opts, { desc = 'LSP Code Actions' }))
		vim.keymap.set({ "n", "v" }, "+", function()
			buf.format({ async = true })
		end, opts)

		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = ev.buf,
			callback = function()
				vim.lsp.buf.format({
					buffer = ev.buf,
					async = false
				})
			end,
		})
	end,
})

-- Tree sitter
require('nvim-treesitter.install').compilers = { "clang" }
vim.api.nvim_create_autocmd('FileType', {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		local available_langs = require('nvim-treesitter').get_available()
		local is_available = vim.tbl_contains(available_langs, lang)
		if is_available then
			local installed_langs = require('nvim-treesitter').get_installed()
			local installed = vim.tbl_contains(installed_langs, lang)
			if not installed then
				require('nvim-treesitter').install(lang):wait()
			end
			vim.treesitter.start()
			require('nvim-treesitter').indentexpr()
		end
	end,
})
