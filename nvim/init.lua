vim.g.mapleader = ' '

-- Options
vim.o.autoread = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.confirm = true
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 16 
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.showtabline = 0
vim.o.smartindent = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true
vim.o.timeoutlen = 400
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.winborder = 'none'
vim.o.wrap = true

-- Plugins
vim.pack.add({
	{ src = 'https://github.com/savq/melange-nvim' },
	{ src = 'https://github.com/nvim-mini/mini.clue' },
	{ src = 'https://github.com/nvim-mini/mini.icons' },
	{ src = 'https://github.com/nvim-mini/mini.statusline' },
	{ src = 'https://github.com/folke/snacks.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.pick' },
	{ src = 'https://github.com/nvim-mini/mini.extra' },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/cbochs/grapple.nvim' },
	{ src = 'https://github.com/max397574/better-escape.nvim' },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('*') },
	{ src = 'https://github.com/folke/lazydev.nvim' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
	{ src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.surround' },
	{ src = 'https://github.com/nvim-mini/mini.pairs' },
	{ src = 'https://github.com/nvim-mini/mini.indentscope' },
	{ src = 'https://github.com/lewis6991/gitsigns.nvim' },
	{ src = 'https://github.com/j-hui/fidget.nvim' },
})

-- Theme and UI
vim.o.background = 'dark'
vim.cmd.colorscheme('melange')

local function text_width(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	return vim.bo[buf].textwidth > 0 and vim.bo[buf].textwidth or 80
end

local function centered_width()
	local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
	local gutter = info and info.textoff or 0
	return math.min(text_width() + gutter, math.max(1, vim.o.columns - 4))
end

local function can_center()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	if vim.api.nvim_win_get_config(win).relative ~= '' or vim.bo[buf].buftype ~= '' then
		return false
	end

	local normal_windows = 0
	for _, candidate in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(candidate).relative == '' then
			normal_windows = normal_windows + 1
		end
	end
	return normal_windows == 1
end

require('snacks').setup({
	bigfile = {},
	notifier = { timeout = 2500 },
	quickfile = {},
	zen = {
		toggles = { dim = false },
		show = { statusline = true, tabline = false },
	},
	styles = {
		zen = {
			width = centered_width,
			backdrop = { transparent = false, blend = 90 },
		},
	},
})

local icons = require('mini.icons')
icons.setup()
icons.mock_nvim_web_devicons()

local statusline = require('mini.statusline')
statusline.setup({
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local register = vim.fn.reg_recording()
			local recording = register == '' and '' or 'REC @' .. register
			local git = statusline.section_git({ trunc_width = 40 })
			local diff = statusline.section_diff({ trunc_width = 75 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local filename = statusline.section_filename({ trunc_width = 140 })
			local search = statusline.section_searchcount({ trunc_width = 75 })
			local location = statusline.section_location({ trunc_width = 75 })

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = 'DiagnosticError', strings = { recording } },
				{ hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
				'%<',
				{ hl = 'MiniStatuslineFilename', strings = { filename } },
				'%=',
				{ hl = 'MiniStatuslineFileinfo', strings = { diagnostics } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
})

local clue = require('mini.clue')
clue.setup({
	triggers = { { mode = { 'n', 'x' }, keys = '<Leader>' } },
	window = { delay = 400 },
})

-- Editing
local indentscope = require('mini.indentscope')
indentscope.setup({
	draw = { animation = indentscope.gen_animation.none() },
})
require('mini.pairs').setup()
require('mini.surround').setup({
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
require('better_escape').setup()
require('render-markdown').setup({ enabled = false })

-- Navigation
require('mini.extra').setup()
local pick = require('mini.pick')
pick.setup()
require('oil').setup({ watch_for_changes = true })

local grapple = require('grapple')
grapple.setup({ quick_select = 'qwertyuiop' })

local function project_root()
	return vim.fs.root(0, '.git') or vim.fn.getcwd()
end

local function pick_files()
	pick.builtin.files(nil, { source = { cwd = project_root() } })
end

local function pick_grep()
	pick.builtin.grep_live(nil, { source = { cwd = project_root() } })
end

-- Language tooling
require('lazydev').setup()
require('gitsigns').setup()
require('fidget').setup({})

vim.diagnostic.config({
	severity_sort = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	virtual_lines = { current_line = true },
	virtual_text = false,
})

require('blink.cmp').setup({
	keymap = {
		['<Tab>'] = { 'select_next', 'fallback' },
		['<S-Tab>'] = { 'select_prev', 'fallback' },
		['<CR>'] = { 'accept', 'fallback' },
	},
	completion = {
		list = {
			selection = { preselect = false, auto_insert = false },
		},
	},
})

vim.lsp.config('basedpyright', {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = 'basic',
				reportAny = false,
				reportUnknownMemberType = false,
				reportUnknownArgumentType = false,
			},
		},
	},
})

vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			check = {
				command = 'clippy',
				extraArgs = { '--', '-W', 'clippy::all' },
			},
		},
	},
})

vim.lsp.enable({
	'basedpyright',
	'clangd',
	'cssls',
	'emmet_language_server',
	'glsl_analyzer',
	'hls',
	'intelephense',
	'jsonls',
	'just',
	'lua_ls',
	'nixd',
	'ruff',
	'rust_analyzer',
	'solargraph',
	'svelte',
	'tailwindcss',
	'taplo',
	'tinymist',
	'ts_ls',
	'zls',
})

local treesitter = require('nvim-treesitter')
require('nvim-treesitter.install').compilers = { 'clang' }
require('nvim-treesitter-textobjects').setup()

local parser_installs = {}

local function start_treesitter(buf, lang)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end
	if vim.treesitter.language.get_lang(vim.bo[buf].filetype) ~= lang then
		return
	end
	if pcall(vim.treesitter.start, buf, lang) then
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local function ensure_treesitter(buf, filetype)
	local lang = vim.treesitter.language.get_lang(filetype)
	if not lang or not vim.tbl_contains(treesitter.get_available(), lang) then
		return
	end
	if vim.tbl_contains(treesitter.get_installed(), lang) then
		start_treesitter(buf, lang)
		return
	end
	if parser_installs[lang] then
		return
	end

	local task = treesitter.install(lang)
	parser_installs[lang] = task
	task:await(function(err)
		vim.schedule(function()
			parser_installs[lang] = nil
			if err then
				vim.notify(('Treesitter parser install failed for %s: %s'):format(lang, err), vim.log.levels.ERROR)
				return
			end
			for _, candidate in ipairs(vim.api.nvim_list_bufs()) do
				start_treesitter(candidate, lang)
			end
		end)
	end)
end

-- Autocommands
local group = vim.api.nvim_create_augroup('user_config', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
	group = group,
	callback = function()
		vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
		vim.wo.colorcolumn = vim.bo.buftype == '' and tostring(text_width()) or ''
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = group,
	callback = function(event)
		ensure_treesitter(event.buf, event.match)
	end,
})

vim.api.nvim_create_autocmd('VimEnter', {
	group = group,
	once = true,
	callback = function()
		vim.schedule(function()
			if can_center() then
				Snacks.zen()
			end
		end)
	end,
})

vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
	group = group,
	callback = function()
		vim.cmd.redrawstatus()
	end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('user_lsp', { clear = true }),
	callback = function(event)
		local function lsp_map(modes, lhs, rhs, desc)
			vim.keymap.set(modes, lhs, rhs, { buffer = event.buf, desc = desc })
		end

		lsp_map({ 'n', 'v' }, '<leader>k', vim.lsp.buf.hover, 'LSP hover')
		lsp_map({ 'n', 'v' }, 'gD', vim.lsp.buf.declaration, 'LSP declaration')
		lsp_map({ 'n', 'v' }, 'gd', function()
			require('mini.extra').pickers.lsp({ scope = 'definition' })
		end, 'LSP definitions')
		lsp_map({ 'n', 'v' }, 'gr', function()
			require('mini.extra').pickers.lsp({ scope = 'references' })
		end, 'LSP references')
		lsp_map({ 'n', 'v' }, 'gi', function()
			require('mini.extra').pickers.lsp({ scope = 'implementation' })
		end, 'LSP implementations')
		lsp_map({ 'n', 'v' }, '<leader>r', vim.lsp.buf.rename, 'LSP rename')
		lsp_map({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, 'LSP code actions')
	end,
})

-- Keymaps
local map = vim.keymap.set

map({ 'n', 'v' }, 'U', '<Cmd>redo<CR>', { desc = 'Redo' })
map({ 'n', 'v' }, 'H', '^', { desc = 'Start of line' })
map({ 'n', 'v' }, 'L', 'g_', { desc = 'End of line' })
map({ 'n', 'v' }, 'J', '<C-d>', { desc = 'Half-page down' })
map({ 'n', 'v' }, 'K', '<C-u>', { desc = 'Half-page up' })
map({ 'n', 'v' }, 'M', 'm', { desc = 'Set mark' })
map('n', 'j', 'gj', { silent = true })
map('n', 'k', 'gk', { silent = true })

map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })
map('n', '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('n', '<leader>z', function()
	Snacks.zen()
end, { desc = 'Toggle zen mode' })
map('n', '<leader>n', function()
	Snacks.notifier.show_history()
end, { desc = 'Notification history' })
map('n', '<leader>v', function()
	require('render-markdown').toggle()
end, { desc = 'Toggle Markdown rendering' })

map({ 'n', 'v' }, '<leader>e', '<Cmd>Oil<CR>', { desc = 'Open parent directory' })
map('n', '<leader>f', pick_files, { desc = 'Find files' })
map('n', '<leader>g', pick_grep, { desc = 'Live grep' })
map('n', '<leader>d', function()
	require('mini.extra').pickers.diagnostic({ scope = 'current' })
end, { desc = 'Buffer diagnostics' })
map('n', '<leader>D', function()
	require('mini.extra').pickers.diagnostic({ scope = 'all' })
end, { desc = 'All diagnostics' })
map('n', '<leader>s', function()
	require('mini.extra').pickers.lsp({ scope = 'document_symbol' })
end, { desc = 'Document symbols' })
map('n', '<leader>S', function()
	require('mini.extra').pickers.lsp({ scope = 'workspace_symbol_live' })
end, { desc = 'Workspace symbols' })
map('n', '<leader>t', function()
	vim.lsp.buf.format({ async = true })
end, { desc = 'Format buffer' })

map('n', '<leader>o', grapple.toggle, { desc = 'Toggle Grapple tag' })
map('n', '<leader>m', grapple.toggle_tags, { desc = 'Open Grapple tags' })

local textobjects = require('nvim-treesitter-textobjects.select')
map({ 'x', 'o' }, 'af', function()
	textobjects.select_textobject('@function.outer', 'textobjects')
end, { desc = 'Outer function' })
map({ 'x', 'o' }, 'if', function()
	textobjects.select_textobject('@function.inner', 'textobjects')
end, { desc = 'Inner function' })
map({ 'x', 'o' }, 'ac', function()
	textobjects.select_textobject('@class.outer', 'textobjects')
end, { desc = 'Outer class' })
map({ 'x', 'o' }, 'ic', function()
	textobjects.select_textobject('@class.inner', 'textobjects')
end, { desc = 'Inner class' })
map({ 'x', 'o' }, 'as', function()
	textobjects.select_textobject('@local.scope', 'locals')
end, { desc = 'Local scope' })
