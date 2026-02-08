vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", { buffer = 0 })
vim.keymap.set("n", "<leader>lf", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		if client:supports_method("textDocument/formatting") then
			vim.lsp.buf.format({ async = true })
			return
		end
	end

	-- No LSP formatter attached; fall back to typstyle via 'formatprg'.
	-- This formats the whole buffer using the format operator.
	-- Preserve cursor/topline; gq over whole buffer ends at EOF.
	local view = vim.fn.winsaveview()
	vim.cmd("silent keepjumps normal! gggqG")
	vim.fn.winrestview(view)
end, { buffer = 0, desc = "Format (LSP or typstyle)" })
vim.keymap.set({ "n", "x", "v" }, "j", "gj", { buffer = 0 })
vim.keymap.set({ "n", "x", "v" }, "k", "gk", { buffer = 0 })
vim.bo.formatprg = "typstyle"
vim.cmd([[
	setlocal wrapmargin=0
	setlocal formatoptions+=t
	setlocal linebreak
	setlocal spell
	setlocal wrap
]])
