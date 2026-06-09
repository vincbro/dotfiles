-- LSP
require('lazydev').setup({})
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
		vim.keymap.set({ "n", "v" }, "<leader>a", buf.code_action,
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
