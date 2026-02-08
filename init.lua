vim.opt.rtp:append("~/.local/share/nvim/site/pack/core/opt")
vim.opt.rtp:append("~/.config/nvim/plugins")
vim.opt.winborder = "rounded"
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.o.complete = ".,o"                       -- use buffer and omnifunc
vim.o.completeopt = "fuzzy,menuone,noselect" -- add 'popup' for docs (sometimes)
vim.o.autocomplete = true
vim.o.pumheight = 7
vim.opt.clipboard = "unnamedplus"

vim.g.have_nerd_font = true

local map = vim.keymap.set
vim.g.mapleader = " "
map("n", "<leader>o", ":update<CR> :source<CR>")

	vim.pack.add({
		{ src = "https://github.com/stevearc/oil.nvim" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "v0.9.3" },
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/mason-org/mason.nvim" },
		{ src = "https://github.com/nvim-mini/mini.pick" },
		{ src = "https://github.com/nvim-mini/mini.nvim" },
		{ src = "https://github.com/L3MON4D3/LuaSnip" },
		{ src = "https://github.com/chomosuke/typst-preview.nvim", version = "v1.*" },
		{ src = "https://github.com/neanias/everforest-nvim",         version = "main" },
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/nvimtools/none-ls.nvim",
		"https://github.com/nvimtools/none-ls-extras.nvim",
		"https://github.com/MeanderingProgrammer/render-markdown.nvim",
		{ src = "https://github.com/ibhagwan/fzf-lua" },
	})

require("mason").setup()
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})
require("mini.pick").setup()
require("fzf-lua").setup()
require("nvim-treesitter.configs").setup({
	ensure_installed = { "go", "lua", "vim", "json", "templ", "html" },
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
		disable = { "go" },
	},
})

require("render-markdown").setup({
	render_modes = { "n", "c", "t" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

map("n", "-", ":Oil<CR>")
map("n", "<leader>lf", vim.lsp.buf.format)

-- mini.pick
-- map("n", "<leader>ff", ":Pick files<CR>")
map("n", "<leader>h", ":Pick help<CR>")
map("n", "<leader>ff", ":FzfLua files<CR>")
map("n", "<leader>fg", ":FzfLua grep_visual<CR>")

-- mini.fuzzy

vim.lsp.enable({ "lua_ls", "gopls", "jsonls", "tinymist", "templ", "html" })

-- colors

require("everforest").setup()
vim.cmd("colorscheme everforest")

-- snippets
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")
map("i", "<C-e>", function()
	ls.expand_or_jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-j>", function()
	ls.jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-k>", function()
	ls.jump(-1)
end, { silent = true })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

		vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
		vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = 0 })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })

		vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
			-- Optional formating of items
			convert = function(item)
				-- Remove leading misc chars for abbr name,
				-- and cap field to 25 chars
				--local abbr = item.label
				--abbr = abbr:match("[%w_.]+.*") or abbr
				--abbr = #abbr > 25 and abbr:sub(1, 24) .. "…" or abbr
				--
				-- Remove return value
				--local menu = ""

				-- Only show abbr name, remove leading misc chars (bullets etc.),
				-- and cap field to 15 chars
				local abbr = item.label
				abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
				abbr = abbr:match("[%w_.]+.*") or abbr
				abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

				-- Cap return value field to 15 chars
				local menu = item.detail or ""
				menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

				return { abbr = abbr, menu = menu }
			end,
		})
	end,
})

require("plugins")
